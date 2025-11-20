return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    -- Enable transparency
    vim.g.gruvbox_transparent_bg = 1

    -- Load the colorscheme
    vim.cmd.colorscheme("gruvbox")
  end,
}
