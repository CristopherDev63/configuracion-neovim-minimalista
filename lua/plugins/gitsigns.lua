return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  cmd = { "Gitsigns" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = { hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      },
      signcolumn = true, -- Activa la columna de signos
      numhl = false, -- No resaltar el número de línea
      linehl = false, -- No resaltar la línea completa (iluminaba en colores de git)
      word_diff = false, -- Sin relleno de fondo sobre el código (solo signos en el gutter)
      watch_gitdir = {
        interval = 5000,
        follow_files = true,
      },
      attach_to_untracked = false,
      current_line_blame = false, -- Desactiva el "blame" en la línea actual por defecto
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
		update_debounce = 300,
      status_formatter = nil, -- nil para usar el formatter por defecto
      max_file_length = 40000,
      preview_config = {
        -- Opciones para la ventana de preview
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    })

    -- Keymaps para revisar los cambios que hace avante/opencode
    vim.keymap.set("n", "]c", function() require("gitsigns").next_hunk() end, { desc = "Git: Siguiente cambio" })
    vim.keymap.set("n", "[c", function() require("gitsigns").prev_hunk() end, { desc = "Git: Anterior cambio" })
    vim.keymap.set("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Git: Preview del cambio" })
    vim.keymap.set("n", "<leader>gd", function() require("gitsigns").diffthis() end, { desc = "Git: Diff contra HEAD" })
  end,
}
