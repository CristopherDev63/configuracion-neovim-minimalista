local opt = vim.opt
local g = vim.g

-- Opciones de visualización
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"

-- Indentación y tabs
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Búsqueda y comportamiento
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Rendimiento
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- Tema y colores
opt.termguicolors = true

-- Configuración de scroll
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitkeep = "screen"

-- Configuración de texto
opt.wrap = false
opt.linebreak = false
opt.textwidth = 0
opt.wrapmargin = 0

-- Variables globales
g.mapleader = ' '
g.maplocalleader = ' '
