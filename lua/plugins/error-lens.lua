return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require('tiny-inline-diagnostic').setup({
        preset = "modern",
        options = {
          show_source = true,
          use_icons_from_diagnostic = true,
          add_messages = true,
          throttle = 20,
          softwrap = 30,
          -- Desactivamos la transparencia del mensaje para que no herede el fondo de la terminal
          multilines = true,
        },
        hi = {
          -- Forzamos que el fondo sea el de la línea actual (que en temas claros es gris clarito)
          background = "CursorLine", 
          -- Forzamos colores de texto muy oscuros para legibilidad máxima en fondo claro
          error = "DiagnosticError",
          warn = "DiagnosticWarn",
          info = "DiagnosticInfo",
          hint = "DiagnosticHint",
          arrow = "DiagnosticError",
        }
      })
      
      vim.diagnostic.config({ virtual_text = false })
      
      -- COLORES DE ALTO CONTRASTE PARA TEMA CLARO
      -- Usamos colores oscuros para el texto (fg) y definimos fondos suaves si es necesario
      local highlights = {
        -- Texto oscuro y saturado
        DiagnosticError = { fg = "#8B0000", bold = true }, -- Rojo sangre oscuro
        DiagnosticWarn  = { fg = "#8B4513", bold = true }, -- Marrón/Naranja oscuro
        DiagnosticInfo  = { fg = "#004080", bold = true }, -- Azul marino oscuro
        DiagnosticHint  = { fg = "#004d40", bold = true }, -- Verde pino oscuro
        
        -- Ajuste para los grupos de tiny-inline-diagnostic específicamente
        TinyInlineDiagnosticVirtualTextError = { fg = "#8B0000", bg = "#FFEBEE" }, -- Fondo rosado muy suave
        TinyInlineDiagnosticVirtualTextWarn  = { fg = "#8B4513", bg = "#FFF3E0" }, -- Fondo naranja muy suave
        TinyInlineDiagnosticVirtualTextInfo  = { fg = "#004080", bg = "#E1F5FE" }, -- Fondo azul muy suave
        TinyInlineDiagnosticVirtualTextHint  = { fg = "#004d40", bg = "#E0F2F1" }, -- Fondo verde muy suave
      }

      for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end,
  },
}
