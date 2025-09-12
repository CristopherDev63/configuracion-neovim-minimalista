-- lua/plugins/css-enhanced.lua
-- Configuración mejorada para CSS con detección de sintaxis y autocompletado completo

return {
	-- ========== LSP MEJORADO PARA CSS ==========
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Función on_attach específica para CSS
			local function css_on_attach(client, bufnr)
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Mapeos específicos para CSS
				local opts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)

				-- Mapeos específicos CSS
				vim.keymap.set("n", "<leader>cc", function()
					-- Completar propiedades CSS
					vim.lsp.buf.completion()
				end, { desc = "CSS: Completar propiedades", buffer = bufnr })

				print("🎨 LSP CSS activado con autocompletado mejorado")
			end

			-- Configurar CSS Language Server con configuración extendida
			lspconfig.cssls.setup({
				capabilities = capabilities,
				on_attach = css_on_attach,
				settings = {
					css = {
						validate = true,
						lint = {
							-- Validaciones CSS mejoradas
							compatibleVendorPrefixes = "warning",
							vendorPrefix = "warning",
							duplicateProperties = "warning",
							emptyRuleSet = "warning",
							importStatement = "warning",
							boxModel = "warning",
							universalSelector = "warning",
							zeroUnits = "warning",
							fontFaceProperties = "warning",
							hexColorLength = "warning",
							argumentsInColorFunction = "warning",
							unknownProperties = "warning",
							ieHack = "warning",
							unknownVendorSpecificProperties = "ignore",
							propertyIgnoredDueToDisplay = "warning",
							important = "ignore",
							float = "ignore",
							idSelector = "ignore",
						},
						completion = {
							triggerPropertyValueCompletion = true,
							completePropertyWithSemicolon = true,
						},
						hover = {
							documentation = true,
							references = true,
						},
					},
					scss = {
						validate = true,
						lint = {
							compatibleVendorPrefixes = "warning",
							vendorPrefix = "warning",
							duplicateProperties = "warning",
							emptyRuleSet = "warning",
							importStatement = "warning",
							boxModel = "warning",
							universalSelector = "warning",
							zeroUnits = "warning",
							fontFaceProperties = "warning",
							hexColorLength = "warning",
							argumentsInColorFunction = "warning",
							unknownProperties = "warning",
							ieHack = "warning",
							unknownVendorSpecificProperties = "ignore",
							propertyIgnoredDueToDisplay = "warning",
							important = "ignore",
							float = "ignore",
							idSelector = "ignore",
						},
						completion = {
							triggerPropertyValueCompletion = true,
							completePropertyWithSemicolon = true,
						},
					},
					less = {
						validate = true,
						lint = {
							compatibleVendorPrefixes = "warning",
							vendorPrefix = "warning",
							duplicateProperties = "warning",
							emptyRuleSet = "warning",
							importStatement = "warning",
							boxModel = "warning",
							universalSelector = "warning",
							zeroUnits = "warning",
							fontFaceProperties = "warning",
							hexColorLength = "warning",
							argumentsInColorFunction = "warning",
							unknownProperties = "warning",
							ieHack = "warning",
							unknownVendorSpecificProperties = "ignore",
							propertyIgnoredDueToDisplay = "warning",
							important = "ignore",
							float = "ignore",
							idSelector = "ignore",
						},
					},
				},
				filetypes = { "css", "scss", "less" },
			})
		end,
	},

	-- ========== TREESITTER MEJORADO PARA CSS ==========
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, {
				"css",
				"scss",
				"sass",
			})

			-- Configuración específica para CSS
			opts.highlight = opts.highlight or {}
			opts.highlight.enable = true
			opts.highlight.additional_vim_regex_highlighting = { "css", "scss" }

			-- Mejorar indentación para CSS
			opts.indent = opts.indent or {}
			opts.indent.enable = true

			return opts
		end,
	},

	-- ========== AUTOCOMPLETADO MEJORADO PARA CSS ==========
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			cmp.setup({
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 }, -- Prioridad alta para LSP
					{ name = "buffer", priority = 500 },
					{ name = "path", priority = 250 },
				}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
						menu = {
							nvim_lsp = "[CSS-LSP]",
							buffer = "[Buffer]",
							path = "[Path]",
						},
					}),
				},
				-- Configuración específica para archivos CSS
				window = {
					completion = {
						border = "rounded",
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
					},
					documentation = {
						border = "rounded",
					},
				},
			})

			-- Configuración específica para archivos CSS
			cmp.setup.filetype("css", {
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer", keyword_length = 2 },
					{ name = "path" },
				}),
			})

			cmp.setup.filetype("scss", {
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer", keyword_length = 2 },
					{ name = "path" },
				}),
			})
		end,
	},

	-- ========== SNIPPETS ESPECÍFICOS PARA CSS ==========
	{
		"L3MON4D3/LuaSnip",
		config = function()
			local luasnip = require("luasnip")
			local s = luasnip.snippet
			local t = luasnip.text_node
			local i = luasnip.insert_node

			-- Snippets específicos para CSS
			luasnip.add_snippets("css", {
				-- Flexbox snippets
				s("flex", {
					t("display: flex;"),
				}),
				s("flexcenter", {
					t({
						"display: flex;",
						"justify-content: center;",
						"align-items: center;",
					}),
				}),
				s("flexcol", {
					t({
						"display: flex;",
						"flex-direction: column;",
					}),
				}),

				-- Grid snippets
				s("grid", {
					t("display: grid;"),
				}),
				s("gridcols", {
					t("grid-template-columns: "),
					i(1, "repeat(auto-fit, minmax(250px, 1fr))"),
					t(";"),
				}),
				s("gridrows", {
					t("grid-template-rows: "),
					i(1, "repeat(3, 1fr)"),
					t(";"),
				}),
				s("gridgap", {
					t("gap: "),
					i(1, "1rem"),
					t(";"),
				}),

				-- Layout snippets
				s("container", {
					t({
						"max-width: ",
					}),
					i(1, "1200px"),
					t({
						";",
						"margin: 0 auto;",
						"padding: 0 ",
					}),
					i(2, "1rem"),
					t(";"),
				}),

				-- Animation snippets
				s("transition", {
					t("transition: "),
					i(1, "all 0.3s ease"),
					t(";"),
				}),
				s("transform", {
					t("transform: "),
					i(1, "translateX(0)"),
					t(";"),
				}),

				-- Media queries
				s("media", {
					t("@media (max-width: "),
					i(1, "768px"),
					t({
						") {",
						"    ",
					}),
					i(2, "/* styles */"),
					t({
						"",
						"}",
					}),
				}),
				s("mediamin", {
					t("@media (min-width: "),
					i(1, "769px"),
					t({
						") {",
						"    ",
					}),
					i(2, "/* styles */"),
					t({
						"",
						"}",
					}),
				}),

				-- CSS Reset/Normalize
				s("reset", {
					t({
						"* {",
						"    margin: 0;",
						"    padding: 0;",
						"    box-sizing: border-box;",
						"}",
					}),
				}),

				-- Common patterns
				s("shadow", {
					t("box-shadow: "),
					i(1, "0 4px 6px rgba(0, 0, 0, 0.1)"),
					t(";"),
				}),
				s("border", {
					t("border: "),
					i(1, "1px solid #e1e1e1"),
					t(";"),
				}),
				s("bg", {
					t("background: "),
					i(1, "#ffffff"),
					t(";"),
				}),
			})

			-- Snippets para SCSS
			luasnip.add_snippets("scss", {
				s("mixin", {
					t("@mixin "),
					i(1, "mixin-name"),
					t({
						" {",
						"    ",
					}),
					i(2, "/* mixin content */"),
					t({
						"",
						"}",
					}),
				}),
				s("include", {
					t("@include "),
					i(1, "mixin-name"),
					t(";"),
				}),
				s("var", {
					t("$"),
					i(1, "variable"),
					t(": "),
					i(2, "value"),
					t(";"),
				}),
			})
		end,
	},

	-- ========== COLORIZER MEJORADO ==========
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"css",
				"scss",
				"sass",
				"html",
				"javascript",
				"typescript",
			}, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" codes like Blue orcss red
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				AARRGGBB = false, -- 0xAARRGGBB hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
				-- Available modes for `mode`: foreground, background, virtualtext
				mode = "background", -- Set the display mode
				virtualtext = "■",
			})

			-- Comando para toggle colorizer
			vim.api.nvim_create_user_command("ColorizerToggle", function()
				vim.cmd("ColorizerToggle")
			end, { desc = "Toggle colorizer" })
		end,
	},

	-- ========== FORMATEO MEJORADO PARA CSS ==========
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					css = { "prettier" },
					scss = { "prettier" },
					sass = { "prettier" },
					less = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})

			-- Atajo específico para formatear CSS
			vim.keymap.set("n", "<leader>fc", function()
				require("conform").format({ async = true })
			end, { desc = "🎨 Formatear CSS" })
		end,
	},

	-- ========== AUTOCOMANDOS ESPECÍFICOS PARA CSS ==========
	{
		"nvim-lua/plenary.nvim", -- Dependencia para autocomandos
		config = function()
			-- Configuración específica para archivos CSS
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "css", "scss", "sass", "less" },
				callback = function()
					-- Configuración de indentación para CSS
					vim.opt_local.tabstop = 2
					vim.opt_local.shiftwidth = 2
					vim.opt_local.expandtab = true
					vim.opt_local.softtabstop = 2

					-- Mapeos específicos para CSS
					vim.keymap.set("n", "<leader>cv", function()
						-- Crear variable CSS
						local var_name = vim.fn.input("Nombre de variable: ")
						local var_value = vim.fn.input("Valor: ")
						if var_name ~= "" and var_value ~= "" then
							vim.api.nvim_put({ "--" .. var_name .. ": " .. var_value .. ";" }, "l", true, true)
						end
					end, { buffer = true, desc = "Crear variable CSS" })

					vim.keymap.set("n", "<leader>cm", function()
						-- Crear media query
						local breakpoint = vim.fn.input("Breakpoint (ej: 768px): ")
						if breakpoint ~= "" then
							local media_query = {
								"@media (max-width: " .. breakpoint .. ") {",
								"    ",
								"}",
							}
							vim.api.nvim_put(media_query, "l", true, true)
							-- Mover cursor dentro del media query
							vim.api.nvim_win_set_cursor(0, { vim.fn.line(".") + 1, 4 })
						end
					end, { buffer = true, desc = "Crear media query" })

					vim.keymap.set("n", "<leader>cs", function()
						-- Crear selector CSS
						local selector = vim.fn.input("Selector CSS: ")
						if selector ~= "" then
							local css_block = {
								selector .. " {",
								"    ",
								"}",
							}
							vim.api.nvim_put(css_block, "l", true, true)
							-- Mover cursor dentro del selector
							vim.api.nvim_win_set_cursor(0, { vim.fn.line(".") + 1, 4 })
						end
					end, { buffer = true, desc = "Crear selector CSS" })

					-- Activar colorizer automáticamente
					vim.cmd("ColorizerAttachToBuffer")

					print("🎨 CSS mejorado cargado - Usa <leader>cv, <leader>cm, <leader>cs para helpers")
				end,
			})

			-- Autocompletado mejorado en modo inserción
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "css", "scss" },
				callback = function()
					-- Mapeos para autocompletado rápido en modo inserción
					vim.keymap.set("i", ";;", function()
						return ": ;<Left>"
					end, { expr = true, buffer = true, desc = "CSS: Autocompletar propiedad" })

					vim.keymap.set("i", "{{", function()
						return " {<CR>}<Up><End>"
					end, { expr = true, buffer = true, desc = "CSS: Autocompletar bloque" })
				end,
			})

			-- Comando de ayuda para CSS
			vim.api.nvim_create_user_command("CSSHelp", function()
				local help_text = [[
🎨 CSS MEJORADO - COMANDOS DISPONIBLES:

📋 ATAJOS DE TECLADO:
  <leader>cv  - Crear variable CSS
  <leader>cm  - Crear media query
  <leader>cs  - Crear selector CSS
  <leader>fc  - Formatear archivo CSS
  K          - Mostrar documentación de propiedad
  gd         - Ir a definición

✨ EN MODO INSERCIÓN:
  ;;         - Autocompletar ": ;"
  {{         - Autocompletar bloque "{ }"

🔧 SNIPPETS DISPONIBLES:
  flex       - display: flex;
  flexcenter - Flex centrado
  grid       - display: grid;
  media      - Media query
  reset      - CSS reset básico
  shadow     - Box shadow
  transition - Transición

🌈 COLORES:
  Los colores se muestran automáticamente
  :ColorizerToggle - Activar/desactivar

💡 LSP CSS ACTIVO:
  ✓ Autocompletado inteligente
  ✓ Validación de sintaxis
  ✓ Documentación en hover
  ✓ Detección de errores
]]

				-- Mostrar en buffer temporal
				local buf = vim.api.nvim_create_buf(false, true)
				local lines = vim.split(help_text, "\n")
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
				vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
				vim.cmd("split")
				vim.api.nvim_win_set_buf(0, buf)
			end, { desc = "Mostrar ayuda de CSS" })

			print("✅ CSS Enhanced cargado. Usa :CSSHelp para ver todos los comandos")
		end,
	},
}
