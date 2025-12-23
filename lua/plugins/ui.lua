return {
	-- NOTA: Tema Sonokai removido - ahora usamos Molokai

	-- Barra de estado con tema adaptado a Molokai
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "ayu",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { "NvimTree", "alpha" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				extensions = { "fugitive", "nvim-tree" },
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

			-- Colores adaptados a Molokai con transparencia
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#75715E", bg = "NONE" }) -- Gris Molokai
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#75715E", bg = "NONE" }) -- Gris Molokai
		end,
	},
}
