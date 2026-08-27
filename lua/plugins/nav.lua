-- plugins/nav.lua — Navegación: nvim-tree, harpoon, oil

return {
  ----------------------------------------------------------------
  -- nvim-tree: explorador de archivos estilo VSCode
  ----------------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeToggle",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorador de archivos" },
      { "<leader>E", "<cmd>NvimTreeFocus<CR>", desc = "Enfocar explorador" },
    },
    opts = {
      view = { width = 30, side = "left" },
      renderer = { icons = { show = false } },
      filters = { dotfiles = false },
    },
  },

  ----------------------------------------------------------------
  -- Harpoon: marcas y saltos rápidos entre archivos
  ----------------------------------------------------------------
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  ----------------------------------------------------------------
  -- Oil: explorador de archivos como buffer
  ----------------------------------------------------------------
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Explorar directorio" },
    },
    opts = {
      default_file_explorer = false,
      view_options = { show_hidden = true },
    },
  },
}
