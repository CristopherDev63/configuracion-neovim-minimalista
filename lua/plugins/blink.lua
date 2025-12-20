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
					Event = "󱙺", -- Usamos Event para representar a Codeium
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
						module = "blink.compat.source",
						score_offset = 100,
						async = true,
						min_keyword_length = 0, -- IMPORTANTE: Activar con 0 caracteres (incluso espacios)
						max_items = 3,          -- MÁXIMO 3 sugerencias (para no molestar)
						timeout_ms = 5000,      -- Darle tiempo a la IA para pensar si la red es lenta
						transform_items = function(_, items)
							local CompletionItemKind = vim.lsp.protocol.CompletionItemKind
							local kind_idx = CompletionItemKind.Event -- Usaremos 'Event' como proxy para Codeium
							for _, item in ipairs(items) do
								item.kind = kind_idx
								item.kind_name = "AI" -- Renombrar "Event" (o Property) a "AI" visiblemente
							end
							return items
						end,
					},
				},
			},

			-- Ventana de documentación flotante automática
			completion = {
				menu = {
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
					},
				},
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