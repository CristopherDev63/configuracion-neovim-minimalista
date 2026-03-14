return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{ "saghen/blink.compat", version = "*", opts = {} },
			{
				"Exafunction/codeium.nvim",
				cmd = "Codeium",
				build = ":Codeium Auth",
				opts = {},
			},
		},
		version = "*",

		opts = {
			-- Usamos el motor de snippets interno de blink que es más compatible con friendly-snippets
			snippets = {
				preset = "default",
			},

			keymap = {
				preset = "default",
				
				-- ENTER: Acepta la sugerencia. Si es un snippet, lo expande.
				["<CR>"] = {
					function(cmp)
						-- Si VM está activo, dejamos que VM maneje el Enter
						if vim.g.VM_visible == 1 or vim.b.visual_multi then
							return false 
						end
						-- Intentamos aceptar/expandir la sugerencia
						return cmp.accept()
					end,
					"fallback",
				},

				["<Tab>"] = {
					function(cmp)
						if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then return cmp.accept() end
						return cmp.select_next()
					end,
					"snippet_forward",
					"fallback",
				},
				["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
				
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
			},

			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "codeium" },
				providers = {
					lsp = { score_offset = 100 },
					snippets = {
						score_offset = 80,
						opts = {
							friendly_snippets = true,
							search_paths = { vim.fn.stdpath("data") .. "/lazy/friendly-snippets" },
						}
					},
					codeium = {
						name = "codeium",
						module = "blink.compat.source",
						score_offset = 100,
						async = true,
						min_keyword_length = 0,
						max_items = 3,
					},
				},
			},

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
