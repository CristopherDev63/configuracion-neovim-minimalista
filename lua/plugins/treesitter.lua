return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"python",
					"lua",
					"javascript",
					"typescript",
					"bash",
					"php",
					"sql",
					"html",
					"css",
					"java",
					"gdscript",
				},
				-- Configuración específica para SQL
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
			})
		end,
	},
}
