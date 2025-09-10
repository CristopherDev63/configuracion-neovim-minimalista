local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Plugins individuales críticos primero
	"hrsh7th/cmp-nvim-lsp",
	"neovim/nvim-lspconfig",

	-- Luego los grupos de plugins
	{ import = "plugins.ui" },
	{ import = "plugins.treesitter" },
	{ import = "plugins.telescope" },
	{ import = "plugins.cmp" },
    { import = "plugins.java" }

	-- Configuración LSP como plugin separado
	{
		config = function()
			require("plugins.lsp")
		end,
	},
})

print("✅ Plugins cargados")
