return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { desc = "Buscar archivos" })
		end,
	},
}
