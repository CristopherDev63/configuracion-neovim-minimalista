-- plugins/git.lua — Gitsigns, Fugitive, Diffview

return {
  ----------------------------------------------------------------
  -- Gitsigns: signos de Git en el gutter
  ----------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },

  ----------------------------------------------------------------
  -- Fugitive: Git clásico en Vim
  ----------------------------------------------------------------
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gwrite", "Gread", "Gdiffsplit", "Glog" },
    keys = {
      { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
      { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
      { "<leader>gP", "<cmd>Git pull<CR>", desc = "Git pull" },
    },
  },

  ----------------------------------------------------------------
  -- Diffview: diffs y historial visual
  ----------------------------------------------------------------
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff del archivo" },
      { "<leader>gl", "<cmd>DiffviewFileHistory<CR>", desc = "Log de Git" },
    },
    opts = {},
  },

  ----------------------------------------------------------------
  -- LazyGit: interfaz de Git en terminal
  ----------------------------------------------------------------
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {
      { "<leader>gs", "<cmd>LazyGit<CR>", desc = "Estado de Git" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
