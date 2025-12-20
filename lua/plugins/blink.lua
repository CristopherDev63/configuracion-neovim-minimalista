return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{ "saghen/blink.compat", version = "*", opts = {} }, -- Adaptador para fuentes viejas
			{
				"Exafunction/codeium.nvim",
				cmd = "Codeium",
				build = ":Codeium Auth",
				opts = {},
			},
		},
		version = "*", -- Usa releases estables

		opts = {
			keymap = {
				preset = "default",
				
				-- ENTER acepta la sugerencia (Lo que pediste)
				["<CR>"] = { "accept", "fallback" },

				-- Comportamiento tipo VS Code para Tab
				["<Tab>"] = {
					function(cmp)
						if cmp.snippet_active() then return cmp.accept() end
						if cmp.is_visible() then return cmp.select_next() end
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
				kind_icons = {
					Codeium = "🤖", -- Icono personalizado para Codeium
				},
			},

			sources = {
				-- Añadimos 'codeium' a la lista
				default = { "lsp", "path", "snippets", "buffer", "codeium" },
				
				providers = {
					lsp = { score_offset = 100 }, -- LSP primero (más importante)
					
					-- Configuración de CODEIUM
					codeium = {
						name = "codeium",
						module = "blink.compat.source", -- Usar adaptador
						score_offset = -3,              -- Prioridad baja (aparece al final)
						max_items = 3,                  -- MÁXIMO 3 sugerencias (para no molestar)
						async = true,
					},
				},
			},

			-- Ventana de documentación flotante automática
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = true,
				},
				list = {
					selection = { preselect = true, auto_insert = false },
				},
			},

			signature = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},
}