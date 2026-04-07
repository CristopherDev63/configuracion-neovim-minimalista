return {
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = false,
    priority = 1000,
    config = function()
      -- Configuración de Gruvbox (versión clásica Lua)
      require("gruvbox").setup({
        terminal_colors = true, -- add neovim terminal colors
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = true,
          emphasis = true,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, quiet pastels
        contrast = "hard", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      })
      
      -- Asegurar fondo oscuro y contraste hard
      vim.o.background = "dark"
      
      -- Cargar el esquema de colores
      vim.cmd([[colorscheme gruvbox]])

      -- Mantener estilos personalizados de legibilidad adicionales (si hicieran falta)
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruvbox",
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
