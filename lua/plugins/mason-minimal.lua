-- lua/plugins/mason-minimal.lua
-- Configuración MÍNIMA de Mason solo para instalar jdtls

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "jdtls", "esbonio" },
			})
		end,
	},
}
