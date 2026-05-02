if vim.loader then
    vim.loader.enable()
end

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
require("core.performance") -- Optimización de archivos grandes
require("core.keymaps")
require("core.graphing") -- Cargar la funcionalidad de grafos ASCII
require("core.help") -- Cargar ventana de ayuda personalizada

require("lazy").setup({
	-- Plugins esenciales primero
	"neovim/nvim-lspconfig",

	{ import = "plugins.markdown-preview" },
	-- { import = "plugins.alpha" }, -- Pantalla de bienvenida
	{ import = "plugins.ui" },
	{ import = "plugins.oil" }, -- Gestión de archivos pro (reemplaza NERDTree)
	{ import = "plugins.csv-view" }, -- Visualización de CSV/Excel
	{ import = "plugins.spectre" }, -- Buscar y reemplazar masivo
	{ import = "plugins.treesitter" },
	{ import = "plugins.telescope" },
	{ import = "plugins.blink" }, -- Autocompletado rápido (tipo VS Code)
	{ import = "plugins.supermaven" }, -- IA con ghost text tipo Cursor/Copilot
	{ import = "plugins.lsp" },
	{ import = "plugins.keymaps-cheatsheet" },
	{ import = "plugins.which-key" },
	{ import = "plugins.fugitive" },
	{ import = "plugins.gitsigns" },
	{ import = "plugins.nerdtree" }, -- Agregado el plugin de NERDTree

	-- NUEVOS: Funcionalidades avanzadas como VS Code
	{ import = "plugins.visual-modes" }, -- Zen mode, minimap, breadcrumbs, sticky scroll
	{ import = "plugins.multicursor" }, -- Multi-cursor moderno
	{ import = "plugins.advanced-writing" }, -- Multi-cursor, quick fix, code actions
	{ import = "plugins.advanced-editing" }, -- Folding, indentation guides, bracket matching
	{ import = "plugins.mason-minimal" }, -- Mason para instalar jdtls
	{ import = "plugins.rst-sphinx" }, -- Soporte para reStructuredText y Sphinx
	{ import = "plugins.error-lens" }, -- Diagnósticos estilo VS Code Error Lens
	{ import = "plugins.toggleterm" }, -- Terminal integrada y ejecutor de código
	{ import = "plugins.transparent" }, -- Fondo transparente
	{ import = "plugins.bufferline" }, -- Pestañas minimalistas (buffers)
	{ import = "plugins.icons" }, -- Iconos de archivo (nvim-web-devicons)
	{ import = "plugins.theme" }, -- Tema de colores (OceanicNext)
	{ import = "plugins.opencode" }, -- Integración con OpenCode AI
})

-- Cargar autocomandos después de los plugins
require("core.autocommands")

-- Configuración para markdown-preview.nvim
vim.g.mkdp_preview_options = {
	mmark = {},
	restapi = {},
	tcp_port = {},
	mermaid = {}, -- Esto habilita Mermaid
	katex = {},
	uml = {},
	gh_carets = {},
	sequence_diagrams = {},
	flowchart_diagrams = {},
	content_editable = false,
	disable_filename = 0,
}

-- Opcional: Para que se abra automáticamente al entrar a un .md
-- vim.g.mkdp_auto_start = 1
