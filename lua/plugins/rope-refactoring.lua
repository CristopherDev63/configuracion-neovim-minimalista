-- lua/plugins/rope-refactoring.lua
-- Rope refactoring automático como en PyCharm/IntelliJ

return {
	-- ========== ROPE - REFACTORING INTELIGENTE ==========
	{
		"python-rope/ropevim",
		ft = "python",
		build = function()
			-- Instalar rope automáticamente si no está instalado
			vim.fn.system("pip3 install --user rope")
		end,
		config = function()
			-- ========== CONFIGURACIÓN DE ROPE ==========

			-- Habilitar rope solo para Python
			vim.g.ropevim_enable_shortcuts = 1
			vim.g.ropevim_guess_project = 1
			vim.g.ropevim_enable_autoimport = 1

			-- Configuración de rope
			vim.g.ropevim_autoimport_modules = { "os", "sys", "json", "datetime", "requests", "pathlib" }

			-- print("🔧 Rope configurado - Refactoring inteligente habilitado")
		end,
	},

	-- ========== REFACTORING MODERNO ALTERNATIVO ==========
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup({
				prompt_func_return_type = {
					go = false,
					java = false,
					cpp = false,
					c = false,
					h = false,
					hpp = false,
					cxx = false,
				},
				prompt_func_param_type = {
					go = false,
					java = false,
					cpp = false,
					c = false,
					h = false,
					hpp = false,
					cxx = false,
				},
				printf_statements = {},
				print_var_statements = {},
				show_success_message = true,
			})

			-- ========== MAPEOS DE REFACTORING ==========
			local keymap = vim.keymap
			local opts = { noremap = true, silent = true }

			-- Refactoring básico
			keymap.set("x", "<leader>re", ":Refactor extract ", opts)
			keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", opts)
			keymap.set("x", "<leader>rv", ":Refactor extract_var ", opts)
			keymap.set("n", "<leader>rI", ":Refactor inline_var", opts)
			keymap.set("n", "<leader>rb", ":Refactor extract_block", opts)
			keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file", opts)

			-- Refactoring específico de Python
			keymap.set("x", "<leader>rm", function()
				require("refactoring").refactor("Extract Function")
			end, { desc = "🔧 Extraer función" })

			keymap.set("x", "<leader>rc", function()
				require("refactoring").refactor("Extract Variable")
			end, { desc = "🔧 Extraer variable" })

			keymap.set("n", "<leader>ri", function()
				require("refactoring").refactor("Inline Variable")
			end, { desc = "🔧 Inline variable" })

			-- Debug statements automáticos
			keymap.set("n", "<leader>rp", function()
				require("refactoring").debug.printf({ below = false })
			end, { desc = "🐛 Agregar print debug" })

			keymap.set("n", "<leader>rv", function()
				require("refactoring").debug.print_var({ normal = true })
			end, { desc = "🐛 Print variable" })

			keymap.set("v", "<leader>rv", function()
				require("refactoring").debug.print_var({})
			end, { desc = "🐛 Print variable seleccionada" })

			keymap.set("n", "<leader>rc", function()
				require("refactoring").debug.cleanup({})
			end, { desc = "🧹 Limpiar debug prints" })

			-- print("✅ Refactoring moderno configurado")
		end,
	},

	-- ========== FUNCIONALIDADES ADICIONALES DE REFACTORING ==========
	{
		"nvim-lua/plenary.nvim",
		config = function()
			-- ========== FUNCIONES PERSONALIZADAS DE REFACTORING ==========

			-- Función para renombrar variable en todo el proyecto
			local function rename_in_project()
				local word = vim.fn.expand("<cword>")
				local new_name = vim.fn.input("Nuevo nombre para '" .. word .. "': ")

				if new_name ~= "" then
					-- Usar LSP rename si está disponible
					vim.lsp.buf.rename(new_name)
					print("🔄 Variable renombrada: " .. word .. " → " .. new_name)
				end
			end

			-- Función para extraer constante
			local function extract_constant()
				local line = vim.fn.getline(".")
				local value = vim.fn.input("Valor de la constante: ")
				local name = vim.fn.input("Nombre de la constante (MAYÚSCULAS): ")

				if value ~= "" and name ~= "" then
					-- Agregar constante al inicio del archivo
					vim.api.nvim_buf_set_lines(0, 0, 0, false, {
						name:upper() .. " = " .. value,
						"",
					})
					print("✅ Constante creada: " .. name:upper())
				end
			end

			-- Función para crear función desde selección
			local function create_function_from_selection()
				local start_pos = vim.fn.getpos("'<")
				local end_pos = vim.fn.getpos("'>")

				local function_name = vim.fn.input("Nombre de la nueva función: ")
				if function_name == "" then
					return
				end

				-- Obtener líneas seleccionadas
				local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

				-- Crear función
				local new_function = {
					"",
					"def " .. function_name .. "():",
				}

				-- Indentar líneas seleccionadas
				for _, line in ipairs(lines) do
					table.insert(new_function, "    " .. line)
				end

				table.insert(new_function, "")

				-- Insertar función al final del archivo
				local total_lines = vim.api.nvim_buf_line_count(0)
				vim.api.nvim_buf_set_lines(0, total_lines, total_lines, false, new_function)

				-- Reemplazar selección con llamada a función
				vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, end_pos[2], false, {
					function_name .. "()",
				})

				print("🎉 Función '" .. function_name .. "' creada y extraída")
			end

			-- Función para organizar imports automáticamente
			local function organize_imports()
				local filetype = vim.bo.filetype

				if filetype == "python" then
					-- Usar isort si está disponible
					if vim.fn.executable("isort") == 1 then
						vim.cmd("!isort %")
						print("📋 Imports organizados con isort")
					else
						print("⚠️ isort no instalado: pip install isort")
					end
				elseif filetype == "javascript" or filetype == "typescript" then
					-- Organizar imports JS/TS con LSP
					vim.lsp.buf.execute_command({
						command = "typescript.organizeImports",
						arguments = { vim.api.nvim_buf_get_name(0) },
					})
					print("📋 Imports JS/TS organizados")
				end
			end

			-- ========== MAPEOS PERSONALIZADOS ==========
			local keymap = vim.keymap

			keymap.set("n", "<leader>rr", rename_in_project, { desc = "🔄 Renombrar en proyecto" })
			keymap.set("n", "<leader>rk", extract_constant, { desc = "🔧 Extraer constante" })
			keymap.set("v", "<leader>rf", create_function_from_selection, { desc = "⚡ Crear función" })
			keymap.set("n", "<leader>ro", organize_imports, { desc = "📋 Organizar imports" })

			-- ========== AUTO-COMANDOS PARA REFACTORING ==========

			-- Organizar imports automáticamente al guardar (opcional)
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.py",
				callback = function()
					if vim.g.auto_organize_imports then
						organize_imports()
					end
				end,
				desc = "Organizar imports automáticamente",
			})

			-- Comando para activar/desactivar auto-organización
			vim.api.nvim_create_user_command("AutoOrganizeImports", function()
				vim.g.auto_organize_imports = not vim.g.auto_organize_imports
				local status = vim.g.auto_organize_imports and "ACTIVADO" or "DESACTIVADO"
				print("📋 Auto-organizar imports: " .. status)
			end, { desc = "Toggle auto-organización de imports" })

			-- print("🔧 Funciones de refactoring personalizadas configuradas")
		end,
	},

	-- ========== COMANDOS DE AYUDA ==========
	{
		"nvim-lua/plenary.nvim", -- Ya cargado
		config = function()
			-- Comando de ayuda para refactoring
			vim.api.nvim_create_user_command("RefactorHelp", function()
				local help_text = [[
🔧 REFACTORING - COMANDOS DISPONIBLES:

📋 REFACTORING BÁSICO:
  <leader>re  - Extraer selección
  <leader>rf  - Extraer a archivo
  <leader>rv  - Extraer variable
  <leader>ri  - Inline variable
  <leader>rb  - Extraer bloque
  <leader>rm  - Extraer función (selección)
  <leader>rc  - Extraer variable (selección)

🔄 REFACTORING AVANZADO:
  <leader>rr  - Renombrar en proyecto
  <leader>rk  - Extraer constante
  <leader>rf  - Crear función (selección)
  <leader>ro  - Organizar imports

🐛 DEBUG AUTOMÁTICO:
  <leader>rp  - Agregar print debug
  <leader>rv  - Print variable
  <leader>rc  - Limpiar debug prints

🔧 COMANDOS:
  :AutoOrganizeImports - Toggle auto-organización
  :RefactorHelp        - Mostrar esta ayuda

💡 EJEMPLO DE USO:
  1. Selecciona código repetido
  2. <leader>rm - Extraer función
  3. Escribe nombre de función
  4. ¡Listo! Código refactorizado

🎯 ROPE (Solo Python):
  - Refactoring automático inteligente
  - Renombrado seguro en todo el proyecto
  - Extracción de métodos avanzada
  - Auto-import inteligente

📚 REQUISITOS:
  pip install rope isort

🚀 FLUJO RECOMENDADO:
  1. Escribe código funcionando
  2. Usa refactoring para limpiarlo
  3. Organiza imports automáticamente
  4. ¡Código profesional y mantenible!
]]

				-- Mostrar en buffer temporal
				local buf = vim.api.nvim_create_buf(false, true)
				local lines = vim.split(help_text, "\n")
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
				vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
				vim.cmd("split")
				vim.api.nvim_win_set_buf(0, buf)
			end, { desc = "Mostrar ayuda de refactoring" })

			-- print("✅ Rope y Refactoring configurados. Usa :RefactorHelp para ver comandos")
		end,
	},
}
