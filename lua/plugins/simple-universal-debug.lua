-- lua/plugins/simple-universal-debug.lua
-- Debugging simple universal que ejecuta archivos según su extensión

return {
	{
		"nvim-lua/plenary.nvim",
		config = function()
			-- ========== CONFIGURACIÓN DE DEBUG UNIVERSAL ==========

			-- Función principal para ejecutar archivo según extensión
			local function execute_current_file()
				local filename = vim.fn.expand("%")
				local filepath = vim.fn.expand("%:p")
				local filetype = vim.bo.filetype
				local extension = vim.fn.expand("%:e")

				-- Verificar si el archivo existe
				if filename == "" then
					print("❌ No hay archivo abierto")
					return
				end

				if not vim.fn.filereadable(filepath) == 1 then
					print("❌ Archivo no existe o no se puede leer")
					return
				end

				-- Guardar archivo antes de ejecutar
				vim.cmd("write")

				-- Obtener comando según extensión/tipo
				local cmd = get_execution_command(extension, filetype, filepath)

				if not cmd then
					print("❌ Tipo de archivo no soportado: " .. extension)
					print(
						"💡 Tipos soportados: .py, .js, .ts, .php, .lua, .sh, .bash, .java, .c, .cpp, .go, .rs, .rb"
					)
					return
				end

				-- CAMBIO: Solo mostrar que se está ejecutando SIN nombre de archivo
				-- Usar códigos ANSI para color verde
				print("\27[32m🚀 Ejecutando código...\27[0m")

				-- Ejecutar en terminal split (sin mostrar nombre de archivo)
				execute_in_terminal(cmd, "output")
			end

			-- Función para obtener comando de ejecución
			function get_execution_command(extension, filetype, filepath)
				local commands = {
					-- Python
					py = function()
						if vim.fn.executable("python3") == 1 then
							return "python3 " .. filepath
						elseif vim.fn.executable("python") == 1 then
							return "python " .. filepath
						end
						return nil
					end,

					-- JavaScript
					js = function()
						if vim.fn.executable("node") == 1 then
							return "node " .. filepath
						end
						return nil
					end,

					-- TypeScript
					ts = function()
						if vim.fn.executable("ts-node") == 1 then
							return "ts-node " .. filepath
						elseif vim.fn.executable("tsc") == 1 then
							local js_file = filepath:gsub("%.ts$", ".js")
							return "tsc " .. filepath .. " && node " .. js_file
						end
						return nil
					end,

					-- PHP
					php = function()
						if vim.fn.executable("php") == 1 then
							return "php " .. filepath
						end
						return nil
					end,

					-- Lua
					lua = function()
						if vim.fn.executable("lua") == 1 then
							return "lua " .. filepath
						end
						return nil
					end,

					-- Shell Scripts
					sh = function()
						if vim.fn.executable("bash") == 1 then
							return "bash " .. filepath
						elseif vim.fn.executable("sh") == 1 then
							return "sh " .. filepath
						end
						return nil
					end,

					-- Bash
					bash = function()
						if vim.fn.executable("bash") == 1 then
							return "bash " .. filepath
						end
						return nil
					end,

					-- Java
					java = function()
						if vim.fn.executable("javac") == 1 and vim.fn.executable("java") == 1 then
							local classname = vim.fn.expand("%:t:r")
							local dir = vim.fn.expand("%:h")
							return "cd " .. dir .. " && javac " .. vim.fn.expand("%:t") .. " && java " .. classname
						end
						return nil
					end,

					-- C
					c = function()
						if vim.fn.executable("gcc") == 1 then
							local output = filepath:gsub("%.c$", "")
							return "gcc " .. filepath .. " -o " .. output .. " && " .. output
						end
						return nil
					end,

					-- C++
					cpp = function()
						if vim.fn.executable("g++") == 1 then
							local output = filepath:gsub("%.cpp$", "")
							return "g++ " .. filepath .. " -o " .. output .. " && " .. output
						end
						return nil
					end,

					-- Go
					go = function()
						if vim.fn.executable("go") == 1 then
							return "go run " .. filepath
						end
						return nil
					end,

					-- Rust
					rs = function()
						if vim.fn.executable("rustc") == 1 then
							local output = filepath:gsub("%.rs$", "")
							return "rustc " .. filepath .. " -o " .. output .. " && " .. output
						elseif vim.fn.executable("cargo") == 1 then
							return "cargo run"
						end
						return nil
					end,

					-- Ruby
					rb = function()
						if vim.fn.executable("ruby") == 1 then
							return "ruby " .. filepath
						end
						return nil
					end,

					-- Python específico para automatización
					python = function()
						return commands.py()
					end,

					-- JavaScript específico
					javascript = function()
						return commands.js()
					end,

					-- Shell específico
					shell = function()
						return commands.sh()
					end,
				}

				-- Primero intentar por extensión
				local cmd_func = commands[extension]
				if cmd_func then
					return cmd_func()
				end

				-- Luego intentar por filetype
				cmd_func = commands[filetype]
				if cmd_func then
					return cmd_func()
				end

				return nil
			end

			-- Función para ejecutar en terminal
			local function execute_in_terminal(cmd, display_name)
				-- Cerrar terminal anterior si existe
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					local name = vim.api.nvim_buf_get_name(buf)
					if string.match(name, "term://.*simple%-debug") then
						if vim.api.nvim_buf_is_valid(buf) then
							vim.api.nvim_buf_delete(buf, { force = true })
						end
					end
				end

				-- Crear nuevo terminal split
				vim.cmd("split")
				vim.cmd("resize 12")

				-- Ejecutar comando en terminal
				local term_cmd = string.format("terminal ++curwin ++kill=term %s", cmd)
				vim.cmd(term_cmd)

				-- Agregar indicador visual genérico (SIN nombre de archivo)
				vim.defer_fn(function()
					vim.api.nvim_buf_set_name(0, "term://simple-debug-output")
				end, 100)

				-- Cambiar focus de vuelta al archivo original
				vim.defer_fn(function()
					vim.cmd("wincmd p")
				end, 200)
			end

			-- Función para debug con argumentos
			local function execute_with_args()
				local filename = vim.fn.expand("%")
				local args = vim.fn.input("Argumentos: ") -- SIN mostrar nombre de archivo

				if args ~= "" then
					local filepath = vim.fn.expand("%:p")
					local extension = vim.fn.expand("%:e")
					local filetype = vim.bo.filetype

					vim.cmd("write")

					local base_cmd = get_execution_command(extension, filetype, filepath)
					if base_cmd then
						local cmd_with_args = base_cmd .. " " .. args
						-- CAMBIO: Mensaje limpio en verde
						print("\27[32m🚀 Ejecutando con argumentos...\27[0m")
						execute_in_terminal(cmd_with_args, "output-args")
					end
				end
			end

			-- Función para ejecutar solo selección (Python/JavaScript)
			local function execute_selection()
				local filetype = vim.bo.filetype

				if filetype ~= "python" and filetype ~= "javascript" and filetype ~= "lua" then
					print("❌ Ejecución de selección solo soportada para Python, JavaScript y Lua")
					return
				end

				-- Obtener líneas seleccionadas
				local start_pos = vim.fn.getpos("'<")
				local end_pos = vim.fn.getpos("'>")
				local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

				if #lines == 0 then
					print("❌ No hay selección")
					return
				end

				-- Crear archivo temporal
				local temp_file = "/tmp/nvim_selection."
					.. (filetype == "python" and "py" or filetype == "javascript" and "js" or "lua")
				vim.fn.writefile(lines, temp_file)

				-- Ejecutar archivo temporal
				local cmd
				if filetype == "python" then
					cmd = "python3 " .. temp_file
				elseif filetype == "javascript" then
					cmd = "node " .. temp_file
				elseif filetype == "lua" then
					cmd = "lua " .. temp_file
				end

				-- CAMBIO: Mensaje limpio en verde
				print("\27[32m🎯 Ejecutando selección...\27[0m")
				execute_in_terminal(cmd, "output-selection")

				-- Limpiar archivo temporal después
				vim.defer_fn(function()
					vim.fn.delete(temp_file)
				end, 1000)
			end

			-- Función para limpiar terminales de debug
			local function clean_debug_terminals()
				local count = 0
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					local name = vim.api.nvim_buf_get_name(buf)
					if string.match(name, "term://.*simple%-debug") or string.match(name, "term://.*selección") then
						if vim.api.nvim_buf_is_valid(buf) then
							vim.api.nvim_buf_delete(buf, { force = true })
							count = count + 1
						end
					end
				end
				print("🧹 " .. count .. " terminales de debug cerrados")
			end

			-- ========== MAPEOS DE TECLADO ==========
			local keymap = vim.keymap

			-- Mapeo principal - F9 para ejecutar archivo completo
			keymap.set("n", "<F9>", execute_current_file, {
				desc = "🚀 Ejecutar archivo actual",
				noremap = true,
				silent = false,
			})

			-- Mapeo alternativo con leader
			keymap.set("n", "<leader>dr", execute_current_file, {
				desc = "🚀 Debug: Ejecutar archivo",
				noremap = true,
				silent = false,
			})

			-- Ejecutar con argumentos
			keymap.set("n", "<F10>", execute_with_args, {
				desc = "⚙️ Ejecutar con argumentos",
				noremap = true,
				silent = false,
			})

			keymap.set("n", "<leader>da", execute_with_args, {
				desc = "⚙️ Debug: Ejecutar con argumentos",
				noremap = true,
				silent = false,
			})

			-- Ejecutar selección
			keymap.set("v", "<F9>", execute_selection, {
				desc = "🎯 Ejecutar selección",
				noremap = true,
				silent = false,
			})

			keymap.set("v", "<leader>ds", execute_selection, {
				desc = "🎯 Debug: Ejecutar selección",
				noremap = true,
				silent = false,
			})

			-- Limpiar terminales
			keymap.set("n", "<leader>dc", clean_debug_terminals, {
				desc = "🧹 Limpiar terminales debug",
				noremap = true,
				silent = false,
			})

			-- Mapeo rápido con Shift+Enter (alternativo)
			keymap.set("n", "<S-CR>", execute_current_file, {
				desc = "🚀 Ejecutar archivo (alternativo)",
				noremap = true,
				silent = false,
			})

			-- ========== COMANDOS VIM ==========
			vim.api.nvim_create_user_command("DebugRun", execute_current_file, {
				desc = "Ejecutar archivo actual",
			})

			vim.api.nvim_create_user_command("DebugArgs", execute_with_args, {
				desc = "Ejecutar archivo con argumentos",
			})

			vim.api.nvim_create_user_command("DebugClean", clean_debug_terminals, {
				desc = "Limpiar terminales de debug",
			})

			-- ========== AUTO-COMANDOS ==========

			-- Mostrar mensaje de ayuda para archivos soportados
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"python",
					"javascript",
					"typescript",
					"php",
					"lua",
					"sh",
					"bash",
					"java",
					"c",
					"cpp",
					"go",
					"rust",
					"ruby",
				},
				callback = function()
					local filetype = vim.bo.filetype
					print("🎯 Archivo " .. filetype .. " detectado. Usa F9 para ejecutar o :DebugHelp")
				end,
			})

			-- ========== COMANDO DE AYUDA ==========
			vim.api.nvim_create_user_command("DebugHelp", function()
				local help_text = [[
🚀 DEBUG UNIVERSAL - COMANDOS DISPONIBLES:

⌨️ ATAJOS DE TECLADO:
  F9           - Ejecutar archivo completo
  F10          - Ejecutar con argumentos
  Shift+Enter  - Ejecutar archivo (alternativo)
  
  <leader>dr   - Ejecutar archivo
  <leader>da   - Ejecutar con argumentos
  <leader>ds   - Ejecutar selección (modo visual)
  <leader>dc   - Limpiar terminales de debug

🔧 COMANDOS VIM:
  :DebugRun    - Ejecutar archivo actual
  :DebugArgs   - Ejecutar con argumentos
  :DebugClean  - Limpiar terminales
  :DebugHelp   - Mostrar esta ayuda

📁 TIPOS DE ARCHIVO SOPORTADOS:
  .py          - Python (python3/python)
  .js          - JavaScript (node)
  .ts          - TypeScript (ts-node/tsc)
  .php         - PHP (php)
  .lua         - Lua (lua)
  .sh/.bash    - Shell/Bash (bash/sh)
  .java        - Java (javac + java)
  .c           - C (gcc)
  .cpp         - C++ (g++)
  .go          - Go (go run)
  .rs          - Rust (rustc/cargo)
  .rb          - Ruby (ruby)

💡 EJEMPLOS DE USO:
  1. Abre script.py
  2. Presiona F9
  3. ¡Se ejecuta automáticamente en terminal!
  
  Para argumentos:
  1. Presiona F10
  2. Escribe argumentos
  3. ¡Ejecuta con argumentos!
  
  Para selecciones (Python/JS/Lua):
  1. Selecciona código
  2. Presiona F9
  3. ¡Solo ejecuta la selección!

🎯 FLUJO DE TRABAJO:
  - Escribe código
  - F9 para probar rápido
  - F10 si necesitas argumentos
  - <leader>dc para limpiar terminales

⚠️ REQUISITOS:
  Los intérpretes/compiladores deben estar instalados:
  python3, node, php, lua, gcc, etc.
]]

				-- Mostrar en buffer temporal
				local buf = vim.api.nvim_create_buf(false, true)
				local lines = vim.split(help_text, "\n")
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
				vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
				vim.cmd("split")
				vim.api.nvim_win_set_buf(0, buf)
			end, { desc = "Mostrar ayuda de debug universal" })

			print("✅ Debug Universal configurado. Usa F9 para ejecutar o :DebugHelp")
		end,
	},
}
