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
        }
      })
      
      -- Desactivar el texto virtual por defecto de Neovim
      vim.diagnostic.config({ virtual_text = false })
      
      -- MEJORA DE LEGIBILIDAD PARA TEMAS CLAROS (Hybrid Light)
      -- Forzamos colores más oscuros y saturados para que contrasten con el fondo claro.
      local highlights = {
        DiagnosticError = { fg = "#CC0000", bold = true }, -- Rojo intenso
        DiagnosticWarn  = { fg = "#CC6600", bold = true }, -- Naranja quemado
        DiagnosticInfo  = { fg = "#006699", bold = true }, -- Azul marino
        DiagnosticHint  = { fg = "#006666", bold = true }, -- Verde oscuro
      }

      for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
      end
    end,
  },
}
