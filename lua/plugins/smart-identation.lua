-- lua/plugins/smart-indentation.lua
-- Indentación inteligente que se mantiene automáticamente en estructuras

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

			-- Comando para mostrar ayuda de indentación
			vim.api.nvim_create_user_command("SmartIndentHelp", function()
				local help_text = [[
🔧 INDENTACIÓN INTELIGENTE - COMANDOS:

📋 FUNCIONALIDAD:
  ✅ Mantiene automáticamente la indentación dentro de estructuras
  ✅ Detecta bloques de código (if, for, functions, etc.)
  ✅ Aplica indentación correcta al presionar Enter
  ✅ No sale de la estructura a menos que uses Shift+Tab

⌨️ CONTROLES:
  Enter       - Nueva línea con indentación inteligente
  Tab         - Indentar (solo al inicio de línea)
  Shift+Tab   - Des-indentar (retroceder un nivel)

🎯 DETECCIÓN AUTOMÁTICA:
  Python      - def, class, if, for, while, try, with, :
  JavaScript  - function, if, for, while, switch, {
  PHP         - function, if, foreach, for, while, class, {
  CSS         - selectores, @media, @keyframes, {
  HTML        - tags de apertura >
  Bash        - if, for, while, function, then, do

🔧 COMANDOS:
  :SmartIndentToggle  - Activar/desactivar
  :SmartIndentHelp    - Mostrar esta ayuda

💡 EJEMPLO DE USO:
  1. Escribes: if True:
  2. Presionas Enter
  3. Automáticamente se indenta al nivel correcto
  4. Continúas escribiendo dentro del bloque
  5. Para salir: Shift+Tab hasta el nivel deseado

🎨 CONFIGURACIÓN POR ARCHIVO:
  Python: 4 espacios
  JS/TS/CSS/HTML: 2 espacios  
  PHP: 4 espacios
  Bash: 2 espacios
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

			print("✅ Indentación inteligente cargada. Usa :SmartIndentHelp para más info")
		end,
	},
}
