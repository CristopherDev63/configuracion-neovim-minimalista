-- lua/plugins/python-runner.lua
-- Ejecutor simple de Python con visualización paso a paso

return {
	-- Iron.nvim para REPL interactivo
	{
		"Vigemus/iron.nvim",
		config = function()
			local iron = require("iron.core")

			iron.setup({
				config = {
					scratch_repl = true,
					repl_definition = {
						python = {
							command = { "python3" },
							format = require("iron.fts.common").bracketed_paste,
						},
					},
					repl_open_cmd = require("iron.view").split.vertical.botright(50),
				},
				keymaps = {
					send_motion = "<space>sc",
					visual_send = "<space>sc",
					send_file = "<space>sf",
					send_line = "<space>sl",
					send_until_cursor = "<space>su",
					send_mark = "<space>sm",
					mark_motion = "<space>mc",
					mark_visual = "<space>mc",
					remove_mark = "<space>md",
					cr = "<space>s<cr>",
					interrupt = "<space>s<space>",
					exit = "<space>sq",
					clear = "<space>cl",
				},
				highlight = {
					italic = true,
				},
				ignore_blank_lines = true,
			})

			-- Mapeos adicionales para Python
			vim.keymap.set("n", "<leader>rs", "<cmd>IronRepl<cr>", { desc = "Abrir REPL Python" })
			vim.keymap.set("n", "<leader>rr", "<cmd>IronRestart<cr>", { desc = "Reiniciar REPL" })
			vim.keymap.set("n", "<leader>rf", "<cmd>IronFocus<cr>", { desc = "Focus en REPL" })
			vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>", { desc = "Ocultar REPL" })
		end,
	},

	-- Jupytext para trabajar con notebooks
	{
		"GCBallesteros/jupytext.nvim",
		config = function()
			require("jupytext").setup({
				style = "markdown",
				output_extension = "md",
				force_ft = "markdown",
			})
		end,
	},

	-- Neotest para testing
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-python",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						runner = "pytest",
						python = "python3",
					}),
				},
				status = { virtual_text = true },
				output = { open_on_run = true },
			})

			-- Mapeos para testing
			vim.keymap.set("n", "<leader>tn", function()
				require("neotest").run.run()
			end, { desc = "Ejecutar test más cercano" })

			vim.keymap.set("n", "<leader>tf", function()
				require("neotest").run.run(vim.fn.expand("%"))
			end, { desc = "Ejecutar todos los tests del archivo" })

			vim.keymap.set("n", "<leader>td", function()
				require("neotest").run.run({ strategy = "dap" })
			end, { desc = "Depurar test más cercano" })

			vim.keymap.set("n", "<leader>ts", function()
				require("neotest").summary.toggle()
			end, { desc = "Toggle resumen de tests" })

			vim.keymap.set("n", "<leader>to", function()
				require("neotest").output.open({ enter = true })
			end, { desc = "Mostrar output del test" })
		end,
	},
}
