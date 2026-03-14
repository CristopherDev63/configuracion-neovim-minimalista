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
			-- Configuración de Snippets (Uso nativo de Neovim 0.10+)
			snippets = {
				preset = "default",
			},

			keymap = {
				preset = "default",
				
				-- Solución para vim-visual-multi: 
				-- Si estamos en modo multi-cursor, ignoramos blink y usamos el comportamiento normal (fallback)
				["<CR>"] = {
					function(cmp)
						if vim.g.VM_visible == 1 or vim.b.visual_multi then
							return false -- Esto permite que el fallback actúe
						end
						return cmp.accept()
					end,
					"fallback",
				},

				["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
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
