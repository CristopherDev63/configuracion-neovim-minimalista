-- core/autocmds.lua — Comandos automáticos Nothing Edition

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local grp_yank = augroup("HighlightYank", { clear = true })
local grp_resize = augroup("ResizeSplits", { clear = true })
local grp_ft = augroup("FileTypeSettings", { clear = true })
local grp_term = augroup("TerminalSettings", { clear = true })
local grp_spelling = augroup("Spelling", { clear = true })

-- Resaltar texto copiado
autocmd("TextYankPost", {
  group = grp_yank,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Reajustar splits al redimensionar
autocmd("VimResized", {
  group = grp_resize,
  pattern = "*",
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- Indentación por filetype
autocmd("FileType", {
  group = grp_ft,
  pattern = { "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

autocmd("FileType", {
  group = grp_ft,
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "html", "css", "json", "yaml", "markdown", "lua" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- Terminal: sin números, sin wrap
autocmd("TermOpen", {
  group = grp_term,
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Redimensionar ventanas flotantes al cambiar tamaño de terminal
autocmd("VimResized", {
  group = grp_resize,
  pattern = "*",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Guardar posición del cursor
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
