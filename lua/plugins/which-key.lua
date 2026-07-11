return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		plugins = {
			marks = true,
			registers = true,
			spelling = {
				enabled = true,
				suggestions = 20,
			},
			presets = {
				operators = false,
				motions = true,
				text_objects = true,
				windows = true,
				nav = true,
				z = true,
				g = true,
			},
		},
		replace = {
			key = {
				{ "<Space>", "SPC" },
				{ "<CR>", "RET" },
				{ "<Tab>", "TAB" },
			},
		},
		icons = {
			breadcrumb = "»",
			separator = "➜",
			group = "+",
		},
		keys = {
			scroll_down = "<c-d>",
			scroll_up = "<c-u>",
		},
		win = {
			border = "rounded",
			position = "bottom",
			margin = { 1, 0, 1, 0 },
			padding = { 2, 2, 2, 2 },
			winblend = 0,
		},
		layout = {
			height = { min = 4, max = 25 },
			width = { min = 20, max = 50 },
			spacing = 3,
			align = "left",
		},
		show_help = true,
		triggers = {
			{ "<auto>", mode = { "n", "o" } },
		},
	},
}
