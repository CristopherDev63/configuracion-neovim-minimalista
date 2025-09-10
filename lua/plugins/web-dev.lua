-- lua/plugins/web-dev.lua
-- Configuración completa para desarrollo web (HTML, CSS, JavaScript)

return {
	-- ========== LSP SERVERS PARA WEB ==========
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				-- HTML Language Server
				html = {
					filetypes = { "html", "templ" },
				},
				-- CSS Language Server
				cssls = {
					settings = {
						css = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
						scss = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
						less = {
							validate = true,
							lint = {
								unknownAtRules = "ignore",
							},
						},
					},
				},
				-- Emmet para autocompletado rápido
				emmet_ls = {
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"vue",
						"svelte",
					},
					init_options = {
						html = {
							options = {
								["bem.enabled"] = true,
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Función on_attach común
			local on_attach = function(client, bufnr)
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Mapeos LSP básicos
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
			end

			-- Configurar HTML LSP
			lspconfig.html.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "html", "templ" },
				settings = {
					html = {
						format = {
							templating = true,
							wrapLineLength = 120,
							unformatted = "wbr",
							contentUnformatted = "pre,code,textarea",
							indentInnerHtml = true,
							preserveNewLines = true,
							indentHandlebars = false,
							endWithNewline = false,
							extraLiners = "head, body, /html",
							wrapAttributes = "auto",
						},
						hover = {
							documentation = true,
							references = true,
						},
					},
				},
			})

			-- Configurar CSS LSP
			lspconfig.cssls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					css = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
					scss = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
					less = {
						validate = true,
						lint = {
							unknownAtRules = "ignore",
						},
					},
				},
			})

			-- Configurar Emmet LSP
			lspconfig.emmet_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = {
					"html",
					"typescriptreact",
					"javascriptreact",
					"css",
					"sass",
					"scss",
					"less",
					"vue",
					"svelte",
				},
				init_options = {
					html = {
						options = {
							["bem.enabled"] = true,
						},
					},
				},
			})

			print("✅ Servidores LSP para Web configurados")
		end,
	},

	-- ========== SERVIDOR WEB LIVE ==========
	{
		"turbio/bracey.vim",
		build = "npm install --prefix server",
		cmd = { "Bracey", "BraceyStop", "BraceyReload", "BraceyEval" },
		config = function()
			-- Configuración de Bracey
			vim.g.bracey_browser_command = "firefox" -- Cambia por tu navegador preferido
			vim.g.bracey_auto_start_browser = 1
			vim.g.bracey_refresh_on_save = 1
			vim.g.bracey_eval_on_save = 1
			vim.g.bracey_auto_start_server = 0

			-- Mapeos para Bracey
			vim.keymap.set("n", "<leader>bs", ":Bracey<CR>", { desc = "🌐 Iniciar servidor web" })
			vim.keymap.set("n", "<leader>be", ":BraceyStop<CR>", { desc = "⏹️ Parar servidor web" })
			vim.keymap.set("n", "<leader>br", ":BraceyReload<CR>", { desc = "🔄 Recargar página" })
		end,
	},

	-- ========== TREESITTER PARA WEB ==========
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"html",
				"css",
				"scss",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"vue",
				"svelte",
			})
		end,
	},

	-- ========== AUTOCOMPLETADO MEJORADO ==========
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "emmet_ls" }, -- Añadir emmet como fuente
				{ name = "codeium" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			})
		end,
	},

	-- ========== FORMATO Y LINTING ==========
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				less = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				vue = { "prettier" },
				svelte = { "prettier" },
			},
		},
	},

	-- ========== SNIPPETS PARA WEB ==========
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local luasnip = require("luasnip")

			-- Cargar snippets específicos para web development
			require("luasnip.loaders.from_vscode").lazy_load({
				include = { "html", "css", "javascript", "typescript" },
			})

			-- Snippet personalizado para HTML5 boilerplate
			luasnip.add_snippets("html", {
				luasnip.snippet("html5", {
					luasnip.text_node({
						"<!DOCTYPE html>",
						'<html lang="es">',
						"<head>",
						'    <meta charset="UTF-8">',
						'    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
						"    <title>",
					}),
					luasnip.insert_node(1, "Document"),
					luasnip.text_node({
						"</title>",
						'    <link rel="stylesheet" href="style.css">',
						"</head>",
						"<body>",
						"    ",
					}),
					luasnip.insert_node(2, "<!-- Contenido aquí -->"),
					luasnip.text_node({
						"",
						'    <script src="script.js"></script>',
						"</body>",
						"</html>",
					}),
				}),
			})

			-- Snippet para CSS flexbox
			luasnip.add_snippets("css", {
				luasnip.snippet("flexcenter", {
					luasnip.text_node({
						"display: flex;",
						"justify-content: center;",
						"align-items: center;",
					}),
				}),
				luasnip.snippet("grid", {
					luasnip.text_node({
						"display: grid;",
						"grid-template-columns: ",
					}),
					luasnip.insert_node(1, "repeat(auto-fit, minmax(250px, 1fr))"),
					luasnip.text_node({
						";",
						"gap: ",
					}),
					luasnip.insert_node(2, "1rem"),
					luasnip.text_node(";"),
				}),
			})
		end,
	},

	-- ========== EMMET PARA AUTOCOMPLETADO RÁPIDO ==========
	{
		"mattn/emmet-vim",
		ft = { "html", "css", "javascript", "typescript", "vue", "svelte" },
		config = function()
			-- Configurar Emmet
			vim.g.user_emmet_leader_key = "<C-Z>"
			vim.g.user_emmet_install_global = 0

			-- Auto-comandos para habilitar Emmet solo en archivos web
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "html", "css", "javascript", "typescript", "vue", "svelte" },
				callback = function()
					vim.cmd("EmmetInstall")
				end,
			})
		end,
	},

	-- ========== COLORIZER PARA VER COLORES ==========
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"css",
				"scss",
				"html",
				"javascript",
				"typescript",
			}, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" codes like Blue
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},

	-- ========== NAVEGACIÓN RÁPIDA EN HTML ==========
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = false, -- Auto close on trailing </
				},
				per_filetype = {
					["html"] = {
						enable_close = true,
					},
				},
			})
		end,
	},

	-- ========== ICONOS PARA ARCHIVOS WEB ==========
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({
				override = {
					html = {
						icon = "",
						color = "#e34c26",
						name = "Html",
					},
					css = {
						icon = "",
						color = "#1572b6",
						name = "Css",
					},
					scss = {
						icon = "",
						color = "#cf649a",
						name = "Scss",
					},
					js = {
						icon = "",
						color = "#f1e05a",
						name = "JavaScript",
					},
					ts = {
						icon = "",
						color = "#3178c6",
						name = "TypeScript",
					},
				},
			})
		end,
	},
}
