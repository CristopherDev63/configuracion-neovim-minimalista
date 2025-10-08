return {
  "preservim/nerdtree",
  dependencies = {
    "ryanoasis/vim-devicons",
  },
  config = function()
    vim.g.NERDTreeDirArrowExpandable = '▸'
    vim.g.NERDTreeDirArrowCollapsible = '▾'

    local highlights = {
      NERDTreeDir      = { fg = "#87afd7" },
      NERDTreeDirSlash = { fg = "#87afd7" },
      NERDTreeOpenable = { fg = "#ffaf87" },
      NERDTreeClosable = { fg = "#ffaf87" },
      NERDTreeFile     = { fg = "#e4e4e4" },
      NERDTreeExecFile = { fg = "#87d787" },
      NERDTreeUp       = { fg = "#ffd787" },
      NERDTreeCWD      = { fg = "#d7afff" },
      NERDTreeHelp     = { fg = "#8a8a8a" },
      NERDTreeBookmark = { fg = "#ff87af" },
    }

    for group, colors in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, colors)
    end
  end,
}
