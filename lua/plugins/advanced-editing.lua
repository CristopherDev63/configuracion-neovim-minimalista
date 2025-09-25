-- Edición Avanzada: Folding, Indentation, Bracket Matching, etc.
return {
	-- FOLDING AVANZADO - Colapsar/expandir bloques mejorado
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufReadPost",
		opts = {
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
			open_fold_hl_timeout = 150,
			close_fold_kinds_for_ft = {
				default = { "imports", "comment" },
				json = { "array" },
				c = { "comment", "region" },
			},
			preview = {
				win_config = {
					border = { "", "─", "", "", "", "─", "", "" },
					winhighlight = "Normal:Folded",
					winblend = 0,
				},
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
					jumpTop = "[",
					jumpBot = "]",
				},
			},
		},
		config = function(_, opts)
			require("ufo").setup(opts)

			-- Configuración de folding manual
			vim.o.foldcolumn = "1"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = false

			-- Keymaps para folding manual
			vim.keymap.set("n", "<leader>fe", function() vim.o.foldenable = not vim.o.foldenable end, { desc = "Toggle folding on/off" })
			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds" })
			vim.keymap.set("n", "zm", require("ufo").closeFoldsWith, { desc = "Close folds with" })
			vim.keymap.set("n", "K", function()
				local winid = require("ufo").peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end, { desc = "Peek Fold or Hover" })
		end,
	},

	-- INDENTATION GUIDES - Líneas visuales de indentación
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "BufReadPost",
		main = "ibl",
		opts = {
			indent = {
				char = "│",
				tab_char = "│",
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
				injected_languages = false,
				highlight = { "Function", "Label" },
				priority = 500,
			},
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
		config = function(_, opts)
			require("ibl").setup(opts)

			-- Colores personalizados
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3a3a3a" })
				vim.api.nvim_set_hl(0, "IblScope", { fg = "#569cd6" })
			end)
		end,
	},

	-- BRACKET MATCHING AVANZADO - Resaltado de paréntesis/llaves mejorado
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
			vim.g.matchup_matchparen_deferred = 1
			vim.g.matchup_matchparen_hi_surround_always = 1
			vim.g.matchup_delim_start_plaintext = 0
			vim.g.matchup_transmute_enabled = 0

			-- Integración con treesitter
			require("nvim-treesitter.configs").setup({
				matchup = {
					enable = true,
					disable_virtual_text = false,
				},
			})
		end,
	},

	-- COLORIZER - Previsualizar colores en CSS/HTML
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufReadPost",
		opts = {
			filetypes = { "*" },
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = true,
				RRGGBBAA = false,
				AARRGGBB = true,
				rgb_fn = false,
				hsl_fn = false,
				css = false,
				css_fn = false,
				mode = "background",
				tailwind = false,
				sass = { enable = false, parsers = { "css" } },
				virtualtext = "■",
				always_update = false,
			},
			buftypes = {},
		},
		config = function(_, opts)
			require("colorizer").setup(opts)

			-- Keymaps
			vim.keymap.set("n", "<leader>ct", "<cmd>ColorizerToggle<cr>", { desc = "Toggle Colorizer" })
			vim.keymap.set("n", "<leader>cr", "<cmd>ColorizerReloadAllBuffers<cr>", { desc = "Reload Colorizer" })
		end,
	},

	-- TODO COMMENTS - Resaltar TODO, FIXME, etc.
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufReadPost",
		opts = {
			signs = true,
			sign_priority = 8,
			keywords = {
				FIX = {
					icon = " ",
					color = "error",
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
				},
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
			},
			gui_style = {
				fg = "NONE",
				bg = "BOLD",
			},
			merge_keywords = true,
			highlight = {
				multiline = true,
				multiline_pattern = "^.",
				multiline_context = 10,
				before = "",
				keyword = "wide",
				after = "fg",
				pattern = [[.*<(KEYWORDS)\s*:]],
				comments_only = true,
				max_line_len = 400,
				exclude = {},
			},
			colors = {
				error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
				warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
				info = { "DiagnosticInfo", "#2563EB" },
				hint = { "DiagnosticHint", "#10B981" },
				default = { "Identifier", "#7C3AED" },
				test = { "Identifier", "#FF006E" },
			},
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
				pattern = [[\b(KEYWORDS):]],
			},
		},
		keys = {
			{ "<leader>td", "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
			{ "<leader>tq", "<cmd>TodoQuickFix<cr>", desc = "TODO QuickFix" },
			{ "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
			{ "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO" },
		},
	},

	-- WORD WRAP VISUAL - Indicador visual de líneas largas
	{
		"m4xshen/smartcolumn.nvim",
		event = "BufReadPost",
		opts = {
			colorcolumn = "100",
			disabled_filetypes = { "help", "text", "markdown", "NvimTree", "lazy" },
			custom_colorcolumn = {},
			scope = "file",
		},
	},

	-- HIGHLIGHT CURRENT WORD - Resaltar palabra bajo cursor
	{
		"RRethy/vim-illuminate",
		event = "BufReadPost",
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
			filetypes_denylist = {
				"dirvish",
				"fugitive",
				"alpha",
				"NvimTree",
				"lazy",
				"neogitstatus",
				"Trouble",
				"lir",
				"Outline",
				"spectre_panel",
				"toggleterm",
				"DressingSelect",
				"TelescopePrompt",
			},
			filetypes_allowlist = {},
			modes_denylist = {},
			modes_allowlist = {},
			providers_regex_syntax_denylist = {},
			providers_regex_syntax_allowlist = {},
			under_cursor = true,
			max_file_lines = nil,
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			-- Keymaps
			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- Auto-commands para configurar keymaps por buffer
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
	},

	-- COLUMN SELECTION - Selección rectangular
	{
		"kana/vim-textobj-entire",
		dependencies = "kana/vim-textobj-user",
		keys = {
			{ "ae", desc = "Select entire buffer" },
			{ "ie", desc = "Select entire buffer (inner)" },
		},
	},
}