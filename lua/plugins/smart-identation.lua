-- lua/plugins/smart-indentation.lua
-- Indentación inteligente que se mantiene automáticamente en estructuras
-- CON BACKSPACE AUTOMÁTICO COMO VSCODE

return {
	{
		"nvim-lua/plenary.nvim",
		config = function()
			-- ========== CONFIGURACIÓN DE INDENTACIÓN INTELIGENTE ==========

			-- Función para detectar si estamos dentro de una estructura
			local function get_current_indent_level()
				local current_line = vim.fn.line(".")
				local current_col = vim.fn.col(".")
				local lines = vim.api.nvim_buf_get_lines(0, 0, current_line, false)

				local indent_level = 0
				local in_structure = false

				-- Patrones que indican el inicio de una estructura
				local structure_patterns = {
					-- Python
					":%s*$", -- : al final (if, for, def, etc)
					"^%s*def%s", -- definición de función
					"^%s*class%s", -- definición de clase
					"^%s*if%s", -- if statement
					"^%s*elif%s", -- elif statement
					"^%s*else:%s*$", -- else statement
					"^%s*for%s", -- for loop
					"^%s*while%s", -- while loop
					"^%s*try:%s*$", -- try block
					"^%s*except", -- except block
					"^%s*finally:%s*$", -- finally block
					"^%s*with%s", -- with statement

					-- JavaScript/TypeScript
					"{%s*$", -- { al final
					"^%s*function%s", -- function declaration
					"^%s*if%s*%(", -- if statement
					"^%s*for%s*%(", -- for loop
					"^%s*while%s*%(", -- while loop
					"^%s*switch%s*%(", -- switch statement
					"^%s*try%s*{", -- try block
					"^%s*catch%s*%(", -- catch block

					-- PHP
					"^%s*<?php", -- PHP opening tag
					"^%s*function%s", -- function declaration
					"^%s*if%s*%(", -- if statement
					"^%s*foreach%s*%(", -- foreach loop
					"^%s*for%s*%(", -- for loop
					"^%s*while%s*%(", -- while loop
					"^%s*switch%s*%(", -- switch statement
					"^%s*class%s", -- class declaration

					-- HTML
					"^%s*<%w+", -- opening tag

					-- CSS
					"{%s*$", -- CSS rule opening
					"^%s*@media", -- media query
					"^%s*@keyframes", -- keyframes

					-- Bash
					"^%s*if%s", -- if statement
					"^%s*for%s", -- for loop
					"^%s*while%s", -- while loop
					"^%s*function%s", -- function declaration
					"^%s*case%s", -- case statement
				}

				-- Patrones que indican el final de una estructura
				local end_patterns = {
					-- Python (usa indentación, no palabras clave de cierre)

					-- JavaScript/TypeScript/PHP/CSS
					"}%s*$", -- closing brace
					"^%s*}%s*$", -- standalone closing brace

					-- HTML
					"^%s*</%w+>", -- closing tag

					-- Bash
					"^%s*fi%s*$", -- end if
					"^%s*done%s*$", -- end for/while
					"^%s*esac%s*$", -- end case
				}

				-- Analizar líneas anteriores para determinar el nivel de indentación
				for i = #lines, 1, -1 do
					local line = lines[i]
					local line_indent = line:match("^%s*") or ""

					-- Si encontramos una línea con contenido
					if line:match("%S") then
						-- Verificar si es el inicio de una estructura
						for _, pattern in ipairs(structure_patterns) do
							if line:match(pattern) then
								indent_level = #line_indent + vim.bo.shiftwidth
								in_structure = true
								break
							end
						end

						-- Si no encontramos inicio de estructura, usar la indentación de la línea anterior
						if not in_structure then
							indent_level = #line_indent
						end
						break
					end
				end

				return indent_level, in_structure
			end

			-- Función para aplicar indentación inteligente
			local function smart_indent()
				local current_line = vim.fn.getline(".")
				local cursor_pos = vim.fn.col(".")
				local filetype = vim.bo.filetype

				-- Obtener nivel de indentación esperado
				local expected_indent, in_structure = get_current_indent_level()

				-- Solo aplicar si estamos en una estructura
				if in_structure then
					local current_indent = current_line:match("^%s*") or ""

					-- Si la indentación actual es menor que la esperada, corregir
					if #current_indent < expected_indent then
						local spaces_needed = expected_indent - #current_indent
						local new_line = string.rep(" ", expected_indent) .. current_line:match("^%s*(.*)$")

						vim.fn.setline(".", new_line)
						vim.fn.cursor(".", cursor_pos + spaces_needed)
					end
				end
			end

			-- Función personalizada para Enter inteligente
			local function smart_enter()
				local current_line = vim.fn.getline(".")
				local filetype = vim.bo.filetype
				local cursor_pos = vim.fn.col(".")

				-- Patrones que requieren indentación extra después de Enter
				local indent_patterns = {
					python = {
						":%s*$", -- : al final
						"=%s*$", -- = al final (asignación multilínea)
						"%(%s*$", -- ( al final (función/lista multilínea)
						"%[%s*$", -- [ al final (lista)
						"{%s*$", -- { al final (dict)
					},
					javascript = {
						"{%s*$", -- { al final
						"%(%s*$", -- ( al final
						"%[%s*$", -- [ al final
					},
					typescript = {
						"{%s*$", -- { al final
						"%(%s*$", -- ( al final
						"%[%s*$", -- [ al final
					},
					php = {
						"{%s*$", -- { al final
						"%(%s*$", -- ( al final
						"%[%s*$", -- [ al final
					},
					css = {
						"{%s*$", -- { al final
					},
					html = {
						">%s*$", -- > al final (tag abierto)
					},
					bash = {
						"then%s*$", -- then
						"do%s*$", -- do
						"{%s*$", -- { al final
					},
				}

				-- Ejecutar Enter normal primero
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)

				-- Verificar si necesitamos indentación extra
				local patterns = indent_patterns[filetype] or {}
				local needs_indent = false

				for _, pattern in ipairs(patterns) do
					if current_line:match(pattern) then
						needs_indent = true
						break
					end
				end

				-- Aplicar indentación extra si es necesario
				if needs_indent then
					local current_indent = current_line:match("^%s*") or ""
					local extra_indent = string.rep(" ", vim.bo.shiftwidth)
					vim.api.nvim_feedkeys(current_indent .. extra_indent, "n", false)
				end
			end

			-- Función para des-indentar inteligente
			local function smart_unindent()
				local current_line = vim.fn.getline(".")
				local current_indent = current_line:match("^%s*") or ""
				local shiftwidth = vim.bo.shiftwidth

				if #current_indent >= shiftwidth then
					local new_indent = string.rep(" ", #current_indent - shiftwidth)
					local line_content = current_line:match("^%s*(.*)$") or ""
					vim.fn.setline(".", new_indent .. line_content)

					-- Ajustar posición del cursor
					local cursor_col = vim.fn.col(".")
					vim.fn.cursor(".", math.max(1, cursor_col - shiftwidth))
				else
					-- Si no hay suficiente indentación, quitar toda
					local line_content = current_line:match("^%s*(.*)$") or ""
					vim.fn.setline(".", line_content)
					vim.fn.cursor(".", 1)
				end
			end

			-- ========== FUNCIÓN: BACKSPACE AUTOMÁTICO COMO VSCODE ==========
			local function auto_smart_backspace()
				local current_line = vim.fn.getline(".")
				local cursor_col = vim.fn.col(".")
				local before_cursor = current_line:sub(1, cursor_col - 1)
				local shiftwidth = vim.bo.shiftwidth
				local filetype = vim.bo.filetype

				-- Si estamos al inicio de la línea, comportamiento normal
				if cursor_col <= 1 then
					return vim.api.nvim_replace_termcodes("<BS>", true, false, true)
				end

				-- Si solo hay espacios antes del cursor (estamos en indentación)
				if before_cursor:match("^%s*$") and #before_cursor > 0 then
					-- Detectar contexto del bloque actual
					local line_num = vim.fn.line(".")
					local lines = vim.api.nvim_buf_get_lines(0, 0, line_num, false)

					local context_indent = 0
					local in_block = false

					-- Buscar líneas anteriores para determinar contexto
					for i = #lines - 1, 1, -1 do
						local line = lines[i]
						if line:match("%S") then
							local line_indent = #(line:match("^%s*") or "")

							-- Patrones que indican inicio de bloque por lenguaje
							local block_patterns = {
								python = {
									":%s*$",
									"^%s*def%s",
									"^%s*class%s",
									"^%s*if%s",
									"^%s*elif%s",
									"^%s*else:%s*$",
									"^%s*for%s",
									"^%s*while%s",
									"^%s*try:%s*$",
									"^%s*except",
									"^%s*finally:%s*$",
									"^%s*with%s",
								},
								javascript = {
									"{%s*$",
									"^%s*function%s",
									"^%s*if%s*%(",
									"^%s*for%s*%(",
									"^%s*while%s*%(",
									"^%s*switch%s*%(",
									"^%s*try%s*{",
								},
								typescript = {
									"{%s*$",
									"^%s*function%s",
									"^%s*if%s*%(",
									"^%s*for%s*%(",
									"^%s*while%s*%(",
									"^%s*switch%s*%(",
									"^%s*interface%s",
									"^%s*class%s",
								},
								php = {
									"{%s*$",
									"^%s*function%s",
									"^%s*if%s*%(",
									"^%s*foreach%s*%(",
									"^%s*for%s*%(",
									"^%s*while%s*%(",
									"^%s*class%s",
									"^%s*switch%s*%(",
								},
								css = {
									"{%s*$",
									"^%s*@media",
									"^%s*@keyframes",
									"^%s*@supports",
								},
								html = {
									">%s*$",
								},
								bash = {
									"then%s*$",
									"do%s*$",
									"{%s*$",
									"^%s*function%s",
									"^%s*if%s",
									"^%s*for%s",
									"^%s*while%s",
									"^%s*case%s",
								},
								lua = {
									"then%s*$",
									"do%s*$",
									"^%s*function%s",
									"^%s*if%s",
									"^%s*for%s",
									"^%s*while%s",
									"^%s*repeat%s",
								},
							}

							local patterns = block_patterns[filetype] or {}
							for _, pattern in ipairs(patterns) do
								if line:match(pattern) then
									in_block = true
									context_indent = line_indent + shiftwidth
									break
								end
							end

							-- Si no es inicio de bloque, usar su indentación como contexto
							if not in_block then
								context_indent = line_indent
							end
							break
						end
					end

					-- Lógica inteligente: NO salir del bloque automáticamente
					local current_indent = #before_cursor

					if in_block and current_indent > context_indent then
						-- Estamos en bloque, mantener al menos la indentación del bloque
						local target_indent = math.max(context_indent, current_indent - shiftwidth)
						local spaces_to_delete = current_indent - target_indent

						-- Eliminar espacios hasta llegar al target
						for i = 1, spaces_to_delete do
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS>", true, false, true), "n", false)
						end
						return ""
					else
						-- No estamos en bloque o ya estamos en nivel mínimo
						-- Eliminar por nivel de shiftwidth
						local spaces_to_delete = current_indent % shiftwidth
						if spaces_to_delete == 0 then
							spaces_to_delete = shiftwidth
						end

						-- Pero nunca eliminar más de lo que hay
						spaces_to_delete = math.min(spaces_to_delete, current_indent)

						for i = 1, spaces_to_delete do
							vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<BS>", true, false, true), "n", false)
						end
						return ""
					end
				else
					-- Comportamiento normal si no estamos en espacios de indentación
					return vim.api.nvim_replace_termcodes("<BS>", true, false, true)
				end
			end

			-- ========== FUNCIÓN PARA DETECTAR SI LÍNEA ESTÁ VACÍA EN BLOQUE ==========
			local function handle_empty_line_in_block()
				local current_line = vim.fn.getline(".")
				local line_num = vim.fn.line(".")
				local filetype = vim.bo.filetype

				-- Solo aplicar si la línea está vacía o solo tiene espacios
				if not current_line:match("^%s*$") then
					return
				end

				local lines = vim.api.nvim_buf_get_lines(0, 0, line_num, false)
				local shiftwidth = vim.bo.shiftwidth

				-- Buscar contexto en líneas anteriores
				for i = #lines - 1, 1, -1 do
					local line = lines[i]
					if line:match("%S") then
						local line_indent = #(line:match("^%s*") or "")

						-- Patrones de inicio de bloque
						local block_patterns = {
							python = {
								":%s*$",
								"^%s*def%s",
								"^%s*class%s",
								"^%s*if%s",
								"^%s*for%s",
								"^%s*while%s",
								"^%s*try:%s*$",
								"^%s*with%s",
							},
							javascript = { "{%s*$", "^%s*function%s", "^%s*if%s*%(", "^%s*for%s*%(", "^%s*while%s*%(" },
							php = { "{%s*$", "^%s*function%s", "^%s*if%s*%(", "^%s*for%s*%(", "^%s*class%s" },
							css = { "{%s*$", "^%s*@media" },
							bash = { "then%s*$", "do%s*$", "{%s*$" },
						}

						local patterns = block_patterns[filetype] or {}
						for _, pattern in ipairs(patterns) do
							if line:match(pattern) then
								-- Encontramos inicio de bloque, aplicar indentación automática
								local expected_indent = line_indent + shiftwidth
								local current_indent = #(current_line:match("^%s*") or "")

								if current_indent < expected_indent then
									local spaces_needed = expected_indent - current_indent
									local new_line = string.rep(" ", expected_indent)
									vim.fn.setline(".", new_line)
									vim.fn.cursor(".", expected_indent + 1)
								end
								return
							end
						end
						break
					end
				end
			end

			-- ========== CONFIGURAR AUTOCOMANDOS ==========

			-- Auto-comando para aplicar indentación inteligente al entrar en modo inserción
			vim.api.nvim_create_autocmd("InsertEnter", {
				pattern = "*",
				callback = function()
					-- Aplicar indentación inteligente después de un pequeño delay
					vim.defer_fn(smart_indent, 10)
				end,
				desc = "Aplicar indentación inteligente al entrar en modo inserción",
			})

			-- Auto-comando para mantener indentación al cambiar de línea
			vim.api.nvim_create_autocmd("CursorMovedI", {
				pattern = "*",
				callback = function()
					local current_line = vim.fn.getline(".")
					-- Solo aplicar si la línea está vacía o solo tiene espacios
					if current_line:match("^%s*$") then
						vim.defer_fn(smart_indent, 1)
					end
					-- También manejar líneas vacías en bloques
					vim.defer_fn(handle_empty_line_in_block, 1)
				end,
				desc = "Mantener indentación inteligente al mover cursor",
			})

			-- ========== CONFIGURAR MAPEOS ==========

			-- Mapeo para Enter inteligente
			vim.keymap.set("i", "<CR>", smart_enter, {
				desc = "↩️ Enter con indentación inteligente",
				noremap = true,
				silent = true,
			})

			-- Mapeo para Tab inteligente (solo para indentación, no para autocompletado)
			vim.keymap.set("i", "<Tab>", function()
				local current_line = vim.fn.getline(".")
				local cursor_col = vim.fn.col(".")

				-- Si estamos al inicio de la línea o solo hay espacios antes del cursor
				local before_cursor = current_line:sub(1, cursor_col - 1)
				if before_cursor:match("^%s*$") then
					-- Aplicar indentación
					local shiftwidth = vim.bo.shiftwidth
					vim.api.nvim_feedkeys(string.rep(" ", shiftwidth), "n", false)
				else
					-- Tab normal
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
				end
			end, {
				desc = "➡️ Tab inteligente para indentación",
				noremap = true,
				silent = true,
			})

			-- Mapeo para Shift+Tab (des-indentar)
			vim.keymap.set("i", "<S-Tab>", smart_unindent, {
				desc = "⬅️ Shift+Tab para des-indentar",
				noremap = true,
				silent = true,
			})

			-- ========== MAPEO PRINCIPAL: BACKSPACE AUTOMÁTICO COMO VSCODE ==========
			vim.keymap.set("i", "<BS>", auto_smart_backspace, {
				desc = "⬅️ Backspace automático que mantiene bloques (como VSCode)",
				noremap = true,
				silent = true,
				expr = true,
			})

			-- Mapeo para des-indentar en modo normal
			vim.keymap.set("n", "<S-Tab>", function()
				smart_unindent()
			end, {
				desc = "⬅️ Des-indentar línea actual",
				noremap = true,
				silent = true,
			})

			-- ========== CONFIGURACIÓN ESPECÍFICA POR TIPO DE ARCHIVO ==========

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "python", "javascript", "typescript", "php", "css", "html", "bash", "lua" },
				callback = function()
					local filetype = vim.bo.filetype

					-- Configuración específica de indentación por tipo de archivo
					if filetype == "python" then
						vim.bo.expandtab = true
						vim.bo.shiftwidth = 4
						vim.bo.tabstop = 4
						vim.bo.softtabstop = 4
					elseif
						filetype == "javascript"
						or filetype == "typescript"
						or filetype == "css"
						or filetype == "html"
					then
						vim.bo.expandtab = true
						vim.bo.shiftwidth = 2
						vim.bo.tabstop = 2
						vim.bo.softtabstop = 2
					elseif filetype == "php" then
						vim.bo.expandtab = true
						vim.bo.shiftwidth = 4
						vim.bo.tabstop = 4
						vim.bo.softtabstop = 4
					elseif filetype == "bash" then
						vim.bo.expandtab = true
						vim.bo.shiftwidth = 2
						vim.bo.tabstop = 2
						vim.bo.softtabstop = 2
					elseif filetype == "lua" then
						vim.bo.expandtab = true
						vim.bo.shiftwidth = 4
						vim.bo.tabstop = 4
						vim.bo.softtabstop = 4
					end

					-- Habilitar auto-indentación
					vim.bo.autoindent = true
					vim.bo.smartindent = true

					print("🔧 Indentación inteligente activada para " .. filetype)
				end,
				desc = "Configurar indentación inteligente por tipo de archivo",
			})

			-- ========== CONFIGURACIÓN ADICIONAL DE BACKSPACE ==========
			-- Mejorar comportamiento general de backspace
			vim.opt.backspace = "indent,eol,start"
			vim.opt.smarttab = true

			-- ========== COMANDOS ADICIONALES ==========

			-- Comando para alternar indentación inteligente
			vim.api.nvim_create_user_command("SmartIndentToggle", function()
				if vim.g.smart_indent_enabled == nil then
					vim.g.smart_indent_enabled = true
				end

				vim.g.smart_indent_enabled = not vim.g.smart_indent_enabled

				if vim.g.smart_indent_enabled then
					print("✅ Indentación inteligente ACTIVADA")
				else
					print("❌ Indentación inteligente DESACTIVADA")
				end
			end, { desc = "Toggle indentación inteligente" })

			-- Comando para mostrar ayuda de indentación (ACTUALIZADO)
			vim.api.nvim_create_user_command("SmartIndentHelp", function()
				local help_text = [[
🔧 INDENTACIÓN INTELIGENTE CON BACKSPACE AUTOMÁTICO:

📋 FUNCIONALIDAD PRINCIPAL:
  ✅ Mantiene automáticamente la indentación dentro de estructuras
  ✅ Detecta bloques de código (if, for, functions, etc.)
  ✅ Aplica indentación correcta al presionar Enter
  ✅ 🆕 BACKSPACE AUTOMÁTICO: NO se sale del bloque como VSCode
  ✅ Respeta niveles mínimos de indentación en bloques

⌨️ CONTROLES:
  Enter       - Nueva línea con indentación inteligente
  Tab         - Indentar (solo al inicio de línea)
  Shift+Tab   - Des-indentar (retroceder un nivel completo)
  Backspace   - 🆕 INTELIGENTE: Mantiene dentro del bloque actual

🎯 DETECCIÓN AUTOMÁTICA POR LENGUAJE:
  Python      - def, class, if, for, while, try, with, elif, else, :
  JavaScript  - function, if, for, while, switch, try, {
  TypeScript  - function, if, for, while, interface, class, {
  PHP         - function, if, foreach, for, while, class, switch, {
  CSS         - selectores, @media, @keyframes, @supports, {
  HTML        - tags de apertura >
  Bash        - if, for, while, function, then, do, case, {
  Lua         - function, if, for, while, repeat, then, do

🔧 COMANDOS:
  :SmartIndentToggle  - Activar/desactivar funcionalidad
  :SmartIndentHelp    - Mostrar esta ayuda

💡 COMPORTAMIENTO DEL BACKSPACE AUTOMÁTICO:
  
  Ejemplo en Python:
  def mi_funcion():
      if True:
          print("test")
          |  ← Cursor aquí (8 espacios)
  
  Al presionar Backspace:
  - ANTES: Te sacaba completamente del 'if' (0 espacios)
  - AHORA: Te lleva a 4 espacios (mantiene dentro del 'if')
  
  Para salir completamente: Usa Shift+Tab o múltiples Backspace

🎨 CONFIGURACIÓN POR ARCHIVO:
  Python/PHP/Lua: 4 espacios por nivel
  JS/TS/CSS/HTML/Bash: 2 espacios por nivel

✨ BENEFICIOS DEL BACKSPACE AUTOMÁTICO:
  🚫 No más salidas accidentales de bloques
  ⚡ Edición más rápida y fluida
  🎯 Comportamiento consistente como VSCode
  🧠 Contexto inteligente por tipo de archivo
  💡 Mantiene la estructura lógica del código

🔄 PARA SALIR COMPLETAMENTE DE UN BLOQUE:
  1. Usa Shift+Tab (recomendado)
  2. O presiona Backspace múltiples veces
  3. O escribe código al nivel deseado directamente
]]

				-- Mostrar en buffer temporal
				local buf = vim.api.nvim_create_buf(false, true)
				local lines = vim.split(help_text, "\n")
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
				vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
				vim.cmd("split")
				vim.api.nvim_win_set_buf(0, buf)
			end, { desc = "Mostrar ayuda de indentación inteligente" })

			-- Inicializar como activado
			vim.g.smart_indent_enabled = true

			print("✅ Indentación inteligente cargada con Backspace automático como VSCode")
			print("🎯 Usa :SmartIndentHelp para ver todas las funcionalidades")
		end,
	},
}
