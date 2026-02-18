return {
  "Exaf-gd/codeium.vim",
  event = "BufEnter",
  config = function()
    -- Disable default bindings so we can set our own
    vim.g.codeium_disable_bindings = 1

    -- Set up keymaps
    local keymap = vim.keymap
    local opts = { noremap = true, silent = true }

    -- I'll use <leader>c as a prefix for Codeium commands
    -- Open Codeium Chat
    keymap.set("n", "<leader>cc", "<cmd>CodeiumChat<cr>", { desc = "Codeium - Chat" })
    -- Explain code
    keymap.set("v", "<leader>ce", "<cmd>CodeiumExplain<cr>", opts)
    -- Refactor code
    keymap.set("v", "<leader>cr", "<cmd>CodeiumRefactor<cr>", opts)
  end,
}
