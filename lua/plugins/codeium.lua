-- Codeium independiente tipo Cursor/Copilot
-- Funciona con ghost text propio sin afectar el input lag de blink
return {
	{
		"Exafunction/codeium.nvim",
		cmd = "Codeium",
		build = ":Codeium Auth",
		event = { "BufEnter" },
		config = function()
			require("codeium").setup({
				-- Debounce agresivo: espera 800ms después de dejar de escribir
				debounce = 800,
				
				-- Desactivar chat y otros componentes pesados
				enable_chat = false,
				
				-- Keymaps para aceptar/rechazar sugerencias
				keymap = {
					accept = "<M-l>", -- Alt+l para aceptar (como Cursor)
					accept_word = "<M-w>",
					accept_line = "<M-;>",
					clear = "<M-c>",
					next = "<M-]>",
					prev = "<M-[>",
				},
				
				-- Lenguajes donde está habilitado (opcional, ahorra recursos)
				enabled = function()
					return vim.bo.buftype == "" and vim.bo.filetype ~= ""
				end,
			})
		end,
	},
}
