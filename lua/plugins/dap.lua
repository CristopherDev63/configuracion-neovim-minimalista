local function setup_dap_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "<F5>", require("dap").continue, opts)
  vim.keymap.set("n", "<F10>", require("dap").step_over, opts)
  vim.keymap.set("n", "<F11>", require("dap").step_into, opts)
  vim.keymap.set("n", "<F12>", require("dap").step_out, opts)
  vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, opts)
  vim.keymap.set("n", "<leader>dc", require("dap").continue, opts)
  vim.keymap.set("n", "<leader>dK", require("dap").up, opts)
  vim.keymap.set("n", "<leader>dJ", require("dap").down, opts)
  vim.keymap.set("n", "<leader>dr", require("dap").repl.toggle, opts)
  vim.keymap.set("n", "<leader>di", require("dap.ui.widgets").hover, opts)
end

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>",  desc = "DAP: Continuar" },
      { "<F10>", desc = "DAP: Step over" },
      { "<F11>", desc = "DAP: Step into" },
      { "<F12>", desc = "DAP: Step out" },
    },
    config = function()
      local dap = require("dap")
      dap.listeners.after.event_initialized["dap"] = function()
        setup_dap_keymaps(vim.api.nvim_get_current_buf())
      end
      dap.listeners.after.event_terminated["dap"] = function()
        vim.api.nvim_del_keymap("n", "<F5>")
        vim.api.nvim_del_keymap("n", "<F10>")
        vim.api.nvim_del_keymap("n", "<F11>")
        vim.api.nvim_del_keymap("n", "<F12>")
      end

      local dap_python = require("dap-python")
      dap_python.setup("python3")
      dap_python.test_runner = "pytest"
    end,
    dependencies = {
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          require("dap-python").setup("python3")
        end,
      },
      {
        "nvim-neotest/nvim-nio",
      },
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          { "<leader>du", desc = "DAP UI: Toggle" },
        },
        opts = {},
        config = function(_, opts)
          local dapui = require("dapui")
          dapui.setup(opts)
          local dap = require("dap")
          dap.listeners.after.event_initialized["dapui"] = dapui.open
          dap.listeners.before.event_terminated["dapui"] = dapui.close
          dap.listeners.before.event_exited["dapui"] = dapui.close
          vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI: Toggle" })
        end,
      },
    },
  },
}
