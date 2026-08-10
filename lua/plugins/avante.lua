return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		build = "make",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope.nvim", -- selector de archivos
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
		keys = {
			{ "<leader>aa", "<cmd>AvanteToggle<CR>", desc = "Avante: Toggle sidebar" },
			{ "<leader>an", "<cmd>AvanteChatNew<CR>", desc = "Avante: Nuevo chat" },
			{ "<leader>ae", "<cmd>AvanteEdit<CR>", desc = "Avante: Editar selección" },
			{ "<leader>af", "<cmd>AvanteFocus<CR>", desc = "Avante: Enfocar sidebar" },
			{ "<leader>ar", "<cmd>AvanteRefresh<CR>", desc = "Avante: Refrescar" },
			{ "<leader>aS", "<cmd>AvanteStop<CR>", desc = "Avante: Detener generación" },
		},
		config = function()
			local opencode_bin = vim.fn.exepath("opencode")
			require("avante").setup({
				provider = "opencode",
				acp_providers = {
					["opencode"] = {
						command = opencode_bin ~= "" and opencode_bin or "opencode",
						args = { "acp" },
						env = {
							NODE_NO_WARNINGS = "1",
							PATH = vim.env.PATH,
						},
					},
				},
				mode = "agentic",
				behaviour = {
					auto_suggestions = false,
					auto_apply_diff_after_generation = false,
					minimize_diff = true,
					enable_token_counting = false,
					auto_add_current_file = true,
					auto_set_keymaps = true,
					auto_set_highlight_group = true,
					auto_approve_tool_permissions = true,
					confirmation_ui_style = "inline_buttons",
				},
				selection = {
					enabled = true,
					hint_display = "delayed",
				},
				selector = {
					provider = "telescope",
				},
				windows = {
					position = "right",
					wrap = true,
					width = 30,
					sidebar_header = {
						enabled = true,
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
			})
		end,
	},
}
