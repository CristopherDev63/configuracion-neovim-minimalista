return {
  {
    "EdenEast/nightfox.nvim",
    name = "nightfox",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          terminal_colors = true,
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
          dim_inactive = false,
          transparent_mode = false,
        },
      })

      vim.o.background = "dark"

      vim.cmd([[colorscheme nightfox]])

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "nightfox",
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
