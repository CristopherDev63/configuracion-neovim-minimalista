-- Autocompletado con IA: Codeium - Integrado completamente
return {
	"Exafunction/codeium.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	build = ":Codeium Auth",
	config = function()
		require("codeium").setup({
			ghost_text = {
				enabled = false,
			},
		})
	end,
}
