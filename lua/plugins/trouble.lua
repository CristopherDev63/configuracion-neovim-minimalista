return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Problemas: Toggle" },
      { "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Problemas: Buffer actual" },
      { "]e", function()
        require("trouble").next({ skip_groups = true, jump = true })
      end, desc = "Siguiente error" },
      { "[e", function()
        require("trouble").previous({ skip_groups = true, jump = true })
      end, desc = "Error anterior" },
    },
    opts = {
      focus = false,
      win = {
        position = "bottom",
        size = 10,
      },
    },
  },
}
