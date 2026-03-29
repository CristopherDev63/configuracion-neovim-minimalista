return {
  {
    "uloco/bluloco.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      require("bluloco").setup({
        style = "light",
        transparent = false,
        italics = true,
        terminal_colors = true,
        guicursor = true,
      })
      vim.o.background = "light"
      vim.cmd("colorscheme bluloco-light")
    end,
  },
}
