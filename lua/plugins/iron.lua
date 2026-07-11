return {
	{
		"Vigemus/iron.nvim",
		keys = {
			{ "<leader>rr", "<cmd>IronRepl<CR>", desc = "🐍 Abrir REPL Python" },
			{ "<leader>rf", "<cmd>IronFocus<CR>", desc = "🐍 Focus REPL" },
			{ "<leader>rh", "<cmd>IronHide<CR>", desc = "🐍 Ocultar REPL" },
		},
		config = function()
			local iron = require("iron.core")
			local view = require("iron.view")

			iron.setup({
				config = {
					scratch_repl = true,
					repl_definition = {
						python = {
							command = { "python3" },
							format = require("iron.fts.common").bracketed_paste_python,
							block_dividers = { "# %%", "#%%" },
							env = { PYTHON_BASIC_REPL = "1" },
						},
					},
					repl_filetype = function(bufnr, ft)
						return ft
					end,
					repl_open_cmd = view.bottom(15),
				},
				keymaps = {
					toggle_repl = "<space>rs",
					restart_repl = "<space>rR",
					send_motion = "<space>sc",
					visual_send = "<space>sc",
					send_file = "<space>sf",
					send_line = "<space>sl",
					send_paragraph = "<space>sp",
					send_until_cursor = "<space>su",
					send_mark = "<space>sm",
					send_code_block = "<space>sb",
					send_code_block_and_move = "<space>sn",
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
		end,
	},
}
