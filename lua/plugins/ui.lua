return {
	-- Tema VSCode Dark
	{
		"Mofiqul/vscode.nvim",
		priority = 1000,
		config = function()
			require("vscode").setup({
				transparent = true,
				italic_comments = true,
				disable_nvimtree_bg = true,
			})

			vim.cmd.colorscheme("vscode")

			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
			vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
			vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
			vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
			vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
			vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
			vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })

			vim.api.nvim_set_hl(0, "VertSplit", { fg = "#3e4452", bg = "none" })
			vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3e4452", bg = "none" })

			vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
			vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#264f78", fg = "#d4d4d4" })
			vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "none" })
			vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#3e4452" })
			vim.api.nvim_set_hl(0, "PmenuBorder", { bg = "none", fg = "#3e4452" })

			vim.api.nvim_set_hl(0, "LineNr", { fg = "#858585", bg = "none" })
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d4d4d4", bg = "none", bold = true })

			vim.api.nvim_set_hl(0, "Search", { fg = "#d4d4d4", bg = "#613214" })
			vim.api.nvim_set_hl(0, "IncSearch", { fg = "#d4d4d4", bg = "#613214" })

			vim.api.nvim_set_hl(0, "Cursor", { fg = "#1e1e1e", bg = "#aeafad" })
			vim.api.nvim_set_hl(0, "Visual", { bg = "#264f78" })

			vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#f44747" })
			vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#ff8800" })
			vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#75beff" })
			vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#4ec9b0" })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Función personalizada para mostrar el ícono de Apple en la barra de estado
			local function apple_icon()
				return " " -- Este es el código del ícono de Apple en Nerd Fonts
			end

			require("lualine").setup({
				options = {
					theme = "vscode",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { "NvimTree", "alpha" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { apple_icon, { "filename", path = 1 } },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				extensions = { "fugitive", "nvim-tree" },
			})

			vim.api.nvim_set_hl(0, "lualine_c_hostname", { fg = "#ffffff", bg = "#555555" })
		end,
	},
	{
		"echasnovski/mini.indentscope",
		version = false,
		config = function()
			require("mini.indentscope").setup({
				symbol = "▏",
				options = {
					try_as_border = true,
					indent_at_cursor = true,
				},
				draw = {
					delay = 100,
					animation = require("mini.indentscope").gen_animation.none(),
				},
			})

			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#404040", bg = "none" })
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#404040", bg = "none" })
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					sh = { "shfmt" },
					bash = { "shfmt" },
					php = { "php_cs_fixer" },
				},
				format_on_save = {
					format_on_save = nil,
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
}
