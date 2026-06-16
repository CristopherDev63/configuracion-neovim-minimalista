-- Modalidades Visuales: Zen Mode, Minimap, Breadcrumbs, Sticky Scroll
return {
	-- ZEN MODE - Vista sin distracciones
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen Mode" },
		},
		opts = {
			window = {
				backdrop = 0.95,
				width = 120,
				height = 1,
				options = {
					signcolumn = "no",
					number = false,
					relativenumber = false,
					cursorline = false,
					cursorcolumn = false,
					foldcolumn = "0",
					list = false,
				},
			},
			plugins = {
				options = {
					enabled = true,
					ruler = false,
					showcmd = false,
					laststatus = 0,
				},
				twilight = { enabled = true },
				gitsigns = { enabled = false },
				tmux = { enabled = false },
			},
		},
	},

	-- TWILIGHT - Dimming para Zen Mode
	{
		"folke/twilight.nvim",
		opts = {
			dimming = {
				alpha = 0.25,
				color = { "Normal", "#ffffff" },
				term_bg = "#000000",
				inactive = false,
			},
			context = 10,
			treesitter = true,
			expand = {
				"function",
				"method",
				"table",
				"if_statement",
			},
		},
	},

	-- BREADCRUMBS - Navegación jerárquica
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
        enabled = false, -- Desactivado por usuario
		opts = {
			attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
			create_autocmd = false, -- prevent barbecue from updating itself automatically
			show_dirname = false,
			show_basename = false,
			exclude_filetypes = { "netrw", "toggle" },
			symbols = {
				modified = "●",
				ellipsis = "…",
				separator = "",
			},
			kinds = {
				File = "",
				Module = "",
				Namespace = "",
				Package = "",
				Class = "",
				Method = "",
				Property = "",
				Field = "",
				Constructor = "",
				Enum = "",
				Interface = "",
				Function = "",
				Variable = "",
				Constant = "",
				String = "",
				Number = "",
				Boolean = "◩",
				Array = "",
				Object = "",
				Key = "",
				Null = "ﳠ",
				EnumMember = "",
				Struct = "",
				Event = "",
				Operator = "",
				TypeParameter = "",
			},
		},
		config = function(_, opts)
			require("barbecue").setup(opts)

			-- Auto-update breadcrumbs
			vim.api.nvim_create_autocmd({
				"WinResized",
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",
				"BufWritePost",
				"TextChanged",
				"TextChangedI",
			}, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,
	},

	-- NVIM-NAVIC - LSP symbols para breadcrumbs
	{
		"SmiteshP/nvim-navic",
		lazy = true,
        enabled = false, -- Desactivado por usuario
		init = function()
			vim.g.navic_silence = true
		end,
		opts = {
			separator = " ",
			highlight = true,
			depth_limit = 5,
			icons = {
				File = " ",
				Module = " ",
				Namespace = " ",
				Package = " ",
				Class = " ",
				Method = " ",
				Property = " ",
				Field = " ",
				Constructor = " ",
				Enum = " ",
				Interface = " ",
				Function = " ",
				Variable = " ",
				Constant = " ",
				String = " ",
				Number = " ",
				Boolean = " ",
				Array = " ",
				Object = " ",
				Key = " ",
				Null = " ",
				EnumMember = " ",
				Struct = " ",
				Event = " ",
				Operator = " ",
				TypeParameter = " ",
			},
		},
	},

	-- STICKY SCROLL - Headers fijos arriba
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = "nvim-treesitter/nvim-treesitter",
        enabled = false, -- Desactivado por usuario
		opts = {
			enable = true,
			max_lines = 3,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
			on_attach = nil,
		},
		keys = {
			{ "<leader>tc", "<cmd>TSContextToggle<cr>", desc = "Toggle Treesitter Context" },
		},
	},

}