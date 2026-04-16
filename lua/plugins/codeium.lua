return {
  "Exaf-gd/codeium.vim",
  cmd = "CodeiumEnable", -- Cargar solo al ejecutar el comando
  config = function()
    vim.g.codeium_disable_bindings = 1
    vim.g.codeium_enabled = false -- Desactivado por defecto (Optimización Radical)
    vim.g.codeium_idle_delay = 1000 -- Mayor tiempo de espera para el autocompletado

    -- Mapeo para activar Codeium solo cuando se necesite
    vim.keymap.set("n", "<leader>ct", function()
        vim.cmd("CodeiumEnable")
        print("🤖 Codeium Activado")
    end, { desc = "Activar Codeium" })
  end,
}
