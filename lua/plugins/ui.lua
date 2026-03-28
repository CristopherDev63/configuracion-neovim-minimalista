return {
	-- Tema One Dark configurado en init.lua

	-- Barra de estado con tema adaptado a One Dark
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "iceberg_light",
					disabled_filetypes = { "NvimTree", "alpha" },
				},
			})
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

			-- Colores adaptados a One Dark con transparencia
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#5c6370", bg = "NONE" }) -- Gray One Dark
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#5c6370", bg = "NONE" })
		end,
	},
}
