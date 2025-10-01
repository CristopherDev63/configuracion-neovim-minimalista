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
require("core.java-autocmd")  -- Cargar autocomando de Java

require("lazy").setup({
	-- Plugins esenciales primero
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",

	-- NUEVO: Tema Sonokai
	{ import = "plugins.sonokai-theme" },
	{ import = "plugins.codeium" },
	{ import = "plugins.smart-identation" },
	{ import = "plugins.markdown-preview" },
	{ import = "plugins.ui" },
	{ import = "plugins.treesitter" },
	{ import = "plugins.telescope" },
	{ import = "plugins.cmp" },
	{ import = "plugins.lsp" },
	{ import = "plugins.debug" },
	{ import = "plugins.live-server" },
	-- { import = "plugins.simple-universal-debug" },  -- Deshabilitado temporalmente
	{ import = "plugins.rope-refactoring" },
	{ import = "plugins.keymaps-cheatsheet" },

	-- NUEVOS: Funcionalidades avanzadas como VS Code
	{ import = "plugins.visual-modes" },        -- Zen mode, minimap, breadcrumbs, sticky scroll
	{ import = "plugins.advanced-writing" },    -- Multi-cursor, quick fix, code actions
	{ import = "plugins.advanced-editing" },    -- Folding, indentation guides, bracket matching
	{ import = "plugins.sql" },                 -- SQL development tools
	{ import = "plugins.mason-minimal" },       -- Mason para instalar jdtls
	{ import = "plugins.java-run" },            -- Ejecutar Java con F9
})

-- Cargar autocomandos después de los plugins
require("core.autocommands")
