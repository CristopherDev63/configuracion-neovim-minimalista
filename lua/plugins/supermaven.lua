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
				
				-- Keymaps para aceptar/rechazar (sin conflictos con tmux/neovim)
				keymap = {
					accept_suggestion = "<F5>", -- F5 para aceptar sugerencia
					clear_suggestion = "<F6>", -- F6 para cancelar
					next_suggestion = "<F7>", -- F7 siguiente sugerencia
					prev_suggestion = "<F8>", -- F8 anterior sugerencia
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
