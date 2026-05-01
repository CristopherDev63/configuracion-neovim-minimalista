local opt = vim.opt
local g = vim.g

-- 1. CENTRALIZAR ARCHIVOS BASURA (Optimización 2)
-- Evita llenar tus carpetas de proyecto con .swp o archivos ~
local swap_dir = vim.fn.stdpath("data") .. "/swap"
local undo_dir = vim.fn.stdpath("data") .. "/undo"
local backup_dir = vim.fn.stdpath("data") .. "/backup"

-- Crear directorios si no existen
if vim.fn.isdirectory(swap_dir) == 0 then vim.fn.mkdir(swap_dir, "p") end
if vim.fn.isdirectory(undo_dir) == 0 then vim.fn.mkdir(undo_dir, "p") end
if vim.fn.isdirectory(backup_dir) == 0 then vim.fn.mkdir(backup_dir, "p") end

opt.swapfile = true
opt.directory = swap_dir
opt.undofile = true
opt.undodir = undo_dir
opt.backup = true
opt.backupdir = backup_dir
opt.writebackup = true

-- Opciones de visualización
opt.number = true
opt.relativenumber = true
opt.numberwidth = 2
opt.cursorline = true
opt.signcolumn = "yes:1"
opt.showtabline = 2

-- Indentación y tabs
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Búsqueda y comportamiento
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Rendimiento General
opt.updatetime = 1000 -- Acelera diagnósticos y eventos
opt.timeoutlen = 500
opt.redrawtime = 1500 -- (Optimización Radical) Reduce el estrés en la GPU/CPU al redibujar

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

-- (Optimización Extrema - Paso 1) Desactivar providers heredados
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

-- Configuración para autoread
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
