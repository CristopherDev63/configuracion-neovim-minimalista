-- lua/plugins/gemini-ai.lua
-- Gemini AI simplificado y funcional

return {
	{
		"nvim-lua/plenary.nvim",
		config = function()
			local Job = require("plenary.job")

			-- ========== CONFIGURACIÓN ==========
			vim.g.gemini_enabled = true
			vim.g.gemini_delay = 2000 -- 2 segundos de delay

			-- Variables internas
			local completion_timer = nil
			local completion_namespace = vim.api.nvim_create_namespace("gemini_completion")

			-- ========== FUNCIÓN API GEMINI ==========
			local function call_gemini_api(prompt, callback)
				local api_key = vim.env.GEMINI_API_KEY

				if not api_key then
					print("❌ GEMINI_API_KEY no configurada")
					return
				end

				local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key="
					.. api_key

				local data = vim.fn.json_encode({
					contents = {
						{
							parts = {
								{ text = prompt },
							},
						},
					},
					generationConfig = {
						temperature = 0.1,
						maxOutputTokens = 100,
						stopSequences = { "\n\n" },
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
			end

			-- ========== MOSTRAR SUGERENCIA ==========
			local function show_suggestion(text)
				if not text or text == "" then
					return
				end

				-- Limpiar sugerencias anteriores
				vim.api.nvim_buf_clear_namespace(0, completion_namespace, 0, -1)

				-- Procesar texto
				local clean_text = text:gsub("^%s+", ""):gsub("%s+$", "")
				local first_line = clean_text:match("[^\n]+") or clean_text
				if #first_line > 60 then
					first_line = first_line:sub(1, 60) .. "..."
				end

				-- Mostrar como ghost text
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				local row, col = cursor_pos[1] - 1, cursor_pos[2]

				vim.api.nvim_buf_set_extmark(0, completion_namespace, row, col, {
					virt_text = { { first_line, "Comment" } },
					virt_text_pos = "inline",
				})

				-- Guardar para aceptar después
				vim.b.gemini_suggestion = clean_text
				print("💡 Gemini: Presiona Ctrl+Y para aceptar")
			end

			-- ========== ACEPTAR SUGERENCIA ==========
			local function accept_suggestion()
				local suggestion = vim.b.gemini_suggestion
				if not suggestion then
					print("❌ No hay sugerencia de Gemini")
					return
				end

				-- Limpiar visual
				vim.api.nvim_buf_clear_namespace(0, completion_namespace, 0, -1)

				-- Insertar solo la primera línea
				local first_line = suggestion:match("[^\n]+") or suggestion
				vim.api.nvim_put({ first_line }, "c", false, true)

				-- Limpiar
				vim.b.gemini_suggestion = nil
				print("✅ Sugerencia de Gemini aceptada")
			end

			-- ========== RECHAZAR SUGERENCIA ==========
			local function reject_suggestion()
				vim.api.nvim_buf_clear_namespace(0, completion_namespace, 0, -1)
				vim.b.gemini_suggestion = nil
				print("❌ Sugerencia de Gemini rechazada")
			end

			-- ========== TRIGGER AUTOMÁTICO ==========
			local function trigger_completion()
				if not vim.g.gemini_enabled then
					return
				end

				local filetype = vim.bo.filetype
				if filetype == "" or filetype == "help" then
					return
				end

				-- Obtener contexto
				local current_line = vim.fn.getline(".")
				local cursor_col = vim.fn.col(".")
				local before_cursor = current_line:sub(1, cursor_col - 1)

				-- Verificar longitud mínima
				if #before_cursor < 10 then
					return
				end

				-- Obtener líneas anteriores para contexto
				local line_num = vim.fn.line(".")
				local start_line = math.max(1, line_num - 5)
				local context_lines = vim.api.nvim_buf_get_lines(0, start_line - 1, line_num - 1, false)
				local context = table.concat(context_lines, "\n")

				local prompt = string.format(
					[[
Completa este código %s con UNA línea. Responde SOLO el código, sin explicaciones:

Contexto:
%s

Completar: %s]],
					filetype,
					context,
					before_cursor
				)

				-- Mostrar indicador
				vim.api.nvim_buf_set_extmark(0, completion_namespace, line_num - 1, cursor_col, {
					virt_text = { { "⚡ Gemini...", "DiagnosticInfo" } },
					virt_text_pos = "inline",
				})

				call_gemini_api(prompt, function(completion)
					vim.schedule(function()
						show_suggestion(completion)
					end)
				end)
			end

			-- ========== MAPEOS ==========
			-- Ctrl+G para trigger manual
			vim.keymap.set("i", "<C-g>", function()
				reject_suggestion() -- Limpiar anterior
				trigger_completion()
			end, { desc = "🤖 Completación Gemini" })

			-- Ctrl+Y para aceptar (estándar Vim)
			vim.keymap.set("i", "<C-y>", accept_suggestion, { desc = "✅ Aceptar Gemini" })

			-- Ctrl+E para rechazar
			vim.keymap.set("i", "<C-e>", reject_suggestion, { desc = "❌ Rechazar Gemini" })

			-- ========== AUTO-COMANDOS ==========
			-- Trigger automático después de pausa
			vim.api.nvim_create_autocmd({ "TextChangedI" }, {
				callback = function()
					-- Limpiar timer anterior
					if completion_timer then
						vim.fn.timer_stop(completion_timer)
					end

					-- Limpiar sugerencia anterior
					reject_suggestion()

					-- Programar nueva sugerencia
					completion_timer = vim.fn.timer_start(vim.g.gemini_delay, function()
						trigger_completion()
					end)
				end,
			})

			-- Limpiar al salir de inserción
			vim.api.nvim_create_autocmd({ "InsertLeave" }, {
				callback = function()
					reject_suggestion()
					if completion_timer then
						vim.fn.timer_stop(completion_timer)
						completion_timer = nil
					end
				end,
			})

			-- ========== COMANDOS ==========
			vim.api.nvim_create_user_command("GeminiToggle", function()
				vim.g.gemini_enabled = not vim.g.gemini_enabled
			end, {})

			vim.api.nvim_create_user_command("GeminiTest", function()
				if vim.env.GEMINI_API_KEY then
					print("✅ API Key configurada")
					trigger_completion()
				else
					print("❌ Configura: export GEMINI_API_KEY='tu_key'")
				end
			end, {})

			-- ========== VERIFICACIÓN INICIAL ==========
			vim.defer_fn(function()
				if not vim.env.GEMINI_API_KEY then
					print("⚠️ Configura tu API Key: export GEMINI_API_KEY='tu_key'")
				else
					print("🤖 Gemini AI listo - Usa Ctrl+G para probar")
				end
			end, 1000)
		end,
	},
}
