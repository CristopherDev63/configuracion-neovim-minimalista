return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope", -- (Optimización Radical) Cargar solo al usar el comando
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--max-columns=150", -- No procesar líneas muy largas
					},
				}
			})
			vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { desc = "Buscar archivos" })
		end,
	},
}
