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
opt.numberwidth = 1
opt.cursorline = true
opt.signcolumn = "yes:1"
opt.showtabline = 1 -- Solo mostrar pestañas si hay >1 buffer
opt.list = false

-- Indentación y tabs
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Búsqueda y comportamiento
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- Rendimiento General (modo rápidez tipo VS Code)
opt.updatetime = 200 -- Diagnósticos más rápidos
opt.timeoutlen = 300
opt.redrawtime = 300 -- Timeout de redibujado más rápido
opt.lazyredraw = true -- Sin redibujado durante macros

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
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Desactivar cursorline y relativenumber en insert mode (menos redibujado al escribir)
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.opt_local.cursorline = false
    vim.opt_local.relativenumber = false
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.opt_local.cursorline = true
    vim.opt_local.relativenumber = true
  end,
})
