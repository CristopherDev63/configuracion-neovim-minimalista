-- init.lua CORREGIDO
-- Configuración mínima y estable de Neovim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Cargar opciones básicas primero
require("core.options")
require("core.keymaps")

-- ========== CONFIGURACIÓN LAZY CORREGIDA ==========
require("lazy").setup({
	-- Plugins esenciales
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",

	-- Tema Sonokai (corregido)
	{
		"sainnhe/sonokai",
		priority = 1000,
		config = function()
			vim.g.sonokai_style = "andromeda"
			vim.g.sonokai_better_performance = 1
			vim.g.sonokai_transparent_background = 1
			vim.g.sonokai_enable_italic = 1

			vim.cmd.colorscheme("sonokai")

			-- Transparencia total
			local transparent_groups = {
				"Normal",
				"NormalFloat",
				"SignColumn",
				"LineNr",
				"CursorLine",
				"Pmenu",
				"VertSplit",
				"WinSeparator",
			}

			for _, group in ipairs(transparent_groups) do
				vim.api.nvim_set_hl(0, group, { bg = "NONE" })
			end

			print("🎨 Tema Sonokai cargado")
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"python",
					"lua",
					"javascript",
					"typescript",
					"bash",
					"php",
					"html",
					"css",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { desc = "Buscar archivos" })
		end,
	},

	-- LSP seguro
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Intentar cargar cmp_nvim_lsp si existe
			local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			if ok then
				capabilities = cmp_nvim_lsp.default_capabilities()
			end

			-- Configuraciones básicas y seguras
			lspconfig.pyright.setup({ capabilities = capabilities })
			lspconfig.ts_ls.setup({ capabilities = capabilities }) -- Actualizado de tsserver
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = { library = vim.api.nvim_get_runtime_file("", true) },
						telemetry = { enable = false },
					},
				},
			})

			print("✅ LSP configurado")
		end,
	},

	-- Autocompletado SIMPLE
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})

			print("✅ Autocompletado configurado")
		end,
	},

	-- Debug (simplificado)
	{ import = "plugins.debug" },

	-- Live Server (NUEVO - corregido)
	{ import = "plugins.live-server-fixed" },

	-- UI básico
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = { theme = "sonokai" },
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename" },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- Autopairs
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- Formateo
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "black" },
					javascript = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
				},
			})

			-- Atajo para formatear
			vim.keymap.set("n", "<leader>f", function()
				require("conform").format({ async = true })
			end, { desc = "Formatear código" })
		end,
	},
})

-- Cargar autocomandos después de los plugins
require("core.autocommands")
