-- lua/plugins/advanced-editing.lua
-- Edición Avanzada: Folding, Indentation, Bracket Matching, etc.
return {

	-- INDENTATION GUIDES - Líneas visuales de indentación
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
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
	-- DESACTIVADO: Causaba input lag severo (2.5s en callbacks)
	-- {
	-- 	"andymass/vim-matchup",
	-- 	event = "BufReadPost",
	-- 	config = function()
	-- 		vim.g.matchup_matchparen_offscreen = { method = "popup" }
	-- 		vim.g.matchup_matchparen_deferred = 1
	-- 		vim.g.matchup_matchparen_hi_surround_always = 1
	-- 		vim.g.matchup_delim_start_plaintext = 0
	-- 		vim.g.matchup_transmute_enabled = 0

	-- 		-- Integración con treesitter
	-- 		require("nvim-treesitter.configs").setup({
	-- 			matchup = {
	-- 				enable = true,
	-- 				disable_virtual_text = false,
	-- 			},
	-- 		})
	-- 	end,
	-- },

	-- COLORIZER - Previsualizar colores en CSS/HTML (solo en archivos relevantes)
	{
		"NvChad/nvim-colorizer.lua",
		ft = { "css", "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "sass", "scss", "less" },
		opts = {
			filetypes = { "css", "html", "javascript", "typescript", "sass", "scss", "less" },
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

	-- WORD WRAP VISUAL - Indicador visual de líneas largas
	{
		"m4xshen/smartcolumn.nvim",
		event = "BufReadPost",
		enabled = false,
		opts = {
			disabled_filetypes = { "help", "text", "markdown", "NvimTree", "lazy" },
			custom_colorcolumn = {},
			scope = "file",
		},
	},

	-- HIGHLIGHT CURRENT WORD - Resaltar palabra bajo cursor (solo al hacer pausa)
	{
		"RRethy/vim-illuminate",
		event = "CursorHold",
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

	-- GODOT/GDSCRIPT - Mejoras para Godot
	{
		"habamax/vim-godot",
		ft = "gdscript", -- Cargar solo para archivos de GDScript
	},
}
