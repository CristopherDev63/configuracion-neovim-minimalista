-- Soporte completo para reStructuredText y Sphinx
return {
	-- Plugin principal para soporte de reStructuredText
	{
		"marshallward/vim-restructuredtext",
		ft = "rst",
		config = function()
			-- Configuración de indentación para rst
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "rst",
				callback = function()
					vim.opt_local.shiftwidth = 3
					vim.opt_local.tabstop = 3
					vim.opt_local.softtabstop = 3
					vim.opt_local.expandtab = true
					vim.opt_local.textwidth = 79
					vim.opt_local.wrap = true
					vim.opt_local.linebreak = true
				end,
			})
		end,
	},

	-- Treesitter para mejor highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "rst" })
			end
		end,
	},

	-- LSP para reStructuredText usando esbonio (Sphinx Language Server)
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				esbonio = {
					-- Configuración del servidor de lenguaje Sphinx
					filetypes = { "rst" },
					init_options = {
						sphinx = {
							buildDir = "${workspaceRoot}/_build",
							confDir = "${workspaceRoot}",
						},
					},
				},
			},
		},
		config = function()
			local lspconfig = require("lspconfig")

			-- Configurar esbonio si está instalado
			if vim.fn.executable("esbonio") == 1 then
				lspconfig.esbonio.setup({
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					filetypes = { "rst" },
					init_options = {
						sphinx = {
							buildDir = "${workspaceRoot}/_build",
							confDir = "${workspaceRoot}",
						},
					},
				})
			end
		end,
	},

	-- Autocompletado específico para rst
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		opts = function(_, opts)
			local cmp = require("cmp")

			-- Añadir fuentes específicas para rst
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "buffer",
				option = {
					keyword_pattern = [[\k\+]],
				},
			})
		end,
	},

	-- Atajos de teclado útiles para rst/Sphinx
	{
		"folke/which-key.nvim",
		optional = true,
		opts = {
			spec = {
				{ "<leader>s", group = "sphinx" },
				{ "<leader>sb", ":!sphinx-build -b html . _build/html<CR>", desc = "Build Sphinx HTML" },
				{ "<leader>so", ":!open _build/html/index.html<CR>", desc = "Open Sphinx docs" },
				{ "<leader>sc", ":!make clean<CR>", desc = "Clean Sphinx build" },
			},
		},
	},
}
