return {
  {
    -- No declaramos toggleterm aquí, solo agregamos keymaps
    -- Toggleterm ya se carga desde plugins.toggleterm
    "akinsho/toggleterm.nvim",
    init = function()
      local live_server = nil

      function _G.start_live_server()
        local Terminal = require("toggleterm.terminal").Terminal
        local cwd = vim.fn.getcwd()
        local args = { "--port=3000", "--no-browser", "--wait=500", cwd }
        live_server = Terminal:new({
          cmd = "live-server " .. table.concat(args, " "),
          direction = "float",
          display_name = "  Live Server",
          on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          end,
          on_close = function()
            print(" Live Server detenido")
          end,
        })
        live_server:toggle()
        vim.defer_fn(function()
          vim.cmd("silent !open http://localhost:3000")
        end, 500)
      end

      function _G.stop_live_server()
        if live_server and live_server:is_open() then
          live_server:shutdown()
          print(" Live Server detenido")
        else
          print(" Live Server no está corriendo")
        end
      end

      function _G.toggle_live_server()
        if live_server and live_server:is_open() then
          stop_live_server()
        else
          start_live_server()
        end
      end

      vim.keymap.set("n", "<leader>ls", ":lua toggle_live_server()<CR>", { desc = " Iniciar/Detener Live Server" })
      vim.keymap.set("n", "<leader>lq", ":lua stop_live_server()<CR>", { desc = " Detener Live Server" })
      vim.keymap.set("n", "<leader>lo", ":lua start_live_server()<CR>", { desc = " Iniciar Live Server" })
    end,
  },
}
