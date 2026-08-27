-- user/shortcuts.lua — Atajos personalizados que dependen de plugins cargados
-- Se ejecuta después de que lazy.nvim carga todos los plugins

local map = vim.keymap.set

-- Ayuda: buscar comandos y atajos con Telescope
map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Buscar atajos" })
map("n", "<leader>fc", "<cmd>Telescope commands<CR>", { desc = "Buscar comandos" })

-- Copiar ruta del archivo
map("n", "<leader>cp", ':let @+=expand("%:p")<CR>', { desc = "Copiar ruta del archivo" })
