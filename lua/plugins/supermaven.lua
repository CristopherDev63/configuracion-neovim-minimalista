-- Supermaven: IA con ghost text real tipo Cursor/Copilot
-- Carga diferida: solo cuando entras a modo inserción
return {
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		config = function()
			require("supermaven-nvim").setup({
				-- Ghost text (como Cursor/Copilot)
				ghost_text = {
					enabled = true,
				},
				
				-- Keymaps para aceptar/rechazar (Alt/Meta funciona en INSERT)
				keymap = {
					accept_suggestion = "<A-l>", -- Alt+l para aceptar
					clear_suggestion = "<A-c>", -- Alt+c para cancelar
					next_suggestion = "<A-n>", -- Alt+n siguiente
					prev_suggestion = "<A-p>", -- Alt+p anterior
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
