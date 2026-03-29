return {
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      require("ayu").setup({
        overrides = {},
      })
      vim.o.background = "light"
      vim.cmd("colorscheme ayu-light")
    end,
  },
}
