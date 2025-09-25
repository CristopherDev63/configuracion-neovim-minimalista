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

-- decir hola mundo
print("hola mundo")

-- Cargar opciones básicas primero
require("core.options")
require("core.keymaps")

require("lazy").setup({
	-- Plugins esenciales primero
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",

	-- NUEVO: Tema Sonokai
	{ import = "plugins.sonokai-theme" },
	{ import = "plugins.gemini-autocomplete" },
	{ import = "plugins.smart-identation" },
	{ import = "plugins.markdown-preview" },
	{ import = "plugins.ui" },
	{ import = "plugins.treesitter" },
	{ import = "plugins.telescope" },
	{ import = "plugins.cmp" },
	{ import = "plugins.lsp" },
	{ import = "plugins.debug" },
	{ import = "plugins.live-server" },
	{ import = "plugins.simple-universal-debug" },
	{ import = "plugins.rope-refactoring" },
	{ import = "plugins.keymaps-cheatsheet" },
})

-- Cargar autocomandos después de los plugins
require("core.autocommands")
