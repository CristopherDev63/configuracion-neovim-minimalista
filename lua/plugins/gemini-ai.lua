-- lua/plugins/gemini-auto.lua
-- Gemini AI con autocompletado automático como Codeium

return {
	{
		"nvim-lua/plenary.nvim",
		config = function()
			local Job = require("plenary.job")

			-- ========== CONFIGURACIÓN GLOBAL ==========
			vim.g.gemini_enabled = true
			vim.g.gemini_auto_trigger = true -- NUEVO: autocompletado automático
			vim.g.gemini_trigger_length = 4 -- Caracteres mínimos para trigger
			vim.g.gemini_debounce_ms = 1500 -- Delay antes de activar (milisegundos)

			-- Variables internas
			local completion_cache = {}
			local completion_timer = nil
			local last_completion_line = 0
			local completion_namespace = vim.api.nvim_create_namespace("gemini_completion")

			-- ========== FUNCIÓN API GEMINI ==========
			local function call_gemini_api(prompt, callback)
				local api_key = vim.env.GEMINI_API_KEY

				if not api_key then
					return false
				end

				local url = string.format(
					"https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=%s",
					api_key
				)

				local data = vim.fn.json_encode({
					contents = {
						{
							parts = {
								{ text = prompt },
							},
						},
					},
					generationConfig = {
						temperature = 0.2,
						maxOutputTokens = 200,
						stopSequences = { "\n\n", "```" },
					},
				})

				Job:new({
					command = "curl",
					args = {
						"-s",
						"-X",
						"POST",
						"-H",
						"Content-Type: application/json",
						"-d",
						data,
						url,
					},
					on_exit = function(j, return_val)
						if return_val == 0 then
							local result = table.concat(j:result(), "\n")
							local ok, parsed = pcall(vim.fn.json_decode, result)

							if ok and parsed.candidates and parsed.candidates[1] then
								local text = parsed.candidates[1].content.parts[1].text
								callback(text)
							end
						end
					end,
				}):start()

				return true
			end

			-- ========== AUTOCOMPLETADO AUTOMÁTICO ==========
			local function show_inline_completion(completion_text)
				if not completion_text or completion_text == "" then
					return
				end

				-- Limpiar sugerencias anteriores
				vim.api.nvim_buf_clear_namespace(0, completion_namespace, 0, -1)

				-- Obtener posición actual
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				local row, col = cursor_pos[1] - 1, cursor_pos[2]

				-- Limpiar y procesar el texto de completado
				local clean_completion = completion_text:gsub("^%s+", ""):gsub("%s+$", "")
				clean_completion = clean_completion:gsub("```.-```", ""):gsub("```", "")

				-- Tomar solo la primera línea o hasta 80 caracteres
				local first_line = clean_completion:match("[^\n]+") or clean_completion
				if #first_line > 80 then
					first_line = first_line:sub(1, 80) .. "..."
				end

				-- Mostrar como texto virtual (ghost text)
				vim.api.nvim_buf_set_extmark(0, completion_namespace, row, col, {
					virt_text = { { first_line, "Comment" } },
					virt_text_pos = "inline",
					hl_mode = "combine",
				})

				-- Guardar la completación para aceptarla después
				vim.b.gemini_pending_completion = clean_completion
			end

			local function clear_inline_completion()
				vim.api.nvim_buf_clear_namespace(0, completion_namespace, 0, -1)
				vim.b.gemini_pending_completion = nil
			end

			local function accept_completion()
				local completion = vim.b.gemini_pending_completion
				if not completion then
					return false
				end

				-- Limpiar la sugerencia visual
				clear_inline_completion()

				-- Insertar el texto
				local lines = vim.split(completion, "\n")
				-- Solo insertar la primera línea para evitar ruido
				if lines[1] and lines[1] ~= "" then
					vim.api.nvim_put({ lines[1] }, "c", false, true)
				end

				return true
			end

			-- ========== TRIGGER AUTOMÁTICO ==========
			local function should_trigger_completion()
				if not vim.g.gemini_enabled or not vim.g.gemini_auto_trigger then
					return false
				end

				-- No activar en ciertos modos
				local mode = vim.api.nvim_get_mode().mode
				if mode ~= "i" then -- Solo en modo inserción
					return false
				end

				-- No activar en ciertos tipos de archivo
				local filetype = vim.bo.filetype
				local excluded_filetypes = { "", "text", "markdown", "help" }
				for _, ft in ipairs(excluded_filetypes) do
					if filetype == ft then
						return false
					end
				end

				-- Verificar longitud mínima
				local current_line = vim.fn.getline(".")
				local cursor_col = vim.fn.col(".")
				local before_cursor = current_line:sub(1, cursor_col - 1)

				-- Debe tener al menos X caracteres y no estar en string/comentario
				if #before_cursor < vim.g.gemini_trigger_length then
					return false
				end

				-- No activar si termina en espacios o ciertos caracteres
				if before_cursor:match("%s$") or before_cursor:match("[(){}%[%];,]$") then
					return false
				end

				return true
			end

			local function trigger_auto_completion()
				if not should_trigger_completion() then
					clear_inline_completion()
					return
				end

				-- Obtener contexto
				local current_line = vim.fn.getline(".")
				local cursor_col = vim.fn.col(".")
				local before_cursor = current_line:sub(1, cursor_col - 1)

				-- Cache para evitar llamadas repetidas
				local cache_key = before_cursor
				if completion_cache[cache_key] then
					show_inline_completion(completion_cache[cache_key])
					return
				end

				-- Contexto limitado para respuesta rápida
				local current_line_num = vim.fn.line(".")
				local start_line = math.max(1, current_line_num - 3)
				local context_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, current_line_num - 1, false)
				local context = table.concat(context_lines, "\n")

				local filetype = vim.bo.filetype

				local prompt = string.format(
					[[
Complete este código %s con UNA línea. Responde SOLO el código de completación, sin explicaciones:

Contexto:
%s

Completar: %s]],
					filetype,
					context,
					before_cursor
				)

				-- Mostrar indicador de carga
				vim.api.nvim_buf_set_extmark(0, completion_namespace, current_line_num - 1, cursor_col, {
					virt_text = { { "⚡", "DiagnosticInfo" } },
					virt_text_pos = "inline",
				})

				call_gemini_api(prompt, function(completion)
					vim.schedule(function()
						-- Guardar en cache
						completion_cache[cache_key] = completion

						-- Mostrar completación
						show_inline_completion(completion)
					end)
				end)
			end

			-- ========== AUTOCOMANDOS PARA TRIGGER AUTOMÁTICO ==========
			local function setup_auto_completion()
				-- Auto-comando para trigger automático
				vim.api.nvim_create_autocmd({ "TextChangedI" }, {
					callback = function()
						if completion_timer then
							vim.fn.timer_stop(completion_timer)
						end

						-- Limpiar completación anterior
						clear_inline_completion()

						-- Programar nueva completación con delay
						completion_timer = vim.fn.timer_start(vim.g.gemini_debounce_ms, function()
							trigger_auto_completion()
						end)
					end,
					desc = "Trigger automático de Gemini AI",
				})

				-- Limpiar al salir del modo inserción
				vim.api.nvim_create_autocmd({ "InsertLeave" }, {
					callback = function()
						clear_inline_completion()
						if completion_timer then
							vim.fn.timer_stop(completion_timer)
							completion_timer = nil
						end
					end,
					desc = "Limpiar completaciones de Gemini",
				})

				-- Limpiar al cambiar de buffer
				vim.api.nvim_create_autocmd({ "BufLeave" }, {
					callback = function()
						clear_inline_completion()
					end,
					desc = "Limpiar completaciones al cambiar buffer",
				})
			end

			-- ========== MAPEOS DE TECLADO ==========

			-- Mapeo principal: Tab para aceptar completación
			vim.keymap.set("i", "<Tab>", function()
				-- Si hay completación de Gemini disponible, aceptarla
				if accept_completion() then
					return
				end

				-- Si no, comportamiento normal de Tab
				if vim.fn.pumvisible() == 1 then
					return vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
				else
					return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
				end
			end, { expr = true, desc = "Aceptar completación Gemini o Tab normal" })

			-- Mapeo alternativo: Ctrl+G para forzar completación
			vim.keymap.set("i", "<C-g>", function()
				clear_inline_completion()
				trigger_auto_completion()
			end, { desc = "🤖 Forzar completación Gemini" })

			-- Escape para rechazar completación
			vim.keymap.set("i", "<Esc>", function()
				clear_inline_completion()
				return vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
			end, { expr = true, desc = "Rechazar completación y Escape" })

			-- Ctrl+E para rechazar completación sin salir de inserción
			vim.keymap.set("i", "<C-e>", function()
				clear_inline_completion()
			end, { desc = "Rechazar completación Gemini" })

			-- ========== COMANDOS DE CONTROL ==========
			vim.api.nvim_create_user_command("GeminiAutoToggle", function()
				vim.g.gemini_auto_trigger = not vim.g.gemini_auto_trigger
				local status = vim.g.gemini_auto_trigger and "ACTIVADO" or "DESACTIVADO"
				vim.notify("🤖 Autocompletado automático " .. status, vim.log.levels.INFO)
			end, { desc = "Toggle autocompletado automático" })

			vim.api.nvim_create_user_command("GeminiConfig", function()
				vim.notify(
					string.format(
						[[
🤖 CONFIGURACIÓN GEMINI AI:
Auto-trigger: %s
Caracteres mínimos: %d
Delay: %dms
API Key: %s

Mapeos:
Tab = Aceptar completación
Ctrl+G = Forzar completación  
Ctrl+E = Rechazar completación
]],
						vim.g.gemini_auto_trigger and "✅ SÍ" or "❌ NO",
						vim.g.gemini_trigger_length,
						vim.g.gemini_debounce_ms,
						vim.env.GEMINI_API_KEY and "✅ Configurada" or "❌ No configurada"
					),
					vim.log.levels.INFO
				)
			end, { desc = "Mostrar configuración actual" })

			vim.api.nvim_create_user_command("GeminiSettings", function()
				local trigger_length =
					vim.fn.input("Caracteres mínimos para trigger [" .. vim.g.gemini_trigger_length .. "]: ")
				if trigger_length ~= "" then
					vim.g.gemini_trigger_length = tonumber(trigger_length) or vim.g.gemini_trigger_length
				end

				local debounce = vim.fn.input("Delay en milisegundos [" .. vim.g.gemini_debounce_ms .. "]: ")
				if debounce ~= "" then
					vim.g.gemini_debounce_ms = tonumber(debounce) or vim.g.gemini_debounce_ms
				end

				vim.notify("⚙️ Configuración actualizada", vim.log.levels.INFO)
			end, { desc = "Configurar parámetros de Gemini" })

			-- ========== INICIALIZACIÓN ==========

			-- Configurar autocompletado automático si está habilitado
			if vim.g.gemini_auto_trigger then
				setup_auto_completion()
			end

			-- Verificar configuración al iniciar
			vim.defer_fn(function()
				if not vim.env.GEMINI_API_KEY then
					vim.notify("⚠️ GEMINI_API_KEY no configurada", vim.log.levels.WARN)
					vim.notify("💡 Configura: export GEMINI_API_KEY='tu_key'", vim.log.levels.INFO)
				else
					vim.notify("🤖 Gemini AI listo - Autocompletado automático activado", vim.log.levels.INFO)
				end
			end, 1000)

			print("🤖 Gemini AI con autocompletado automático configurado")
		end,
	},
}
