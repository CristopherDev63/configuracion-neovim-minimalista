-- lua/plugins/debug.lua
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

			-- Configuración para Python
			dap.adapters.python = function(cb, config)
				if config.request == "attach" then
					---@diagnostic disable-next-line: undefined-field
					local port = (config.connect or config).port
					---@diagnostic disable-next-line: undefined-field
					local host = (config.connect or config).host or "127.0.0.1"
					cb({
						type = "server",
						port = assert(port, "`connect.port` is required for a python `attach` configuration"),
						host = host,
						options = {
							source_filetype = "python",
						},
					})
				else
					cb({
						type = "executable",
						command = "python3",
						args = { "-m", "debugpy.adapter" },
						options = {
							source_filetype = "python",
						},
					})
				end
			end

			dap.configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Ejecutar archivo actual",
					program = "${file}",
					pythonPath = function()
						return "/usr/bin/python3"
					end,
				},
				{
					type = "python",
					request = "launch",
					name = "Ejecutar con argumentos",
					program = "${file}",
					args = function()
						local args_string = vim.fn.input("Argumentos: ")
						return vim.split(args_string, " ", true)
					end,
					pythonPath = function()
						return "/usr/bin/python3"
					end,
				},
			}

			-- Configuración para Node.js/JavaScript
			dap.adapters.node2 = {
				type = "executable",
				command = "node",
				args = {
					os.getenv("HOME") .. "/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
				},
			}

			dap.configurations.javascript = {
				{
					name = "Ejecutar archivo actual",
					type = "node2",
					request = "launch",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					protocol = "inspector",
					console = "integratedTerminal",
				},
			}

			-- Configuración para TypeScript
			dap.configurations.typescript = {
				{
					name = "Ejecutar archivo TS actual",
					type = "node2",
					request = "launch",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					protocol = "inspector",
					console = "integratedTerminal",
					runtimeExecutable = "ts-node",
				},
			}

			-- Configuración para PHP
			dap.adapters.php = {
				type = "executable",
				command = "node",
				args = {
					os.getenv("HOME")
						.. "/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
				},
			}

			dap.configurations.php = {
				{
					type = "php",
					request = "launch",
					name = "Ejecutar archivo PHP actual",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					port = 9000,
					stopOnEntry = false,
				},
				{
					type = "php",
					request = "launch",
					name = "Escuchar Xdebug",
					port = 9000,
				},
			}

			-- Configuración para Bash
			dap.adapters.bashdb = {
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
				name = "bashdb",
			}

			dap.configurations.sh = {
				{
					type = "bashdb",
					request = "launch",
					name = "Ejecutar script bash actual",
					showDebugOutput = true,
					pathBashdb = vim.fn.stdpath("data")
						.. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
					pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
					trace = true,
					file = "${file}",
					program = "${file}",
					cwd = "${workspaceFolder}",
					pathCat = "cat",
					pathBash = "/bin/bash",
					pathMkfifo = "mkfifo",
					pathPkill = "pkill",
					args = {},
					env = {},
					terminalKind = "integrated",
				},
			}

			-- Configurar breakpoints
			vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "DiagnosticError", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapStopped",
				{ text = "➡️", texthl = "DiagnosticWarn", linehl = "CursorLine", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "❓", texthl = "DiagnosticInfo", linehl = "", numhl = "" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "❌", texthl = "DiagnosticError", linehl = "", numhl = "" }
			)

			-- Configurar DAP UI
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
				expand_lines = vim.fn.has("nvim-0.7"),
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
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				windows = { indent = 1 },
				render = {
					max_type_length = nil,
					max_value_lines = 100,
				},
			})

			-- Auto abrir/cerrar DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Función para debugging inteligente basado en el tipo de archivo
			local function smart_debug()
				local filetype = vim.bo.filetype
				local filename = vim.fn.expand("%")

				-- Guardar el archivo primero
				vim.cmd("write")

				-- Iniciar debugging según el tipo de archivo
				if filetype == "python" or string.match(filename, "%.py$") then
					dap.continue()
				elseif filetype == "javascript" or string.match(filename, "%.js$") then
					dap.continue()
				elseif filetype == "typescript" or string.match(filename, "%.ts$") then
					dap.continue()
				elseif filetype == "php" or string.match(filename, "%.php$") then
					dap.continue()
				elseif filetype == "sh" or filetype == "bash" or string.match(filename, "%.sh$") then
					dap.continue()
				else
					print("⚠️ Debugging no configurado para el tipo de archivo: " .. filetype)
					print("💡 Tipos soportados: python, javascript, typescript, php, bash/sh")
				end
			end

			-- Mapeos de teclado para debugging
			local keymap = vim.keymap

			-- Ctrl+C para iniciar debugging (reemplaza la función anterior)
			keymap.set("n", "<C-c>", smart_debug, { desc = "🐛 Iniciar debugging inteligente" })

			-- Controles de debugging
			keymap.set("n", "<F5>", dap.continue, { desc = "▶️ Continuar/Iniciar debug" })
			keymap.set("n", "<F10>", dap.step_over, { desc = "⏭ Step Over" })
			keymap.set("n", "<F11>", dap.step_into, { desc = "⏬ Step Into" })
			keymap.set("n", "<F12>", dap.step_out, { desc = "⏮ Step Out" })

			-- Breakpoints
			keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "🛑 Toggle Breakpoint" })
			keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Condición del breakpoint: "))
			end, { desc = "❓ Breakpoint Condicional" })

			-- DAP UI
			keymap.set("n", "<leader>du", dapui.toggle, { desc = "🖥️ Toggle Debug UI" })
			keymap.set("n", "<leader>dr", dap.repl.open, { desc = "📝 Abrir REPL Debug" })
			keymap.set("n", "<leader>dl", dap.run_last, { desc = "🔄 Ejecutar última configuración" })

			-- Terminar debugging
			keymap.set("n", "<leader>dt", dap.terminate, { desc = "⏹ Terminar Debug" })

			-- Variables y watches
			keymap.set("n", "<leader>dv", function()
				dapui.eval(vim.fn.input("Evaluar: "))
			end, { desc = "🔍 Evaluar expresión" })

			keymap.set("v", "<leader>dv", function()
				dapui.eval()
			end, { desc = "🔍 Evaluar selección" })

			print("🐛 Debug configurado - Usa Ctrl+C para debugging inteligente")
		end,
	},

	-- UI para debugging
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},

	-- Texto virtual para debugging
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

	-- Plugin para Python debugging (debugpy)
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			local dap_python = require("dap-python")
			dap_python.setup("python3")

			-- Configuraciones adicionales para Python
			dap_python.test_runner = "pytest"

			-- Método de debugging para Python específico
			vim.keymap.set("n", "<leader>dn", dap_python.test_method, { desc = "🧪 Debug método Python" })
			vim.keymap.set("n", "<leader>dc", dap_python.test_class, { desc = "🏫 Debug clase Python" })
		end,
	},

	-- Mason para instalar debuggers automáticamente
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = {
					"python", -- debugpy
					"node2", -- node-debug2-adapter
					"php", -- php-debug-adapter
					"bash", -- bash-debug-adapter
				},
				automatic_installation = true,
				handlers = {},
			})
		end,
	},
}
