if vim.loader then vim.loader.enable() end

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
-- print("hola mundo")

-- Cargar opciones básicas primero
require("core.options")
require("core.performance")   -- Optimización de archivos grandes
require("core.keymaps")
require("core.graphing")      -- Cargar la funcionalidad de grafos ASCII
require("core.help")          -- Cargar ventana de ayuda personalizada

require("lazy").setup({
	-- CONFIGURACIÓN DE RENDIMIENTO LAZY (Optimización 3)
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			disabled_plugins = {
				"gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin",
				"tohtml", "tutor", "zipPlugin",
			},
		},
	},
	-- Plugins esenciales primero
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",

	-- Tema VSCode
	{
		"ayu-theme/ayu-vim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme ayu")
		end,
	},




	{ import = "plugins.markdown-preview" },
	{ import = "plugins.alpha" },               -- Pantalla de bienvenida
	{ import = "plugins.ui" },
	{ import = "plugins.oil" },                 -- Gestión de archivos pro (reemplaza NERDTree)
	{ import = "plugins.csv-view" },            -- Visualización de CSV/Excel
	{ import = "plugins.spectre" },             -- Buscar y reemplazar masivo
	{ import = "plugins.treesitter" },
	{ import = "plugins.telescope" },
	{ import = "plugins.blink" },               -- Autocompletado rápido (tipo VS Code)
	{ import = "plugins.lsp" },
	{ import = "plugins.debug" },
	{ import = "plugins.keymaps-cheatsheet" },
	{ import = "plugins.which-key" },
	{ import = "plugins.fugitive" },
	{ import = "plugins.gitsigns" },

	-- NUEVOS: Funcionalidades avanzadas como VS Code
	{ import = "plugins.visual-modes" },        -- Zen mode, minimap, breadcrumbs, sticky scroll
	{ import = "plugins.advanced-writing" },    -- Multi-cursor, quick fix, code actions
	{ import = "plugins.advanced-editing" },    -- Folding, indentation guides, bracket matching
	{ import = "plugins.formatting" },          -- Formateador de código (conform)
	{ import = "plugins.mason-minimal" },       -- Mason para instalar jdtls
	{ import = "plugins.rst-sphinx" },          -- Soporte para reStructuredText y Sphinx
})

-- Cargar autocomandos después de los plugins
require("core.autocommands")
