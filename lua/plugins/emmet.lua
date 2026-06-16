return {
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascript", "jsx", "tsx", "xml", "svg" },
    config = function()
      vim.g.user_emmet_leader_key = "<Tab>"
      vim.g.user_emmet_settings = {
        html = {
          snippets = {},
        },
      }
    end,
  },
}
