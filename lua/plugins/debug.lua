-- lua/plugins/debug.lua - VERSIÓN CORREGIDA
return {
	-- Plugin principal de debugging
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- ========== CONFIGURACIÓN PYTHON ==========
			dap.adapters.python = {
				type = "executable",
				command = "python3",
				args = { "-m", "debugpy.adapter" },
			}

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "🐍 Ejecutar archivo actual",
					program = "${file}",
					console = "integratedTerminal",
					pythonPath = function()
						return "/usr/bin/python3"
					end,
					-- IMPORTANTE: Pausa automática en la primera línea
					stopOnEntry = false,
					justMyCode = true,
				},
				{
					type = "python",
					request = "launch",
					name = "🐍 Debug con argumentos",
					program = "${file}",
					console = "integratedTerminal",
					args = function()
						local args_string = vim.fn.input("Argumentos: ")
						return vim.split(args_string, " ", true)
					end,
					pythonPath = function()
						return "/usr/bin/python3"
					end,
					stopOnEntry = false,
					justMyCode = true,
				},
			}

			-- ========== CONFIGURACIÓN BASH ==========
			dap.adapters.bashdb = {
				type = "executable",
				command = "bash",
				args = { "-c", "bashdb --listen 0.0.0.0:9002 --tty /dev/null" },
			}

			dap.configurations.sh = {
				{
					type = "bashdb",
					request = "launch",
					name = "🔧 Debug script bash",
					program = "${file}",
					cwd = "${workspaceFolder}",
					pathBash = "/bin/bash",
					args = {},
					env = {},
					-- Pausa en la primera línea
					stopOnEntry = true,
				},
			}

			-- ========== CONFIGURACIÓN JAVASCRIPT ==========
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}

			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "🟨 Ejecutar archivo JS",
					program = "${file}",
					cwd = "${workspaceFolder}",
					console = "integratedTerminal",
					skipFiles = { "<node_internals>/**" },
				},
			}

			-- ========== CONFIGURACIÓN PHP ==========
			dap.adapters.php = {
				type = "executable",
				command = "node",
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
				},
			}

			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "🐘 Ejecutar PHP actual",
					program = "${file}",
					cwd = "${workspaceFolder}",
					port = 9000,
					stopOnEntry = false,
				},
			}

			-- ========== CONFIGURAR BREAKPOINTS ==========
			vim.fn.sign_define("DapBreakpoint", {
				text = "🔴",
				texthl = "DiagnosticError",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapStopped", {
				text = "▶️",
				texthl = "DiagnosticWarn",
				linehl = "CursorLine",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "❓",
				texthl = "DiagnosticInfo",
				linehl = "",
				numhl = "",
			})

			-- ========== CONFIGURAR DAP UI ==========
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							"breakpoints",
							"stacks",
							"watches",
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							"repl",
							"console",
						},
						size = 0.25,
						position = "bottom",
					},
				},
				controls = {
					enabled = true,
					element = "repl",
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏬",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "↶",
						run_last = "▶▶",
						terminate = "⏹",
					},
				},
				floating = {
					max_height = nil,
					max_width = nil,
					border = "single",
					mappings = { close = { "q", "<Esc>" } },
				},
			})

			-- ========== AUTO ABRIR/CERRAR DAP UI ==========
			-- NO cerrar automáticamente para evitar que desaparezca
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
				print("🐛 Debug UI abierto - Usa F10 para step over")
			end

			-- NO cerrar automáticamente al terminar
			-- dap.listeners.before.event_terminated["dapui_config"] = function()
			-- 	dapui.close()
			-- end

			-- ========== FUNCIÓN DEBUG INTELIGENTE ==========
			local function smart_debug()
				local filetype = vim.bo.filetype
				local filename = vim.fn.expand("%")

				-- Verificar si debugpy está instalado para Python
				if filetype == "python" then
					local handle = io.popen("python3 -c 'import debugpy; print(\"OK\")' 2>/dev/null")
					if handle then
						local result = handle:read("*a")
						handle:close()
						if not result:match("OK") then
							print("❌ debugpy no está instalado. Ejecuta: pip3 install debugpy")
							return
						end
					end
				end

				-- Guardar archivo primero
				vim.cmd("write")

				-- Asegurarse de que DAP UI esté abierto
				dapui.open()

				-- Verificar si hay breakpoints usando signs
				local bufnr = vim.api.nvim_get_current_buf()
				local signs = vim.fn.sign_getplaced(bufnr, { group = "dap_breakpoints" })
				local has_breakpoints = false

				if signs and signs[1] and signs[1].signs then
					has_breakpoints = #signs[1].signs > 0
				end

				-- Si no hay breakpoints, informar al usuario
				if not has_breakpoints then
					print("💡 Tip: Pon un breakpoint con <leader>b antes de debuggear")
					print("🔴 Poniendo breakpoint automático en línea 1...")
					-- Poner breakpoint en línea 1 automáticamente
					vim.api.nvim_win_set_cursor(0, { 1, 0 })
					dap.toggle_breakpoint()
				end

				-- Iniciar debugging según el tipo de archivo
				if filetype == "python" or string.match(filename, "%.py$") then
					print("🐍 Iniciando debug Python...")
					dap.continue()
				elseif filetype == "javascript" or string.match(filename, "%.js$") then
					print("🟨 Iniciando debug JavaScript...")
					dap.continue()
				elseif filetype == "php" or string.match(filename, "%.php$") then
					print("🐘 Iniciando debug PHP...")
					dap.continue()
				elseif filetype == "sh" or filetype == "bash" or string.match(filename, "%.sh$") then
					print("🔧 Iniciando debug Bash...")
					dap.continue()
				else
					print("⚠️ Debugging no configurado para: " .. filetype)
					print("💡 Tipos soportados: python, javascript, php, bash/sh")
				end
			end

			-- ========== MAPEOS DE TECLADO ==========
			local keymap = vim.keymap

			-- Ctrl+C para iniciar debugging
			keymap.set("n", "<C-c>", smart_debug, { desc = "🐛 Iniciar debugging inteligente" })

			-- Controles básicos de debugging
			keymap.set("n", "<F5>", dap.continue, { desc = "▶️ Continuar" })
			keymap.set("n", "<F10>", dap.step_over, { desc = "⏭ Step Over" })
			keymap.set("n", "<F11>", dap.step_into, { desc = "⏬ Step Into" })
			keymap.set("n", "<F12>", dap.step_out, { desc = "⏮ Step Out" })

			-- Breakpoints
			keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "🔴 Toggle Breakpoint" })
			keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Condición: "))
			end, { desc = "❓ Breakpoint Condicional" })

			-- UI Controls
			keymap.set("n", "<leader>du", dapui.toggle, { desc = "🖥️ Toggle Debug UI" })
			keymap.set("n", "<leader>dr", dap.repl.open, { desc = "📝 Abrir REPL" })
			keymap.set("n", "<leader>dt", function()
				dap.terminate()
				dapui.close()
				print("⏹ Debug terminado")
			end, { desc = "⏹ Terminar Debug" })

			-- Evaluación de variables
			keymap.set("n", "<leader>dv", function()
				dapui.eval(vim.fn.input("Evaluar: "))
			end, { desc = "🔍 Evaluar expresión" })

			keymap.set("v", "<leader>dv", function()
				dapui.eval()
			end, { desc = "🔍 Evaluar selección" })

			print("🐛 Debug configurado - Usa Ctrl+C para iniciar debugging")
		end,
	},

	-- ========== PLUGINS ADICIONALES ==========
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				filter_references_pattern = "<module",
				virt_text_pos = "eol",
				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
			})
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local dap_python = require("dap-python")
			dap_python.setup("python3")
			dap_python.test_runner = "pytest"

			vim.keymap.set("n", "<leader>dn", dap_python.test_method, { desc = "🧪 Debug método Python" })
			vim.keymap.set("n", "<leader>dc", dap_python.test_class, { desc = "🏫 Debug clase Python" })
		end,
	},
}
