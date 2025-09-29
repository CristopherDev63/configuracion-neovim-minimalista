return {
	-- NOTA: Tema VSCode removido - ahora usamos Sonokai

	-- Barra de estado con tema adaptado a Sonokai
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			-- Función personalizada para mostrar el ícono de Apple en la barra de estado
			local function apple_icon()
				return " " -- Este es el código del ícono de Apple en Nerd Fonts
			end

			require("lualine").setup({
				options = {
					theme = "sonokai", -- Cambiado de "vscode" a "sonokai"
					component_separators = { left = "", right = "" },
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

			-- Asegurar que lualine también sea transparente
			vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "lualine_c_insert", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "lualine_c_visual", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "lualine_c_replace", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "lualine_c_command", { bg = "NONE" })
		end,
	},

	-- Guías de indentación
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

			-- Colores adaptados a Sonokai con transparencia
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#7f8490", bg = "NONE" })
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#7f8490", bg = "NONE" })
		end,
	},

	-- Auto-pares de caracteres
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- Formateador de código
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					python = { "autopep8" },
					sh = { "shfmt" },
					bash = { "shfmt" },
					php = { "php_cs_fixer" },
				},
				format_on_save = nil,
			})
		end,
	},
}
