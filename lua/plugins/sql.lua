return {
	-- Plugin principal para desarrollo SQL
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
		config = function()
			-- Configuración para vim-dadbod-ui
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_force_echo_messages = 1
			vim.g.db_ui_win_position = "left"
			vim.g.db_ui_winwidth = 40

			-- Auto completado SQL
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
				end,
			})

			-- Keymaps para SQL
			vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<cr>", { desc = "Toggle DBUI" })
			vim.keymap.set("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", { desc = "Find DB buffer" })
			vim.keymap.set("n", "<leader>dr", "<cmd>DBUIRenameBuffer<cr>", { desc = "Rename DB buffer" })
			vim.keymap.set("n", "<leader>dl", "<cmd>DBUILastQueryInfo<cr>", { desc = "Last query info" })
		end,
	},

	-- LSP para SQL (opcional - requiere instalar sqls primero)
	-- Para instalar: go install github.com/lighttiger2505/sqls@latest
	-- {
	-- 	"nanotee/sqls.nvim",
	-- 	ft = { "sql", "mysql", "plsql" },
	-- 	config = function()
	-- 		require("lspconfig").sqls.setup({
	-- 			on_attach = function(client, bufnr)
	-- 				require("sqls").on_attach(client, bufnr)
	-- 			end,
	-- 		})
	-- 	end,
	-- },

	-- Configuración básica de SQL
	{
		"vim-scripts/sql.vim",
		ft = { "sql", "mysql", "plsql" },
		config = function()
			-- Configuración de indentación para SQL
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					vim.bo.shiftwidth = 2
					vim.bo.tabstop = 2
					vim.bo.expandtab = true
					vim.bo.autoindent = true
					vim.bo.smartindent = true

					-- Keymap para formatear manualmente usando =
					vim.keymap.set("n", "<leader>sf", "gg=G", { desc = "Format SQL", buffer = true })
					vim.keymap.set("v", "<leader>sf", "=", { desc = "Format SQL selection", buffer = true })
				end,
			})
		end,
	},

	-- Snippets para SQL
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			-- Cargar snippets de SQL
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/snippets" } })

			-- Snippets personalizados para SQL
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node

			ls.add_snippets("sql", {
				s("select", {
					t("SELECT "),
					i(1, "columns"),
					t({ "", "FROM " }),
					i(2, "table"),
					t({ "", "WHERE " }),
					i(3, "condition"),
					t(";"),
				}),
				s("insert", {
					t("INSERT INTO "),
					i(1, "table"),
					t(" ("),
					i(2, "columns"),
					t({ ")", "VALUES (" }),
					i(3, "values"),
					t(");"),
				}),
				s("update", {
					t("UPDATE "),
					i(1, "table"),
					t({ "", "SET " }),
					i(2, "column = value"),
					t({ "", "WHERE " }),
					i(3, "condition"),
					t(";"),
				}),
				s("delete", {
					t("DELETE FROM "),
					i(1, "table"),
					t({ "", "WHERE " }),
					i(2, "condition"),
					t(";"),
				}),
				s("create", {
					t("CREATE TABLE "),
					i(1, "table_name"),
					t({ " (", "    " }),
					i(2, "column_name data_type"),
					t({ "", ");" }),
				}),
			})
		end,
	},


	-- Mejor syntax highlighting para SQL
	{
		"joereynolds/SQHell.vim",
		ft = { "sql", "mysql", "plsql" },
		config = function()
			-- Configurar colores personalizados para SQL
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					-- Habilitar syntax highlighting mejorado
					vim.cmd([[
						syntax enable
						hi sqlKeyword ctermfg=33 guifg=#569CD6
						hi sqlStatement ctermfg=33 guifg=#569CD6
						hi sqlConditional ctermfg=197 guifg=#FF6B9D
						hi sqlRepeat ctermfg=197 guifg=#FF6B9D
						hi sqlOperator ctermfg=197 guifg=#FF6B9D
						hi sqlFunction ctermfg=220 guifg=#DCDCAA
						hi sqlType ctermfg=81 guifg=#4EC9B0
						hi sqlString ctermfg=214 guifg=#CE9178
						hi sqlNumber ctermfg=141 guifg=#B5CEA8
						hi sqlComment ctermfg=102 guifg=#6A9955
					]])
				end,
			})
		end,
	},
}