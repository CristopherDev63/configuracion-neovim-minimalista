-- lua/plugins/gemini-cmp-ai-fixed.lua
-- Configuración CORREGIDA de Gemini con cmp-ai

return {
	-- Plugin cmp-ai para integración con IA
	{
		"tzachar/cmp-ai",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			local cmp_ai = require("cmp_ai.config")

			cmp_ai:setup({
				max_lines = 100,
				provider = "OpenAI", -- Usar OpenAI como base pero con endpoint de Gemini
				provider_options = {
					-- Configuración para usar Gemini con protocolo OpenAI-compatible
					model = "gemini-pro",
					api_key = vim.env.GEMINI_API_KEY,
					-- Usar un endpoint personalizado para Gemini
					base_url = "https://generativelanguage.googleapis.com/v1beta",
				},
				notify = true,
				notify_callback = function(msg)
					print("🤖 Gemini: " .. msg)
				end,
				run_on_every_keystroke = false,
				ignored_file_types = {
					help = true,
					gitcommit = true,
					gitrebase = true,
					hgcommit = true,
					svn = true,
					cvs = true,
					["."] = true,
				},
			})

			print("✅ CMP-AI configurado correctamente para Gemini")
		end,
	},

	-- Actualizar nvim-cmp para incluir cmp-ai
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
			"tzachar/cmp-ai",
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
							luasnip = "[Snippet]",
							nvim_lua = "[Lua]",
							path = "[Path]",
							cmp_ai = "[🤖 AI]", -- Simplificado
						},
						before = function(entry, vim_item)
							-- Agregar icono especial para IA
							if entry.source.name == "cmp_ai" then
								vim_item.kind = "🤖 AI"
								vim_item.menu = "[Gemini]"
							end
							return vim_item
						end,
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
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

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					-- Ctrl+G para forzar sugerencias de IA
					["<C-g>"] = cmp.mapping(function()
						cmp.complete({
							config = {
								sources = {
									{ name = "cmp_ai" },
								},
							},
						})
					end, { "i" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp", priority = 1000 },
					{
						name = "cmp_ai",
						priority = 800,
						-- Configuración específica para el source
						max_item_count = 5, -- Limitar sugerencias de IA
						keyword_length = 3, -- Activar solo después de 3 caracteres
					},
					{ name = "luasnip", priority = 500 },
					{ name = "buffer", priority = 250 },
					{ name = "path", priority = 250 },
				}),
			})

			-- Configuración específica para Python (máxima prioridad a IA)
			cmp.setup.filetype("python", {
				sources = cmp.config.sources({
					{
						name = "cmp_ai",
						priority = 1000,
						max_item_count = 8,
						keyword_length = 2,
					},
					{ name = "nvim_lsp", priority = 800 },
					{ name = "luasnip", priority = 500 },
					{ name = "buffer", priority = 250 },
				}),
			})

			print("✅ CMP actualizado con soporte mejorado para IA")
		end,
	},

	-- Comandos y utilidades mejoradas
	{
		"nvim-lua/plenary.nvim",
		config = function()
			-- ========== COMANDOS PERSONALIZADOS MEJORADOS ==========

			vim.api.nvim_create_user_command("GeminiStatus", function()
				local api_key = vim.env.GEMINI_API_KEY
				local status = api_key and "✅ Configurada" or "❌ No configurada"

				print("🤖 ESTADO DE GEMINI:")
				print("🔑 API Key: " .. status)
				if api_key then
					print("📏 Longitud: " .. #api_key .. " caracteres")
				else
					print("💡 Configura con: export GEMINI_API_KEY='tu_key'")
				end

				-- Verificar cmp-ai
				local ok, cmp_ai = pcall(require, "cmp_ai.config")
				if ok then
					print("✅ CMP-AI cargado correctamente")
				else
					print("❌ CMP-AI no encontrado")
				end

				-- Verificar si cmp tiene el source
				local cmp_ok, cmp = pcall(require, "cmp")
				if cmp_ok then
					local sources = cmp.get_config().sources
					local has_ai = false
					for _, source_group in ipairs(sources) do
						for _, source in ipairs(source_group) do
							if source.name == "cmp_ai" then
								has_ai = true
								break
							end
						end
					end
					print(has_ai and "✅ Source cmp_ai registrado" or "❌ Source cmp_ai no encontrado")
				end
			end, { desc = "Verificar estado completo de Gemini" })

			vim.api.nvim_create_user_command("GeminiToggle", function()
				local cmp = require("cmp")
				local config = cmp.get_config()

				-- Buscar si cmp_ai está en las fuentes
				local ai_enabled = false
				for _, source_group in ipairs(config.sources) do
					for i, source in ipairs(source_group) do
						if source.name == "cmp_ai" then
							ai_enabled = true
							-- Remover temporalmente
							table.remove(source_group, i)
							print("❌ Gemini IA desactivado")
							cmp.setup(config)
							return
						end
					end
				end

				-- Si no está, agregarlo
				if not ai_enabled then
					table.insert(config.sources[1], 2, {
						name = "cmp_ai",
						priority = 800,
						max_item_count = 5,
					})
					print("✅ Gemini IA activado")
					cmp.setup(config)
				end
			end, { desc = "Activar/Desactivar Gemini IA" })

			vim.api.nvim_create_user_command("GeminiTest", function()
				print("🧪 Probando Gemini con cmp-ai...")

				-- Verificar API key
				if not vim.env.GEMINI_API_KEY then
					print("❌ API key no configurada")
					return
				end

				-- Intentar activar completado de IA
				local cmp = require("cmp")
				cmp.complete({
					config = {
						sources = { { name = "cmp_ai" } },
					},
				})

				print("✅ Test iniciado - escribe algo y verás sugerencias de IA")
			end, { desc = "Probar Gemini IA" })

			vim.api.nvim_create_user_command("GeminiHelp", function()
				print([[
🤖 GEMINI CON CMP-AI - GUÍA ACTUALIZADA:

📋 COMANDOS:
  :GeminiStatus    - Estado completo
  :GeminiTest      - Probar IA
  :GeminiToggle    - Activar/Desactivar
  :GeminiHelp      - Esta ayuda

⌨️ CONTROLES:
  Ctrl+Space       - Autocompletado normal
  Ctrl+G           - SOLO sugerencias de IA
  Tab/Shift+Tab    - Navegar opciones
  Enter            - Aceptar
  Ctrl+E           - Cancelar

🎯 USO:
  1. Escribe código (al menos 3 chars)
  2. Ctrl+Space para ver todas las opciones
  3. Busca las marcadas con 🤖 AI [Gemini]
  4. O usa Ctrl+G para SOLO IA

🔧 SOLUCIÓN DE PROBLEMAS:
  - Si no aparecen sugerencias: :GeminiStatus
  - Si "Bad provider": Ya está corregido
  - API key: export GEMINI_API_KEY='tu_key'
]])
			end, { desc = "Ayuda completa de Gemini" })

			-- Mapeos mejorados
			vim.keymap.set("n", "<leader>ga", ":GeminiStatus<CR>", {
				desc = "🤖 Estado de Gemini",
			})

			vim.keymap.set("n", "<leader>gt", ":GeminiTest<CR>", {
				desc = "🧪 Probar Gemini",
			})

			print("✅ Comandos de Gemini mejorados listos")
		end,
	},
}
