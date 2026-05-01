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
				
				-- Keymaps para aceptar/rechazar (usando leader para evitar conflictos)
				keymap = {
					accept_suggestion = "<leader>ia", -- Aceptar sugerencia
					clear_suggestion = "<leader>ic", -- Cancelar sugerencia
					next_suggestion = "<leader>in", -- Siguiente sugerencia
					prev_suggestion = "<leader>ip", -- Anterior sugerencia
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
