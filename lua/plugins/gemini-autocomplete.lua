-- lua/plugins/gemini-autocomplete.lua
-- Plugin completo de autocompletado con Gemini AI

return {
	{
		"nvim-lua/plenary.nvim",
		config = function()
			local Job = require("plenary.job")

			-- ========== CONFIGURACIÓN GLOBAL ==========
			local M = {}
			M.enabled = true
			M.current_suggestion = nil
			M.suggestion_timer = nil
			M.namespace = vim.api.nvim_create_namespace("gemini_autocomplete")
			M.api_key = vim.env.GEMINI_API_KEY or ""
			M.last_request_time = 0
			M.rate_limit_delay = 500 -- milisegundos entre requests

			-- ========== CONFIGURACIÓN AJUSTABLE ==========
			M.config = {
				-- Tiempo de espera antes de hacer sugerencia (ms)
				delay = 800,
				-- Longitud mínima para activar
				min_chars = 3,
				-- Máximo de tokens en respuesta
				max_tokens = 100,
				-- Temperatura (0.1-1.0, menor = más conservador)
				temperature = 0.3,
				-- Archivos soportados
				supported_filetypes = {
					"python",
					"javascript",
					"typescript",
					"lua",
					"php",
					"bash",
					"sh",
					"html",
					"css",
					"java",
					"c",
					"cpp",
					"go",
					"rust",
				},
				-- Patrones a ignorar
				ignore_patterns = {
					"^%s*#", -- comentarios Python
					"^%s*//", -- comentarios JS/C++
					"^%s*/%*", -- comentarios multi-línea
					"^%s*%*", -- continuación comentario
					"[\"']", -- dentro de strings
				},
			}

			-- ========== FUNCIÓN PARA LLAMAR A GEMINI API ==========
			local function call_gemini_api(prompt, callback)
				if not M.api_key or M.api_key == "" then
					callback(nil, "API key no configurada")
					return
				end

				-- Rate limiting
				local current_time = vim.loop.now()
				if current_time - M.last_request_time < M.rate_limit_delay then
					return
				end
				M.last_request_time = current_time

				local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key="
					.. M.api_key

				local request_data = {
					contents = {
						{
							parts = {
								{ text = prompt },
							},
						},
					},
					generationConfig = {
						temperature = M.config.temperature,
						maxOutputTokens = M.config.max_tokens,
						stopSequences = { "\n\n", "```", "---" },
						candidateCount = 1,
					},
					safetySettings = {
						{
							category = "HARM_CATEGORY_HARASSMENT",
							threshold = "BLOCK_MEDIUM_AND_ABOVE",
						},
						{
							category = "HARM_CATEGORY_HATE_SPEECH",
							threshold = "BLOCK_MEDIUM_AND_ABOVE",
						},
					},
				}

				Job:new({
					command = "curl",
					args = {
						"-s",
						"-X",
						"POST",
						"-H",
						"Content-Type: application/json",
						"-H",
						"User-Agent: Neovim-Gemini-Plugin/1.0",
						"--connect-timeout",
						"10",
						"--max-time",
						"30",
						"-d",
						vim.fn.json_encode(request_data),
						url,
					},
					on_exit = function(j, return_val)
						if return_val == 0 then
							local result = table.concat(j:result(), "\n")
							local ok, parsed = pcall(vim.fn.json_decode, result)

							if ok and parsed.candidates and parsed.candidates[1] then
								local text = parsed.candidates[1].content.parts[1].text
								if text and text ~= "" then
									-- Limpiar y procesar la respuesta
									text = text:gsub("^%s+", ""):gsub("%s+$", "")
									text = text:gsub("\n.*", "") -- Solo primera línea
									callback(text, nil)
								else
									callback(nil, "Respuesta vacía")
								end
							elseif parsed.error then
								callback(nil, "Error API: " .. (parsed.error.message or "desconocido"))
							else
								callback(nil, "Formato de respuesta inválido")
							end
						else
							local error_msg = table.concat(j:stderr_result(), "\n")
							callback(nil, "Error de conexión: " .. error_msg)
						end
					end,
				}):start()
			end

			-- ========== FUNCIÓN PARA CONSTRUIR EL PROMPT ==========
			local function build_prompt(filetype, context, current_line, cursor_pos)
				local before_cursor = current_line:sub(1, cursor_pos - 1)

				local prompt = string.format(
					[[
Eres un asistente de código experto. Completa la línea de código actual.

INSTRUCCIONES:
- Responde SOLO con la continuación del código
- NO incluyas explicaciones, comentarios o texto adicional
- NO repitas el código que ya está escrito
- Sé preciso y sigue las convenciones del lenguaje
- Si es una función/método, incluye paréntesis apropiados
- Para variables, sugiere nombres descriptivos

Lenguaje: %s

Contexto (líneas anteriores):
%s

Completar esta línea:
%s]],
					filetype,
					context,
					before_cursor
				)

				return prompt
			end

			-- ========== FUNCIÓN PARA OBTENER CONTEXTO ==========
			local function get_context()
				local current_line_nr = vim.fn.line(".")
				local context_lines =
					vim.api.nvim_buf_get_lines(0, math.max(0, current_line_nr - 8), current_line_nr - 1, false)

				-- Filtrar líneas vacías y comentarios del contexto
				local filtered_context = {}
				for _, line in ipairs(context_lines) do
					if line:match("%S") and not line:match("^%s*#") and not line:match("^%s*//") then
						table.insert(filtered_context, line)
					end
				end

				return table.concat(filtered_context, "\n")
			end

			-- ========== FUNCIÓN PARA MOSTRAR SUGERENCIA ==========
			local function show_suggestion(text, line, col)
				if not text or text == "" then
					return
				end

				local bufnr = vim.api.nvim_get_current_buf()

				-- Limpiar sugerencias anteriores
				vim.api.nvim_buf_clear_namespace(bufnr, M.namespace, 0, -1)

				-- Procesar el texto de sugerencia
				local suggestion = text:gsub("^%s+", ""):gsub("%s+$", "")
				if suggestion == "" then
					return
				end

				M.current_suggestion = suggestion

				-- Mostrar como texto virtual
				vim.api.nvim_buf_set_extmark(bufnr, M.namespace, line - 1, col, {
					virt_text = { { suggestion, "Comment" } },
					virt_text_pos = "inline",
					hl_mode = "combine",
				})

				-- Mostrar indicador en la línea de comandos
				local truncated = suggestion:len() > 50 and suggestion:sub(1, 47) .. "..." or suggestion
				vim.api.nvim_echo({ { "Gemini: " .. truncated, "Comment" } }, false, {})

				-- Auto-limpiar después de 30 segundos
				vim.defer_fn(function()
					M.clear_suggestion()
				end, 30000)
			end

			-- ========== FUNCIÓN PARA LIMPIAR SUGERENCIAS ==========
			function M.clear_suggestion()
				vim.api.nvim_buf_clear_namespace(0, M.namespace, 0, -1)
				M.current_suggestion = nil
				vim.api.nvim_echo({}, false, {})
			end

			-- ========== FUNCIÓN PARA ACEPTAR SUGERENCIA ==========
			function M.accept_suggestion()
				if not M.current_suggestion then
					return false
				end

				local suggestion = M.current_suggestion
				M.clear_suggestion()

				-- Insertar la sugerencia
				local lines = { suggestion }
				vim.api.nvim_put(lines, "c", false, true)

				return true
			end

			-- ========== FUNCIÓN PRINCIPAL DE AUTOCOMPLETADO ==========
			local function trigger_autocomplete()
				if not M.enabled then
					return
				end

				local current_line = vim.api.nvim_get_current_line()
				local cursor_pos = vim.api.nvim_win_get_cursor(0)[2] + 1
				local before_cursor = current_line:sub(1, cursor_pos - 1)
				local filetype = vim.bo.filetype

				-- Verificar si el tipo de archivo está soportado
				if not vim.tbl_contains(M.config.supported_filetypes, filetype) then
					return
				end

				-- Verificar longitud mínima
				if before_cursor:len() < M.config.min_chars then
					return
				end

				-- Verificar patrones a ignorar
				for _, pattern in ipairs(M.config.ignore_patterns) do
					if before_cursor:match(pattern) then
						return
					end
				end

				-- Obtener contexto y construir prompt
				local context = get_context()
				local prompt = build_prompt(filetype, context, current_line, cursor_pos)

				-- Llamar a la API
				call_gemini_api(prompt, function(suggestion, error)
					if error then
						if M.config.debug then
							print("Gemini Error: " .. error)
						end
						return
					end

					if suggestion then
						vim.schedule(function()
							local line = vim.fn.line(".")
							local col = vim.fn.col(".") - 1
							show_suggestion(suggestion, line, col)
						end)
					end
				end)
			end

			-- ========== CONFIGURAR AUTO-TRIGGERS ==========
			local function setup_autocomplete_triggers()
				-- Limpiar timer anterior
				if M.suggestion_timer then
					vim.fn.timer_stop(M.suggestion_timer)
					M.suggestion_timer = nil
				end

				-- Trigger en cambios de texto
				vim.api.nvim_create_autocmd("TextChangedI", {
					callback = function()
						M.clear_suggestion()

						if M.suggestion_timer then
							vim.fn.timer_stop(M.suggestion_timer)
						end

						M.suggestion_timer = vim.fn.timer_start(M.config.delay, function()
							trigger_autocomplete()
						end)
					end,
					desc = "Trigger autocompletado Gemini",
				})

				-- Limpiar al salir de inserción
				vim.api.nvim_create_autocmd("InsertLeave", {
					callback = function()
						M.clear_suggestion()
						if M.suggestion_timer then
							vim.fn.timer_stop(M.suggestion_timer)
							M.suggestion_timer = nil
						end
					end,
					desc = "Limpiar sugerencias Gemini",
				})

				-- Limpiar al cambiar de buffer
				vim.api.nvim_create_autocmd("BufLeave", {
					callback = function()
						M.clear_suggestion()
					end,
					desc = "Limpiar sugerencias al cambiar buffer",
				})
			end

			-- ========== CONFIGURAR MAPEOS ==========
			local function setup_keymaps()
				-- Tab para aceptar sugerencia
				vim.keymap.set("i", "<Tab>", function()
					if M.current_suggestion then
						return M.accept_suggestion() and "" or "<Tab>"
					end
					return "<Tab>"
				end, { expr = true, desc = "Aceptar sugerencia Gemini" })

				-- Ctrl+G para forzar sugerencia
				vim.keymap.set("i", "<C-g>", function()
					M.clear_suggestion()
					trigger_autocomplete()
				end, { desc = "Forzar sugerencia Gemini" })

				-- Ctrl+E para rechazar
				vim.keymap.set("i", "<C-e>", function()
					M.clear_suggestion()
				end, { desc = "Rechazar sugerencia Gemini" })

				-- Alt+] para siguiente sugerencia
				vim.keymap.set("i", "<M-]>", function()
					M.clear_suggestion()
					vim.defer_fn(trigger_autocomplete, 100)
				end, { desc = "Nueva sugerencia Gemini" })
			end

			-- ========== COMANDOS VIM ==========
			local function setup_commands()
				vim.api.nvim_create_user_command("GeminiEnable", function()
					M.enabled = true
					setup_autocomplete_triggers()
					print("🤖 Gemini autocompletado ACTIVADO")
				end, { desc = "Activar Gemini" })

				vim.api.nvim_create_user_command("GeminiDisable", function()
					M.enabled = false
					M.clear_suggestion()
					if M.suggestion_timer then
						vim.fn.timer_stop(M.suggestion_timer)
						M.suggestion_timer = nil
					end
					print("🤖 Gemini autocompletado DESACTIVADO")
				end, { desc = "Desactivar Gemini" })

				vim.api.nvim_create_user_command("GeminiToggle", function()
					if M.enabled then
						vim.cmd("GeminiDisable")
					else
						vim.cmd("GeminiEnable")
					end
				end, { desc = "Toggle Gemini" })

				vim.api.nvim_create_user_command("GeminiStatus", function()
					local status = M.enabled and "✅ ACTIVADO" or "❌ DESACTIVADO"
					local api_status = (M.api_key and M.api_key ~= "") and "✅ Configurada" or "❌ No configurada"

					print("🤖 Gemini Autocompletado: " .. status)
					print("🔑 API Key: " .. api_status)
					print("⚡ Delay: " .. M.config.delay .. "ms")
					print("📝 Min chars: " .. M.config.min_chars)

					if M.current_suggestion then
						print("💡 Sugerencia activa: " .. M.current_suggestion:sub(1, 50))
					end
				end, { desc = "Ver estado de Gemini" })

				vim.api.nvim_create_user_command("GeminiConfig", function(opts)
					local args = vim.split(opts.args, " ")
					if #args == 2 then
						local key, value = args[1], args[2]
						if key == "delay" then
							M.config.delay = tonumber(value) or M.config.delay
							print("⚡ Delay configurado a: " .. M.config.delay .. "ms")
						elseif key == "min_chars" then
							M.config.min_chars = tonumber(value) or M.config.min_chars
							print("📝 Min chars configurado a: " .. M.config.min_chars)
						elseif key == "temperature" then
							M.config.temperature = tonumber(value) or M.config.temperature
							print("🌡️ Temperature configurada a: " .. M.config.temperature)
						else
							print("❌ Configuración no válida. Usa: delay, min_chars, temperature")
						end
					else
						print("Uso: :GeminiConfig <opción> <valor>")
						print("Opciones: delay, min_chars, temperature")
					end
				end, { nargs = "*", desc = "Configurar Gemini" })
			end

			-- ========== INICIALIZACIÓN ==========
			local function initialize()
				-- Verificar API key
				if not M.api_key or M.api_key == "" then
					print("⚠️ GEMINI_API_KEY no configurada")
					print("💡 Configura con: export GEMINI_API_KEY='tu_api_key'")
					print("🔗 Obtén tu API key en: https://makersuite.google.com/app/apikey")
					M.enabled = false
					return
				end

				-- Configurar todo
				setup_keymaps()
				setup_commands()

				if M.enabled then
					setup_autocomplete_triggers()
				end

				-- Exponer funciones globalmente
				_G.GeminiAutocomplete = M

				print("🤖 Gemini Autocompletado cargado exitosamente")
				print("💡 Controles: Tab=Aceptar | Ctrl+G=Forzar | Ctrl+E=Rechazar")
				print("📋 Comandos: :GeminiStatus | :GeminiToggle | :GeminiConfig")
			end

			-- Inicializar después de un breve delay
			vim.defer_fn(initialize, 1000)
		end,
	},
}
