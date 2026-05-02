return {
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      require('ayu').setup({
        mirage = false,
        theme = "dark",
        overrides = {},
      })
      vim.cmd([[colorscheme ayu]])
      
      -- Números de línea en gris azulado que combina con Ayu Dark
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#5c6773" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#7f8489", bold = true })
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#5c6773" })
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#5c6773" })
    end,
  },
}