-- lua/plugins/cmp.lua - INTEGRADO CON CODEIUM
return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"Exafunction/codeium.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			-- Configurar Codeium (con manejo de errores)
			local ok, codeium = pcall(require, "codeium")
			if ok then
				pcall(codeium.setup, { enable_ghost_text = false })
			end

			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = {
						border = "rounded",
						winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
					},
					documentation = {
						border = "rounded",
						winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
					},
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							luasnip = "[LuaSnip]",
							nvim_lua = "[Lua]",
							latex_symbols = "[Latex]",
							path = "[Path]",
							codeium = "[🤖 AI]",

						},
					}),
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<C-e>'] = cmp.mapping.abort(),

					-- New j/k mappings
					['j'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['k'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { 'i', 's' }),

					-- Keep Tab for snippet navigation
					['<Tab>'] = cmp.mapping(function(fallback)
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { 'i', 's' }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000, keyword_length = 1 }, -- Mejor para Java

					{ name = "codeium", priority = 800 },
					{ name = "luasnip", priority = 500 },
					{ name = "buffer", priority = 250, keyword_length = 3 },
					{ name = "path", priority = 250 },
				}),
			})

			-- Configuración de colores
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#3e4452" })
			vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { fg = "#6CC644" })

			print("✅ CMP integrado con Codeium")
		end,
	},

	-- SNIPPETS (sin cambios)
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local luasnip = require("luasnip")
			local types = require("luasnip.util.types")

			luasnip.config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
				enable_autosnippets = true,
				ext_opts = {
					[types.choiceNode] = {
						active = {
							virt_text = { { "•", "GruvboxOrange" } },
						},
					},
					[types.insertNode] = {
						active = {
							virt_text = { { "•", "GruvboxBlue" } },
						},
					},
				},
				ft_func = function()
					return vim.split(vim.bo.filetype, ".", true)
				end,
			})

			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })

			-- Cargar snippets específicos para PHP
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = {
					vim.fn.stdpath("config") .. "/php-snippets",
				},
			})

			-- Mapeos de snippets (sin conflicto con Gemini)
			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				end
			end, { desc = "Cambiar opción en snippet" })

			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				end
			end, { desc = "Expandir o saltar al siguiente snippet" })

			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { desc = "Saltar al snippet anterior" })

			vim.keymap.set("i", "<C-u>", function()
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				end
			end, { desc = "Cambiar opción en snippet" })
		end,
	},
}
