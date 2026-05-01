-- Supermaven: IA con ghost text real tipo Cursor/Copilot
-- No afecta el input lag porque renderiza texto independiente
return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				-- Ghost text (como Cursor/Copilot)
				ghost_text = {
					enabled = true,
				},
				
				-- Keymaps para aceptar/rechazar (funcionan en INSERT y NORMAL)
				keymap = {
					accept_suggestion = "<C-l>", -- Ctrl+l para aceptar (INSERT/NORMAL)
					clear_suggestion = "<C-c>", -- Ctrl+c para cancelar
					next_suggestion = "<C-n>", -- Ctrl+n siguiente
					prev_suggestion = "<C-p>", -- Ctrl+p anterior
				},
				
				-- Ignorar archivos grandes para ahorrar recursos
				ignore_filetypes = { "neo-tree", "NvimTree", "terminal", "toggleterm" },
				
				-- Desactivar panel de chat (ahorra memoria)
				panel = {
					enabled = false,
				},
				
				-- Solo procesa cuando dejas de escribir (no en cada tecla)
				debounce = 800,
			})
		end,
	},
}
