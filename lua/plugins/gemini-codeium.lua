-- lua/plugins/gemini-codeium.lua
-- Gemini AI como Codeium - Autocompletado automático

return {
	{
		"nvim-lua/plenary.nvim",
		config = function()
			local Job = require("plenary.job")

			-- ========== CONFIGURACIÓN ==========
			local M = {}
			M.enabled = true
			M.current_suggestion = nil
			M.suggestion_id = 0
			M.namespace = vim.api.nvim_create_namespace("gemini_suggestion")

			-- ========== CONFIGURACIÓN GEMINI API ==========
			local function call_gemini(prompt, callback)
				local api_key = vim.env.GEMINI_API_KEY
				if not api_key then
					return
				end

				local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=" .. api_key

				local request_data = {
					contents = {
						{
							parts = {
								{ text = prompt }
							}
						}
					},
					generationConfig = {
						temperature = 0.2,
						maxOutputTokens = 50,
						stopSequences = { "\n", "```" }
					}
				}

				Job:new({
					command = "curl",
					args = {
						"-s", "-X", "POST",
						"-H", "Content-Type: application/json",
						"-d", vim.fn.json_encode(request_data),
						url
					},
					on_exit = function(j, return_val)
						if return_val == 0 then
							local result = table.concat(j:result(), "\n")
							local ok, parsed = pcall(vim.fn.json_decode, result)
							if ok and parsed.candidates and parsed.candidates[1] then
								local text = parsed.candidates[1].content.parts[1].text
								if text and text ~= "" then
									callback(text:gsub("^%s+", ""):gsub("%s+$", ""))
								end
							end
						end
					end
				}):start()
			end

			-- ========== MOSTRAR SUGERENCIA COMO CODEIUM ==========
			local function show_suggestion(text)
				if not text or text == "" then return end

				local bufnr = vim.api.nvim_get_current_buf()
				local cursor = vim.api.nvim_win_get_cursor(0)
				local row, col = cursor[1] - 1, cursor[2]

				-- Limpiar sugerencias anteriores
				vim.api.nvim_buf_clear_namespace(bufnr, M.namespace, 0, -1)

				-- Guardar sugerencia
				M.current_suggestion = text
				M.suggestion_id = M.suggestion_id + 1

				-- Mostrar como texto ghost (gris)
				vim.api.nvim_buf_set_extmark(bufnr, M.namespace, row, col, {
					virt_text = {{ text, "Comment" }},
					virt_text_pos = "inline",
					hl_mode = "combine"
				})

				-- Indicador en la línea de estado
				vim.api.nvim_echo({{ "Gemini: " .. text:sub(1, 30) .. (text:len() > 30 and "..." or ""), "Comment" }}, false, {})
			end

			-- ========== LIMPIAR SUGERENCIAS ==========
			local function clear_suggestion()
				vim.api.nvim_buf_clear_namespace(0, M.namespace, 0, -1)
				M.current_suggestion = nil
				vim.api.nvim_echo({}, false, {})
			end

			-- ========== ACEPTAR SUGERENCIA ==========
			local function accept_suggestion()
				if not M.current_suggestion then
					return false
				end

				clear_suggestion()
				
				-- Insertar texto en el cursor
				local lines = { M.current_suggestion }
				vim.api.nvim_put(lines, "c", false, true)
				
				M.current_suggestion = nil
				return true
			end

			-- ========== GENERAR SUGERENCIA AUTOMÁTICA ==========
			local function generate_suggestion()
				if not M.enabled then return end

				local current_line = vim.api.nvim_get_current_line()
				local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
				local before_cursor = current_line:sub(1, cursor_col)
				
				-- Solo sugerir si hay contenido suficiente
				if before_cursor:len() < 5 then return end
				
				-- No sugerir en comentarios o strings
				if before_cursor:match("#") or before_cursor:match("\"") or before_cursor:match("'") then
					return
				end

				-- Obtener contexto (líneas anteriores)
				local current_line_nr = vim.fn.line(".")
				local context_lines = vim.api.nvim_buf_get_lines(0, math.max(0, current_line_nr - 5), current_line_nr - 1, false)
				local context = table.concat(context_lines, "\n")
				
				local filetype = vim.bo.filetype
				
				local prompt = string.format([[
Eres un asistente de código. Completa esta línea con la continuación más probable.
Responde SOLO con el código de completación, sin explicaciones.

Tipo de archivo: %s
Contexto:
%s

Completar: %s]], filetype, context, before_cursor)

				call_gemini(prompt, function(suggestion)
					vim.schedule(function()
						show_suggestion(suggestion)
					end)
				end)
			end

			-- ========== MAPEOS COMO CODEIUM ==========
			
			-- Tab para aceptar (como Codeium)
			vim.keymap.set("i", "<Tab>", function()
				-- Si hay sugerencia de Gemini, aceptarla
				if M.current_suggestion then
					accept_suggestion()
					return
				end
				
				-- Si no, Tab normal
				return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
			end, { expr = true, desc = "Aceptar sugerencia Gemini" })

			-- Ctrl+] para siguiente sugerencia (como Codeium Ctrl+])
			vim.keymap.set("i", "<C-]>", function()
				clear_suggestion()
				generate_suggestion()
			end, { desc = "Nueva sugerencia Gemini" })

			-- Alt+\ para siguiente sugerencia alternativa (como Codeium)
			vim.keymap.set("i", "<M-\\>", function()
				clear_suggestion()
				generate_suggestion()
			end, { desc = "Siguiente sugerencia Gemini" })

			-- Escape para limpiar sugerencia
			vim.keymap.set("i", "<C-e>", function()
				clear_suggestion()
			end, { desc = "Rechazar sugerencia Gemini" })

			-- ========== AUTO-TRIGGER ==========
			local completion_timer = nil

			vim.api.nvim_create_autocmd("TextChangedI", {
				callback = function()
					-- Limpiar timer anterior
					if completion_timer then
						vim.fn.timer_stop(completion_timer)
					end
					
					-- Limpiar sugerencia anterior
					clear_suggestion()
					
					-- Nueva sugerencia después de 1 segundo
					completion_timer = vim.fn.timer_start(1000, function()
						generate_suggestion()
					end)
				end
			})

			-- Limpiar al salir de inserción
			vim.api.nvim_create_autocmd("InsertLeave", {
				callback = function()
					clear_suggestion()
					if completion_timer then
						vim.fn.timer_stop(completion_timer)
						completion_timer = nil
					end
				end
			})

			-- ========== COMANDOS ==========
			vim.api.nvim_create_user_command("GeminiEnable", function()
				M.enabled = true
				print("🤖 Gemini Codeium: ACTIVADO")
			end, {})

			vim.api.nvim_create_user_command("GeminiDisable", function()
				M.enabled = false
				clear_suggestion()
				print("🤖 Gemini Codeium: DESACTIVADO")
			end, {})

			vim.api.nvim_create_user_command("GeminiToggle", function()
				M.enabled = not M.enabled
				if not M.enabled then
					clear_suggestion()
				end
				print("🤖 Gemini Codeium: " .. (M.enabled and "ACTIVADO" or "DESACTIVADO"))
			end, {})

			vim.api.nvim_create_user_command("GeminiStatus", function()
				local status = M.enabled and "✅ ACTIVADO" or "❌ DESACTIVADO"
				local api_status = vim.env.GEMINI_API_KEY and "✅ Configurada" or "❌ No configurada"
				print("🤖 Gemini Codeium: " .. status)
				print("🔑 API Key: " .. api_status)
				if M.current_suggestion then
					print("💡 Sugerencia activa: " .. M.current_suggestion:sub(1, 50))
				end
			end, {})

			-- ========== VERIFICACIÓN INICIAL ==========
			vim.defer_fn(function()
				if not vim.env.GEMINI_API_KEY then
					print("⚠️ Configura tu API Key: export GEMINI_API_KEY='tu_key'")
					print("💡 Luego reinicia Neovim")
				else
					print("🤖 Gemini Codeium listo - Como GitHub Copilot")
					print("💡 Tab=Aceptar | Ctrl+]=Nueva | Ctrl+E=Rechazar")
				end
			end, 1500)

			-- Asignar a global para acceso
			_G.GeminiCodeium = M
		end
	}
}
