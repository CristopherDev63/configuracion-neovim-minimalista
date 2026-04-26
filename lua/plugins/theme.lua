return {
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.everforest_background = "hard"
      vim.g.everforest_transparent_background = 0
      vim.g.everforest_enable_italic = true
      vim.g.everforest_bold = true
      vim.g.everforest_underline = true

      vim.o.background = "dark"

      vim.cmd([[colorscheme everforest]])

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "everforest",
        callback = function()
          vim.api.nvim_set_hl(0, "Normal", { bg = "#2d383a" })
          vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2d383a" })
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