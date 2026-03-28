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
          multilines = true,
        },
        hi = {
          background = "CursorLine", 
          -- Vinculamos los colores base a los grupos estándar de Neovim
          error = "DiagnosticError",
          warn = "DiagnosticWarn",
          info = "DiagnosticInfo",
          hint = "DiagnosticHint",
          arrow = "CursorLineNr", -- Usamos un color más neutro para la flecha
        }
      })
      
      vim.diagnostic.config({ virtual_text = false })
      
      -- AJUSTE DE COLORES: BORDES Y TEXTO
      -- fg: controla los bordes y símbolos (un poco más claros)
      -- bg: el fondo del mensaje (muy suave)
      local highlights = {
        -- Grupos de diagnóstico estándar (texto de los mensajes)
        DiagnosticError = { fg = "#B71C1C", bold = true }, -- Rojo oscuro legible
        DiagnosticWarn  = { fg = "#E65100", bold = true }, -- Naranja oscuro legible
        DiagnosticInfo  = { fg = "#01579B", bold = true }, -- Azul oscuro legible
        DiagnosticHint  = { fg = "#004D40", bold = true }, -- Verde oscuro legible
        
        -- Grupos específicos para el recuadro de tiny-inline-diagnostic
        -- Aquí es donde definimos el color de los bordes redondeados (fg) y el fondo (bg)
        TinyInlineDiagnosticVirtualTextError = { fg = "#E57373", bg = "#FFEBEE" }, -- Bordes rojo suave
        TinyInlineDiagnosticVirtualTextWarn  = { fg = "#FFB74D", bg = "#FFF3E0" }, -- Bordes naranja suave
        TinyInlineDiagnosticVirtualTextInfo  = { fg = "#64B5F6", bg = "#E1F5FE" }, -- Bordes azul suave
        TinyInlineDiagnosticVirtualTextHint  = { fg = "#4DB6AC", bg = "#E0F2F1" }, -- Bordes verde suave
      }

      for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end,
  },
}
