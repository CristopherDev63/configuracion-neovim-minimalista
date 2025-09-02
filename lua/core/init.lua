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

-- 1. Opciones básicas de visualización
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- 2. Indentación and tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- 3. Búsqueda y comportamiento
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- 4. Rendimiento
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

-- 5. Tema y colores - Configuraremos después de cargar los plugins
vim.opt.termguicolors = true

-- Configuración de scroll
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitkeep = "screen"

-- Configuración de texto
vim.opt.wrap = false
vim.opt.linebreak = false
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0

-- Función para ejecutar código según el tipo de archivo
local function execute_code_based_on_filetype()
	local filetype = vim.bo.filetype
	local filename = vim.fn.expand("%")

	-- Guardar el archivo primero
	vim.cmd("write")

	if filetype == "python" or string.match(filename, "%.py$") then
		vim.cmd("!python3 %")
	elseif filetype == "sh" or filetype == "bash" or string.match(filename, "%.sh$") then
		vim.cmd("!bash %")
	elseif filetype == "javascript" or string.match(filename, "%.js$") then
		vim.cmd("!node %")
	elseif filetype == "typescript" or string.match(filename, "%.ts$") then
		vim.cmd("!ts-node %")
	elseif filetype == "lua" or string.match(filename, "%.lua$") then
		vim.cmd("!lua %")
	else
		print("Tipo de archivo no soportado para ejecución: " .. filetype)
	end
end

-- Atajos de teclado
local keymap = vim.keymap
keymap.set("n", "<C-c>", execute_code_based_on_filetype, { desc = "Ejecutar código según tipo de archivo" })
keymap.set("n", "<F2>", ":w<CR>", { desc = "Guardar archivo" })
keymap.set("n", "<F3>", ":q<CR>", { desc = "Cerrar ventana" })
keymap.set("n", "<F4>", ":wq<CR>", { desc = "Guardar y salir" })
keymap.set("n", "<C-v>", '"+p', { desc = "Pegar desde portapapeles" })
keymap.set("i", "<C-v>", "<C-r>+", { desc = "Pegar en modo inserción" })
keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Siguiente buffer" })
keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Buffer anterior" })
keymap.set("n", "Q", "<nop>")
keymap.set("n", "<C-z>", "<nop>", { desc = "Evita suspender Neovim" })

-- Bloqueo de flechas de navegación
keymap.set("n", "<Up>", "<nop>", { desc = "Desactivar flecha arriba" })
keymap.set("n", "<Down>", "<nop>", { desc = "Desactivar flecha abajo" })
keymap.set("n", "<Left>", "<nop>", { desc = "Desactivar flecha izquierda" })
keymap.set("n", "<Right>", "<nop>", { desc = "Desactivar flecha derecha" })
keymap.set("i", "<Up>", "<nop>", { desc = "Desactivar flecha arriba" })
keymap.set("i", "<Down>", "<nop>", { desc = "Desactivar flecha abajo" })
keymap.set("i", "<Left>", "<nop>", { desc = "Desactivar flecha izquierda" })
keymap.set("i", "<Right>", "<nop>", { desc = "Desactivar flecha derecha" })

-- Atajo para formatear con Ctrl+J
keymap.set("n", "<C-J>", function()
	require("conform").format({ async = true })
end, { desc = "Formatear código" })

-- Comando para recargar LSP y Treesitter cuando falle
keymap.set("n", "<leader>rr", function()
	-- Detener y reiniciar LSP
	local clients = vim.lsp.get_active_clients()
	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id)
	end

	vim.defer_fn(function()
		-- Reiniciar LSP para el buffer actual
		vim.lsp.start()

		-- Reiniciar Treesitter
		vim.treesitter.stop()
		vim.defer_fn(function()
			vim.treesitter.start()
			print("✓ LSP y Treesitter recargados correctamente")
		end, 100)
	end, 150)
end, { desc = "Recargar LSP y Treesitter" })

-- Diagnosticar estado LSP
keymap.set("n", "<leader>ld", function()
	local clients = vim.lsp.get_active_clients()
	local bufnr = vim.api.nvim_get_current_buf()

	if #clients == 0 then
		print("❌ No hay clientes LSP activos")
	else
		for _, client in ipairs(clients) do
			local attached = client.attached_buffers[bufnr] and "✓ Activo" or "❌ Inactivo"
			print("LSP: " .. client.name .. " - " .. attached)
		end
	end
end, { desc = "Diagnosticar estado LSP" })

-- Plugins Mínimos
require("lazy").setup({
	-- Tema VSCode Dark
	{
		"Mofiqul/vscode.nvim",
		priority = 1000,
		config = function()
			require("vscode").setup({
				transparent = true,
				italic_comments = true,
				disable_nvimtree_bg = true,
			})

			vim.cmd.colorscheme("vscode")

			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
			vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
			vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
			vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
			vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
			vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
			vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })

			vim.api.nvim_set_hl(0, "VertSplit", { fg = "#3e4452", bg = "none" })
			vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3e4452", bg = "none" })

			vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
			vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#264f78", fg = "#d4d4d4" })
			vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "none" })
			vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#3e4452" })
			vim.api.nvim_set_hl(0, "PmenuBorder", { bg = "none", fg = "#3e4452" })

			vim.api.nvim_set_hl(0, "LineNr", { fg = "#858585", bg = "none" })
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d4d4d4", bg = "none", bold = true })

			vim.api.nvim_set_hl(0, "Search", { fg = "#d4d4d4", bg = "#613214" })
			vim.api.nvim_set_hl(0, "IncSearch", { fg = "#d4d4d4", bg = "#613214" })

			vim.api.nvim_set_hl(0, "Cursor", { fg = "#1e1e1e", bg = "#aeafad" })
			vim.api.nvim_set_hl(0, "Visual", { bg = "#264f78" })

			vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#f44747" })
			vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#ff8800" })
			vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#75beff" })
			vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#4ec9b0" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "python", "lua", "javascript", "typescript", "bash" }, -- Agregado bash aquí
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { desc = "Buscar archivos" })
		end,
	},
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
		},
	},
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local luasnip = require("luasnip")
			local types = require("luasnip.util.types")

			luasnip.config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
				enable_autosnippets = true,
				ext_opts = {
					[types.choiceNode] = {
						active = {
							virt_text = { { "•", "GruvboxOrange" } },
						},
					},
					[types.insertNode] = {
						active = {
							virt_text = { { "•", "GruvboxBlue" } },
						},
					},
				},
				ft_func = function()
					return vim.split(vim.bo.filetype, ".", true)
				end,
			})

			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
			require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets" })

			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				end
			end, { desc = "Cambiar opción en snippet" })

			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				if luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				end
			end, { desc = "Expandir o saltar al siguiente snippet" })

			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				end
			end, { desc = "Saltar al snippet anterior" })

			vim.keymap.set("i", "<C-u>", function()
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				end
			end, { desc = "Cambiar opción en snippet" })
		end,
	},
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({
				enable_chat = true,
			})

			vim.keymap.set("i", "<C-g>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true, desc = "Codeium: Accept suggestion" })
			vim.keymap.set("i", "<c-;>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true, desc = "Codeium: Next suggestion" })
			vim.keymap.set("i", "<c-,>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true, desc = "Codeium: Prev suggestion" })
			vim.keymap.set("i", "<c-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true, desc = "Codeium: Clear suggestion" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
				end,
				flags = {
					debounce_text_changes = 150,
				},
				single_file_support = true,
				root_dir = lspconfig.util.root_pattern(".git", "setup.py", "pyproject.toml", "requirements.txt"),
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							diagnosticMode = "workspace",
							inlayHints = {
								variableTypes = false,
								functionReturnTypes = false,
								parameterNames = false,
							},
						},
					},
				},
			})

			lspconfig.tsserver.setup({ enabled = false })
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
				end,
			})

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

			-- Configuración para bashls (LSP para Bash)
			lspconfig.bashls.setup({
				capabilities = capabilities,
				filetypes = { "sh", "bash" },
				on_attach = function(client, bufnr)
					vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
				end,
				settings = {
					bashIde = {
						globPattern = "*@(.sh|.bash|.bats)",
						explainshellEndpoint = "",
						includeAllWorkspaceSymbols = false,
						enableSourceErrorDiagnostics = true,
					},
				},
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					python = { "black", "isort" },
					lua = { "stylua" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					sh = { "shfmt" }, -- Agregado formateador para shell scripts
					bash = { "shfmt" }, -- Agregado formateador para bash
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},
	{
		"echasnovski/mini.indentscope",
		version = false,
		config = function()
			require("mini.indentscope").setup({
				symbol = "▏",
				options = {
					try_as_border = true,
					indent_at_cursor = true,
				},
				draw = {
					delay = 100,
					animation = require("mini.indentscope").gen_animation.none(),
				},
			})

			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#404040", bg = "none" })
			vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#404040", bg = "none" })
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "vscode",
					component_separators = { left = "▏", right = "▏" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = { "NvimTree", "alpha" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				extensions = { "fugitive", "nvim-tree" },
			})

			-- Cambiar el ícono del sistema operativo a la manzana de Apple
			-- Esto se hace estableciendo el ícono para el hostname
			vim.api.nvim_set_hl(0, "lualine_c_hostname", { fg = "#ffffff", bg = "#555555" })
		end,
	},
})

-- Auto-comandos para manejar problemas de LSP y Treesitter
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python", "sh", "bash" }, -- Agregados sh and bash
	callback = function()
		local filetype = vim.bo.filetype

		-- Verificar y forzar LSP si no está activo
		local clients = vim.lsp.get_active_clients({ bufnr = 0 })
		if #clients == 0 then
			vim.defer_fn(function()
				if filetype == "python" then
					require("lspconfig").pyright.launch()
				elseif filetype == "sh" or filetype == "bash" then
					require("lspconfig").bashls.launch()
				end
			end, 100)
		end

		-- Verificar y forzar Treesitter si no está activo
		if not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
			vim.defer_fn(function()
				vim.treesitter.start()
			end, 150)
		end
	end,
	desc = "Asegurar LSP y Treesitter para Python y Bash",
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.py", "*.sh", "*.bash" }, -- Agregados sh and bash
	callback = function()
		local filetype = vim.bo.filetype

		-- Verificación adicional al entrar al buffer
		local clients = vim.lsp.get_active_clients({ bufnr = 0 })
		if #clients == 0 then
			vim.defer_fn(function()
				if filetype == "python" then
					require("lspconfig").pyright.launch()
				elseif filetype == "sh" or filetype == "bash" then
					require("lspconfig").bashls.launch()
				end
			end, 50)
		end
	end,
	desc = "Verificar LSP al entrar a buffer Python o Bash",
})

-- Configuración de autocompletado
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyLoad",
	callback = function()
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
						luasnip = "[LuaSnip]",
						nvim_lua = "[Lua]",
						latex_symbols = "[Latex]",
						path = "[Path]",
						codeium = "[AI]",
					},
				}),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-Space>"] = cmp.mapping.complete(),
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
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "codeium" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
			}),
		})

		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#3e4452" })
		vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#d4d4d4", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#858585", bg = "none", strikethrough = true })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#569cd6", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#569cd6", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#c586c0", bg = "none" })

		vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#9cdcfe", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#c586c0", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#c586c0", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#c586c0", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#9cdcfe", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#9cdcfe", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#4ec9b0", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#4ec9b0", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#4ec9b0", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#ce9178", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#d4d4d4", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#ce9178", bg = "none" })
		vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#ce9178", bg = "none" })
	end,
})

-- Configuración LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local opts = { buffer = args.buf, silent = true }

		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

		if client.supports_method("textDocument/hover") then
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		end

		if client.supports_method("textDocument/formatting") then
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
		end
	end,
})

-- Función para verificar y reparar automáticamente
local function check_and_repair_lsp()
	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.bo.filetype
	local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

	if #clients == 0 then
		vim.defer_fn(function()
			if filetype == "python" then
				require("lspconfig").pyright.launch()
				print("↻ LSP reactivado automáticamente para Python")
			elseif filetype == "sh" or filetype == "bash" then
				require("lspconfig").bashls.launch()
				print("↻ LSP reactivado automáticamente para Bash")
			end
		end, 200)
	end
end

-- Verificar periódicamente (cada 2 segundos cuando está en modo normal)
vim.api.nvim_create_autocmd("CursorHold", {
	callback = check_and_repair_lsp,
	desc = "Verificar estado LSP periódicamente",
})

-- Función personalizada para mostrar el ícono de Apple en la barra de estado
local function apple_icon()
	return " " -- Este es el código del ícono de Apple en Nerd Fonts
end

-- Añadir el ícono de Apple a la barra de estado
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		-- Añadir el ícono de Apple al inicio de la sección c
		require("lualine").setup({
			sections = {
				lualine_c = { apple_icon, { "filename", path = 1 } },
			},
		})
	end,
})

print("✓ Configuración cargada. Usa <leader>rr para recargar LSP/Treesitter si hay problemas")
