return {
  {
    "kepano/flexoki-neovim",
    name = "flexoki",
    lazy = false,
    priority = 1000,
    config = function()
      require("flexoki").setup({
        transparent = false,
        variant = "dark", -- Forzar la variante dark
      })
      vim.cmd("colorscheme flexoki-dark")
    end,
  },
}
