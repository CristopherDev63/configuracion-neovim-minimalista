-- lua/plugins/claude-ai.lua - Integración de Claude AI

return {
	-- ========== OPCIÓN 1: CLAUDE.NVIM (MÁS DIRECTO) ==========
	{
		"ribelo/claude.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("claude").setup({
				-- Tu API key de Anthropic
				api_key = vim.env.ANTHROPIC_API_KEY, -- Pon tu API key en variable de entorno
				model = "claude-3-5-sonnet-20241022", -- Modelo más reciente
				max_tokens = 4096,

				-- Configuración de UI
				ui = {
					border = "rounded",
					title = "Claude AI",
					width = 0.8,
					height = 0.8,
				},
			})

			-- Mapeos para Claude
			vim.keymap.set("n", "<leader>cc", ":Claude<CR>", { desc = "🤖 Abrir Claude Chat" })
			vim.keymap.set("v", "<leader>ce", ":ClaudeExplain<CR>", { desc = "🔍 Explicar código con Claude" })
			vim.keymap.set("n", "<leader>cr", ":ClaudeRewrite<CR>", { desc = "✨ Reescribir con Claude" })
		end,
	},

	-- ========== OPCIÓN 2: AVANTE.NVIM (COMO CURSOR AI) ==========
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false,
		opts = {
			provider = "claude",
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-3-5-sonnet-20241022",
				temperature = 0,
				max_tokens = 4096,
			},
			behaviour = {
				auto_suggestions = true, -- Sugerencias automáticas
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = false,
			},
			mappings = {
				ask = "<leader>aa",
				edit = "<leader>ae",
				refresh = "<leader>ar",
				diff = {
					ours = "co",
					theirs = "ct",
					all_theirs = "ca",
					both = "cb",
					cursor = "cc",
					next = "]x",
					prev = "[x",
				},
				suggestion = {
					accept = "<M-l>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			hints = { enabled = true },
			windows = {
				position = "right",
				wrap = true,
				width = 30,
				sidebar_header = {
					align = "center",
					rounded = true,
				},
			},
			highlights = {
				diff = {
					current = "DiffText",
					incoming = "DiffAdd",
				},
			},
		},
		build = "make",
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			"zbirenbaum/copilot.lua",
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						use_absolute_path = true,
					},
				},
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

	-- ========== OPCIÓN 3: CMP INTEGRATION ==========
	{
		"tzachar/cmp-ai",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			local cmp_ai = require("cmp_ai.config")

			cmp_ai:setup({
				max_lines = 1000,
				provider = "Anthropic",
				provider_options = {
					model = "claude-3-5-sonnet-20241022",
				},
				notify = true,
				notify_callback = function(msg)
					vim.notify(msg)
				end,
				run_on_every_keystroke = false,
				ignored_file_types = {},
			})
		end,
	},

	-- ========== OPCIÓN 4: NEURAL (UNIVERSAL AI) ==========
	{
		"dense-analysis/neural",
		config = function()
			require("neural").setup({
				source = {
					anthropic = {
						api_key = vim.env.ANTHROPIC_API_KEY,
						model = "claude-3-5-sonnet-20241022",
					},
				},
				ui = {
					use_prompt = true,
					prompt_icon = "🤖",
				},
			})

			-- Mapeos para Neural
			vim.keymap.set("n", "<leader>nn", ":Neural<CR>", { desc = "🧠 Neural AI" })
			vim.keymap.set("v", "<leader>ne", ":NeuralExplain<CR>", { desc = "🔍 Explicar con Neural" })
		end,
	},
}
