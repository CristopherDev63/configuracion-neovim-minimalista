-- Fuerza itálicas y negritas (para temas que no las definen)
vim.cmd([[
  hi! Italic gui=italic cterm=italic
  hi! Bold gui=bold cterm=bold
  syntax enable
]])

require("core")
