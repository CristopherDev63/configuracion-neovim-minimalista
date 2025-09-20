-- lua/plugins/cmp.lua - INTEGRADO CON GEMINI AUTOMÁTICO
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
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

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
						},
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					-- MODIFICADO: Shift+Tab para retroceder
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					-- Ctrl+G sigue siendo para forzar Gemini
					["<C-g>"] = cmp.mapping(function()
						-- Cerrar CMP si está abierto
						cmp.abort()

						-- Limpiar cualquier completación de Gemini
						if _G.clear_gemini_completion then
							_G.clear_gemini_completion()
						end

						-- Forzar nueva completación de Gemini
						vim.schedule(function()
							if _G.trigger_gemini_completion then
								_G.trigger_gemini_completion()
							end
						end)
					end, { "i" }),

					-- Ctrl+E para rechazar Gemini sin afectar CMP
					["<C-e>"] = cmp.mapping(function(fallback)
						-- Si hay completación de Gemini, rechazarla
						if vim.b.gemini_pending_completion and _G.clear_gemini_completion then
							_G.clear_gemini_completion()
						-- Si CMP está abierto, cerrarlo
						elseif cmp.visible() then
							cmp.abort()
						else
							fallback()
						end
					end, { "i" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{ name = "luasnip", priority = 500 },
					{ name = "buffer", priority = 250 },
					{ name = "path", priority = 250 },
				}),
			})

			-- Configuración de colores
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#3e4452" })

			-- ========== INTEGRACIÓN CON GEMINI AUTOMÁTICO ==========

			-- Función global para que Gemini pueda integrar con CMP
			_G.accept_gemini_completion = function()
				local completion = vim.b.gemini_pending_completion
				if not completion then
					return false
				end

				-- Limpiar la sugerencia visual
				local completion_namespace = vim.api.nvim_get_namespaces()["gemini_completion"]
				if completion_namespace then
					vim.api.nvim_buf_clear_namespace(0, completion_namespace, 0, -1)
				end

				-- Insertar el texto
				local lines = vim.split(completion, "\n")
				if lines[1] and lines[1] ~= "" then
					vim.api.nvim_put({ lines[1] }, "c", false, true)
				end

				vim.b.gemini_pending_completion = nil
				return true
			end

			_G.clear_gemini_completion = function()
				local completion_namespace = vim.api.nvim_get_namespaces()["gemini_completion"]
				if completion_namespace then
					vim.api.nvim_buf_clear_namespace(0, completion_namespace, 0, -1)
				end
				vim.b.gemini_pending_completion = nil
			end

			-- Auto-comando para limpiar Gemini cuando CMP se abre
			vim.api.nvim_create_autocmd("User", {
				pattern = "CmpMenuOpened",
				callback = function()
					if _G.clear_gemini_completion then
						_G.clear_gemini_completion()
					end
				end,
				desc = "Limpiar Gemini cuando CMP se abre",
			})

			print("✅ CMP integrado con Gemini automático")
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
