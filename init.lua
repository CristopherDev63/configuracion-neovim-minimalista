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

-- Cargar opciones básicas primero
require("core.options")
require("core.keymaps")

require("lazy").setup({
	-- Plugins esenciales primero
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",

	-- NUEVO: Tema Sonokai
	{ import = "plugins.sonokai-theme" },

	-- Luego los grupos de plugins
	{ import = "plugins.ui" },
	{ import = "plugins.treesitter" },
	{ import = "plugins.telescope" },
	{ import = "plugins.cmp" },
	{ import = "plugins.lsp" },
	{ import = "plugins.debug" },
	{ import = "plugins.live-server" },
})

-- Cargar autocomandos después de los plugins
require("core.autocommands")

print("✅ Configuración cargada correctamente - Debug habilitado con Ctrl+C")
