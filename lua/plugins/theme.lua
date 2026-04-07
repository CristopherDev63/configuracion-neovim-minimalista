return {
  {
    "sainnhe/gruvbox-material",
    name = "gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      -- Configuración de Gruvbox Material
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 1
      
      -- Asegurar fondo oscuro
      vim.o.background = "dark"
      
      -- Cargar el esquema de colores
      vim.cmd([[colorscheme gruvbox-material]])

      -- Mantener estilos personalizados de legibilidad
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruvbox-material",
        callback = function()
          vim.api.nvim_set_hl(0, "Comment", { italic = true })
          vim.api.nvim_set_hl(0, "@comment", { italic = true })
          vim.api.nvim_set_hl(0, "@variable.parameter", { italic = true })
          vim.api.nvim_set_hl(0, "Keyword", { bold = true })
          vim.api.nvim_set_hl(0, "@keyword", { bold = true })
          vim.api.nvim_set_hl(0, "@keyword.function", { bold = true })
          vim.api.nvim_set_hl(0, "@keyword.conditional", { bold = true })
        end,
      })
    end,
  },
}
