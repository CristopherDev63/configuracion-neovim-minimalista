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
					auto_apply_diff_after_generation = true,
					minimize_diff = true,
					enable_token_counting = false,
					auto_add_current_file = true,
					auto_set_keymaps = true,
					auto_set_highlight_group = true,
					auto_approve_tool_permissions = false,
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

			-- Ocultar el "thinking" de la IA en el sidebar (solo visual).
			-- Los datos siguen en el historial; no se borran ni se dejan de enviar.
			local ok, render = pcall(require, "avante.history.render")
			if ok and render and render.message_to_lines then
				local orig_message_to_lines = render.message_to_lines
				render.message_to_lines = function(message, messages, expanded)
					local content = message.message.content
					if type(content) == "table" then
						local new_content, collapsed = {}, false
						for _, item in ipairs(content) do
							if
								type(item) == "table"
								and (item.type == "thinking" or item.type == "redacted_thinking")
							then
								local text = item.thinking or item.data or ""
								local lineas = #vim.split(text, "\n")
								table.insert(new_content, {
									type = "text",
									text = "🤔 Pensamiento oculto (" .. lineas .. " líneas)",
								})
								collapsed = true
							else
								table.insert(new_content, item)
							end
						end
						if collapsed then
							local copy = vim.tbl_extend("keep", {}, message)
							copy.message = vim.tbl_extend("keep", {}, message.message)
							copy.message.content = new_content
							return orig_message_to_lines(copy, messages, expanded)
						end
					end
					return orig_message_to_lines(message, messages, expanded)
				end
			end
		end,
	},
}
