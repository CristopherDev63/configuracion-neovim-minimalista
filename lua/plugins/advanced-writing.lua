-- Funciones de Escritura Avanzada: Multi-cursor, Quick Fix, Code Actions, etc.
return {
	-- CODE ACTIONS & QUICK FIX - Acciones de código inteligentes
	{
		"weilbith/nvim-code-action-menu",
		cmd = "CodeActionMenu",
		keys = {
			{ "<leader>ca", "<cmd>CodeActionMenu<cr>", desc = "Code Action Menu" },
		},
		config = function()
			vim.g.code_action_menu_window_border = "single"
			vim.g.code_action_menu_show_details = true
			vim.g.code_action_menu_show_diff = true
		end,
	},

	-- TROUBLE - Panel de diagnósticos y quickfix mejorado
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			position = "bottom",
			height = 10,
			width = 50,
			icons = true,
			mode = "workspace_diagnostics",
			severity = nil,
			fold_open = "",
			fold_closed = "",
			group = true,
			padding = true,
			cycle_results = true,
			action_keys = {
				close = "q",
				cancel = "<esc>",
				refresh = "r",
				jump = { "<cr>", "<tab>" },
				open_split = { "<c-x>" },
				open_vsplit = { "<c-s-v>" },
				open_tab = { "<c-t>" },
				jump_close = { "o" },
				toggle_mode = "m",
				switch_severity = "s",
				toggle_preview = "P",
				hover = "K",
				preview = "p",
				close_folds = { "zM", "zm" },
				open_folds = { "zR", "zr" },
				toggle_fold = { "zA", "za" },
				previous = "k",
				next = "j",
			},
			multiline = true,
			indent_lines = true,
			win_config = { border = "single" },
			auto_open = false,
			auto_close = false,
			auto_preview = true,
			auto_fold = false,
			auto_jump = { "lsp_definitions" },
			signs = {
				error = "",
				warning = "",
				hint = "",
				information = "",
				other = "",
			},
			use_diagnostic_signs = false,
		},
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
			{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
			{ "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
			{ "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix" },
			{ "<leader>xl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List" },
			{ "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "LSP References" },
		},
	},



	-- AUTO-PAIRS - Cierre automático de paréntesis, llaves, etc.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = false,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
			disable_filetype = { "TelescopePrompt", "spectre_panel" },
			fast_wrap = {
				map = "<M-e>",
				chars = { "{", "[", "(", '"', "'" },
				pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
				offset = 0,
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "PmenuSel",
				highlight_grey = "LineNr",
			},
		},
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
		end,
	},

	-- SURROUND - Agregar/quitar comillas, paréntesis, etc.
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	-- COMMENT - Comentarios inteligentes
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "gcc", desc = "Comment toggle current line" },
			{ "gc", desc = "Comment toggle linewise", mode = { "n", "o" } },
			{ "gc", desc = "Comment toggle linewise", mode = "x" },
			{ "gbc", desc = "Comment toggle current block" },
			{ "gb", desc = "Comment toggle blockwise", mode = { "n", "o" } },
			{ "gb", desc = "Comment toggle blockwise", mode = "x" },
		},
		opts = {
			padding = true,
			sticky = true,
			ignore = nil,
			toggler = {
				line = "gcc",
				block = "gbc",
			},
			opleader = {
				line = "gc",
				block = "gb",
			},
			extra = {
				above = "gcO",
				below = "gco",
				eol = "gcA",
			},
			mappings = {
				basic = true,
				extra = true,
			},
			pre_hook = nil,
			post_hook = nil,
		},
	},

	-- EMMET - Expansión HTML/CSS rápida
	{
		"mattn/emmet-vim",
		ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
		config = function()
			vim.g.user_emmet_leader_key = "<C-e>"
			vim.g.user_emmet_install_global = 0
			vim.g.user_emmet_settings = {
				javascript = {
					extends = "jsx",
				},
				typescript = {
					extends = "tsx",
				},
			}
		end,
	},
}