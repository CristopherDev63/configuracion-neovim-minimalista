-- Configuración segura de LSP
local function setup_lsp()
	local lspconfig = require("lspconfig")

	-- Obtener capacidades de forma segura
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	-- Intentar cargar cmp_nvim_lsp si está disponible
	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if ok then
		capabilities = cmp_nvim_lsp.default_capabilities()
		print("✅ cmp_nvim_lsp cargado correctamente")
	else
		print("⚠️ cmp_nvim_lsp no disponible, usando capacidades básicas")
		-- Añadir algunas capacidades básicas manualmente
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.completion.completionItem.preselectSupport = true
		capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
		capabilities.textDocument.completion.completionItem.resolveSupport = {
			properties = { "documentation", "detail", "additionalTextEdits" },
		}
	end

	-- Función on_attach común
	local on_attach = function(client, bufnr)
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

		-- Mapeos LSP básicos
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
	end

	-- Configuración para PHP
	lspconfig.intelephense.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		flags = { debounce_text_changes = 150 },
		single_file_support = true,
		root_dir = lspconfig.util.root_pattern(".git", "composer.json", "index.php"),
		settings = {
			intelephense = {
				files = { maxSize = 5000000 },
				diagnostics = { enable = true },
				stubs = {
					"apache",
					"bcmath",
					"bz2",
					"calendar",
					"com_dotnet",
					"Core",
					"ctype",
					"curl",
					"date",
					"dba",
					"dom",
					"enchant",
					"exif",
					"fileinfo",
					"filter",
					"fpm",
					"ftp",
					"gd",
					"gettext",
					"gmp",
					"hash",
					"iconv",
					"imap",
					"intl",
					"json",
					"ldap",
					"libxml",
					"mbstring",
					"meta",
					"mysqli",
					"oci8",
					"odbc",
					"openssl",
					"pcntl",
					"pcre",
					"PDO",
					"pdo_mysql",
					"pdo_pgsql",
					"pdo_sqlite",
					"pgsql",
					"Phar",
					"posix",
					"pspell",
					"readline",
					"Reflection",
					"session",
					"shmop",
					"SimpleXML",
					"soap",
					"sockets",
					"sodium",
					"SPL",
					"sqlite3",
					"standard",
					"superglobals",
					"sysvmsg",
					"sysvsem",
					"sysvshm",
					"tidy",
					"tokenizer",
					"xml",
					"xmlreader",
					"xmlrpc",
					"xmlwriter",
					"xsl",
					"Zend OPcache",
					"zip",
					"zlib",
				},
			},
		},
	})

	-- Configuración para Python
	lspconfig.pyright.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		flags = { debounce_text_changes = 150 },
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

	-- Configuración para TypeScript
	lspconfig.tsserver.setup({ enabled = false })
	lspconfig.ts_ls.setup({
		capabilities = capabilities,
		on_attach = function(client)
			on_attach(client)
			client.server_capabilities.documentFormattingProvider = false
		end,
	})

	-- Configuración para Lua
	lspconfig.lua_ls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = { library = vim.api.nvim_get_runtime_file("", true) },
				telemetry = { enable = false },
			},
		},
	})

	-- Configuración para bashls
	lspconfig.bashls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "sh", "bash" },
		settings = {
			bashIde = {
				globPattern = "*@(.sh|.bash|.bats)",
				explainshellEndpoint = "",
				includeAllWorkspaceSymbols = false,
				enableSourceErrorDiagnostics = true,
			},
		},
	})

	print("✅ LSP configurado correctamente")
end

-- Ejecutar la configuración
setup_lsp()

return {}
