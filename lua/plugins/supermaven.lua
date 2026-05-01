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
				
				-- Keymaps para aceptar/rechazar
				keymap = {
					accept_suggestion = "<M-l>", -- Alt+l para aceptar
					clear_suggestion = "<M-c>", -- Alt+c para cancelar
					next_suggestion = "<M-]>", -- Siguiente sugerencia
					prev_suggestion = "<M-[>", -- Anterior sugerencia
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
