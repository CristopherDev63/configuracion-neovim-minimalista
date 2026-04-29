return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
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

		config = function(_, opts)
			-- Cargamos friendly-snippets en LuaSnip explícitamente
			require("luasnip.loaders.from_vscode").lazy_load()
			
			-- Configuración de TRANSPARENCIA para el menú de autocompletado
			local highlights = {
				BlinkCmpMenu = { bg = "NONE" },
				BlinkCmpMenuBorder = { bg = "NONE" },
				BlinkCmpDoc = { bg = "NONE" },
				BlinkCmpDocBorder = { bg = "NONE" },
				BlinkCmpSignatureHelp = { bg = "NONE" },
				BlinkCmpSignatureHelpBorder = { bg = "NONE" },
				-- Para compatibilidad con otros temas que usen Pmenu
				Pmenu = { bg = "NONE" },
				PmenuSbar = { bg = "NONE" },
				PmenuThumb = { bg = "NONE" },
				-- Texto en blanco para mejor visibilidad
				BlinkCmpLabel = { fg = "#FFFFFF" },
				BlinkCmpLabelDescription = { fg = "#FFFFFF" },
				BlinkCmpKind = { fg = "#FFFFFF" },
				BlinkCmpSource = { fg = "#FFFFFF" },
			}

			for group, hl in pairs(highlights) do
				vim.api.nvim_set_hl(0, group, hl)
			end

			-- Aplicamos la configuración de blink
			require("blink.cmp").setup(opts)
		end,

		opts = {
			-- DESACTIVAR autocompletado en comentarios y prompts
			enabled = function()
				if vim.bo.buftype == "prompt" then
					return false
				end
				local success, node = pcall(vim.treesitter.get_node)
				if success and node then
					local node_type = node:type()
					-- Lista de tipos de nodos donde NO queremos autocompletado automático
					local ignored_types = { "comment", "comment_content", "string", "string_content" }
					for _, type in ipairs(ignored_types) do
						if node_type == type then
							return false
						end
					end
				end
				return true
			end,

			-- USAR LUASNIP como motor de snippets
			snippets = {
				preset = "luasnip",
			},

			keymap = {
				preset = "default",
				
				["<CR>"] = {
					function(cmp)
						if vim.g.VM_visible == 1 or vim.b.visual_multi then
							return false 
						end
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
					-- RUTAS: Prioridad muy alta y priorizamos carpetas
					path = {
						score_offset = 150, -- Por encima de LSP (100)
						opts = {
							-- Aseguramos que se busquen rutas en todos los archivos
							trailing_slash = true,
							label_trailing_slash = true,
							get_cwd = function(context) return vim.fn.expand(('#%d:p:h'):format(context.bufnr)) end,
							show_hidden_files_by_default = true,
						},
						transform_items = function(_, items)
							local CompletionItemKind = vim.lsp.protocol.CompletionItemKind
							for _, item in ipairs(items) do
								-- Si es una carpeta, le damos un bonus extra de score
								if item.kind == CompletionItemKind.Folder then
									item.score_offset = item.score_offset or 0
									item.score_offset = item.score_offset + 10 -- Bonus para carpetas
								end
							end
							return items
						end,
					},
					snippets = {
						score_offset = 80,
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
				-- (Optimización Extrema - Paso 3 corregido)
				list = {
					selection = { preselect = true, auto_insert = false },
				},
				menu = {
					draw = {
						columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 500,
				},
				ghost_text = {
					enabled = true,
				},
			},

			signature = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},
}
