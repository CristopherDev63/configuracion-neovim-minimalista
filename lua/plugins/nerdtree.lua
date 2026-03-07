lua/plugins/nerdtree.lua
return {
  {
    "preservim/nerdtree",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "NERDTreeToggle",
    config = function()
      -- Mapeo para abrir NERDTree
      vim.keymap.set("n", "<leader>n", ":NERDTreeToggle<CR>", { desc = "🔍 Abrir NERDTree" })

      -- Abrir NERDTree al iniciar Neovim
      vim.cmd("autocmd VimEnter * NERDTree")
    end,
  },
}
