-- core/colors.lua — Paleta Nothing Edition sobre base onedark deep
-- Estética monocromática oscura + acentos rojo/naranja Nothing

local M = {}

-- Base onedark deep (se obtiene del tema)
M.bg = "#1B1B1D"
M.fg = "#D4D4D8"
M.red = "#D71921"
M.orange = "#FF6B35"
M.gray = "#6B7280"
M.gray_dark = "#4B5563"
M.gray_mid = "#374151"
M.gray_border = "#2D3748"
M.bg_float = "#1E1E22"
M.bg_statusline = "#1B1B1D"
M.bg_visual = "#2A2D35"
M.bg_cursorline = "#22252B"
M.bg_inactive = "#111115"

-- Acentos futuristas
M.cyan = "#56B6C2"
M.green = "#98C379"
M.purple = "#C678DD"
M.blue = "#61AFEF"
M.yellow = "#E5C07B"

-- Aplicar highlights de Nothing Edition sobre onedark
function M.apply()
  local hi = vim.api.nvim_set_hl

  -- Fondo y texto base
  hi(0, "Normal", { fg = M.fg, bg = M.bg })
  hi(0, "NormalNC", { fg = M.fg, bg = M.bg })
  hi(0, "NormalFloat", { fg = M.fg, bg = M.bg_float })

  -- Cursor
  hi(0, "Cursor", { fg = M.bg, bg = M.fg })
  hi(0, "CursorLine", { bg = M.bg_cursorline })
  hi(0, "CursorLineNr", { fg = M.red, bold = true })

  -- Numeros de línea
  hi(0, "LineNr", { fg = M.gray_dark })
  hi(0, "SignColumn", { bg = M.bg })

  -- Selección visual
  hi(0, "Visual", { bg = M.bg_visual })

  -- Búsqueda (rojo Nothing)
  hi(0, "Search", { fg = M.bg, bg = M.red })
  hi(0, "IncSearch", { fg = M.bg, bg = M.red })
  hi(0, "CurSearch", { fg = M.bg, bg = M.orange })

  -- Comentarios
  hi(0, "Comment", { fg = M.gray, italic = true })

  -- Syntax: base onedark + acentos Nothing
  -- NOTA: onedark ya aplica bold/italic via code_style
  -- Solo sobreescribimos colores, NO tocamos bold/italic
  hi(0, "Function", { fg = M.blue, bold = true })
  hi(0, "Keyword", { fg = M.red, bold = true })
  hi(0, "Statement", { fg = M.red, bold = true })
  hi(0, "Conditional", { fg = M.red, bold = true })
  hi(0, "Repeat", { fg = M.red, bold = true })
  hi(0, "Operator", { fg = M.cyan })
  hi(0, "String", { fg = M.green, italic = true })
  hi(0, "Number", { fg = M.orange })
  hi(0, "Float", { fg = M.orange })
  hi(0, "Boolean", { fg = M.orange })
  hi(0, "Type", { fg = M.yellow, bold = true })
  hi(0, "Structure", { fg = M.yellow, bold = true })
  hi(0, "Constant", { fg = M.purple })
  hi(0, "Variable", { fg = M.fg })
  hi(0, "Identifier", { fg = M.fg })
  hi(0, "Label", { fg = M.orange })
  hi(0, "PreProc", { fg = M.red, italic = true })
  hi(0, "Include", { fg = M.red, italic = true })
  hi(0, "Define", { fg = M.red })
  hi(0, "Special", { fg = M.orange })
  hi(0, "SpecialChar", { fg = M.orange })
  hi(0, "Title", { fg = M.fg, bold = true })
  hi(0, "Error", { fg = M.red, bold = true })
  hi(0, "Todo", { fg = M.orange, bold = true, italic = true })

  -- Statusline Nothing
  hi(0, "StatusLine", { fg = M.fg, bg = M.bg_statusline })
  hi(0, "StatusLineNC", { fg = M.gray_dark, bg = M.bg_statusline })

  -- Borders: rojo Nothing en flotantes
  hi(0, "FloatBorder", { fg = M.red, bg = M.bg_float })
  hi(0, "NormalBorder", { fg = M.red, bg = M.bg_float })

  -- Pmenu (autocompletado)
  hi(0, "Pmenu", { fg = M.fg, bg = M.bg_float })
  hi(0, "PmenuSel", { fg = M.bg, bg = M.red, bold = true })
  hi(0, "PmenuSbar", { bg = M.gray_border })
  hi(0, "PmenuThumb", { bg = M.gray_dark })

  -- Diagnóstico
  hi(0, "DiagnosticError", { fg = M.red })
  hi(0, "DiagnosticWarn", { fg = M.orange })
  hi(0, "DiagnosticInfo", { fg = M.cyan })
  hi(0, "DiagnosticHint", { fg = M.gray })

  -- LSP references
  hi(0, "LspReferenceText", { bg = M.bg_visual })
  hi(0, "LspReferenceRead", { bg = M.bg_visual })
  hi(0, "LspReferenceWrite", { bg = M.bg_visual })

  -- WinSeparator
  hi(0, "WinSeparator", { fg = M.gray_border })

  -- Telescope
  hi(0, "TelescopeBorder", { fg = M.red, bg = M.bg_float })
  hi(0, "TelescopeSelection", { fg = M.fg, bg = M.bg_visual, bold = true })
  hi(0, "TelescopeMatching", { fg = M.red, bold = true })

  -- GitSigns
  hi(0, "GitSignsAdd", { fg = M.green })
  hi(0, "GitSignsChange", { fg = M.orange })
  hi(0, "GitSignsDelete", { fg = M.red })

  -- Noice
  hi(0, "NoiceCmdlineBorder", { fg = M.red })

  -- Trouble
  hi(0, "TroubleNormal", { fg = M.fg, bg = M.bg })

  -- Mini
  hi(0, "MiniCursorword", { bg = M.bg_visual })
  hi(0, "MiniIndentscopeSymbol", { fg = M.red })

  -- Marks
  hi(0, "MarkSignHlGrp", { fg = M.red })
  hi(0, "MarkSignNumHl", { fg = M.red })

  -- Alpha (dashboard futurista)
  hi(0, "AlphaHeader", { fg = M.red })
  hi(0, "AlphaButtons", { fg = M.fg })
  hi(0, "AlphaShortcut", { fg = M.orange, bold = true })

  -- LspProgress
  hi(0, "LspProgressTitle", { fg = M.red })
  hi(0, "LspProgressSpinner", { fg = M.orange })
  hi(0, "LspProgressDone", { fg = M.green })

  -- Illuminate
  hi(0, "illuminatedWord", { bg = M.bg_visual })
  hi(0, "illuminatedCurWord", { bg = M.bg_visual })

  -- Scrollbar
  hi(0, "ScrollbarHandle", { bg = M.gray_border })
  hi(0, "ScrollbarSearch", { fg = M.red })
  hi(0, "ScrollbarError", { fg = M.red })
  hi(0, "ScrollbarWarn", { fg = M.orange })
  hi(0, "ScrollbarInfo", { fg = M.cyan })
  hi(0, "ScrollbarHint", { fg = M.gray })
end

return M
