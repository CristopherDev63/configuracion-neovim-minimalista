return {
  {
    "hat0uma/csvview.nvim",
    config = function()
      require("csvview").setup({
        parser = { comments = { "#", "//" } },
        keymaps = {
          -- Text objects for selecting fields
          textobject_field_inner = { "if", mode = { "o", "x" } },
          textobject_field_outer = { "af", mode = { "o", "x" } },
          -- Excel-like navigation
          jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
          jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
          jump_next_row = { "<Enter>", mode = { "n", "v" } },
          jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
        },
        view = {
          display_mode = "highlight_groups", -- or "border"
        },
      })
      
      -- Toggle keymap
      vim.keymap.set("n", "<leader>cv", "<cmd>CsvViewToggle<cr>", { desc = "📊 Toggle CSV View" })
    end,
  },
}
