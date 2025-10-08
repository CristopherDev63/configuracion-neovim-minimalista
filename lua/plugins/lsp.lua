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
	-- lspconfig.tsserver.setup({ enabled = false })
	-- lspconfig.ts_ls.setup({
	-- 	capabilities = capabilities,
	-- 	on_attach = function(client)
	-- 		on_attach(client)
	-- 		client.server_capabilities.documentFormattingProvider = false
	-- 	end,
	-- })

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

	-- Configuración para C/C++ (clangd)
	lspconfig.clangd.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--completion-style=detailed",
			"--function-arg-placeholders",
			"--fallback-style=llvm",
		},
		init_options = {
			usePlaceholders = true,
			completeUnimported = true,
			clangdFileStatus = true,
		},
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
		root_dir = lspconfig.util.root_pattern(
			".clangd",
			".clang-tidy",
			".clang-format",
			"compile_commands.json",
			"compile_flags.txt",
			"configure.ac",
			".git"
		),
		single_file_support = true,
	})

	-- Configuración para Golang (gopls)
	lspconfig.gopls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
		settings = {
			gopls = {
				completeUnimported = true,
				usePlaceholders = true,
				analyses = {
					unusedparams = true,
				},
				staticcheck = true,
				gofumpt = true,
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
			},
		},
	})

	-- Configuración para CSS (cssls)
	lspconfig.cssls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "css", "scss", "less" },
		settings = {
			css = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
			scss = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
			less = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
		},
		single_file_support = true,
	})

	-- Configuración adicional para HTML (htmlls)
	lspconfig.html.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		filetypes = { "html", "templ" },
		init_options = {
			configurationSection = { "html", "css", "javascript" },
			embeddedLanguages = {
				css = true,
				javascript = true,
			},
			provideFormatter = false,
		},
		single_file_support = true,
	})

	-- Configuración para SQL (sqls)
	lspconfig.sqls.setup({
		capabilities = capabilities,
		on_attach = on_attach,
		cmd = { "sqls" },
		filetypes = { "sql", "mysql", "plsql" },
		root_dir = function(fname)
			return lspconfig.util.root_pattern(".sqllsrc", ".git")(fname) or vim.fn.getcwd()
		end,
		single_file_support = true,
		settings = {
			sqls = {
				connections = {
					-- Las conexiones se configurarán en el archivo .sqllsrc
				},
			},
		},
	})

	-- Configuración para Java (jdtls - Eclipse Language Server)
	lspconfig.jdtls.setup({
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			-- Mapeos específicos para Java
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "<leader>oi", "<Cmd>lua require'jdtls'.organize_imports()<CR>", bufopts)
			vim.keymap.set("n", "<leader>crv", "<Cmd>lua require'jdtls'.extract_variable()<CR>", bufopts)
			vim.keymap.set("v", "<leader>crm", "<Esc><Cmd>lua require'jdtls'.extract_method(true)<CR>", bufopts)
			vim.keymap.set("n", "<leader>crc", "<Cmd>lua require'jdtls'.extract_constant()<CR>", bufopts)
		end,
		cmd = { "jdtls" },
		filetypes = { "java" },
		root_dir = lspconfig.util.root_pattern(
			"gradlew",
			"gradle.build",
			"build.gradle",
			"pom.xml",
			".git",
			"mvnw",
			"build.xml"
		),
		single_file_support = true,
		settings = {
			java = {
				eclipse = {
					downloadSources = true,
				},
				configuration = {
					updateBuildConfiguration = "interactive",
				},
				maven = {
					downloadSources = true,
				},
				implementationsCodeLens = {
					enabled = true,
				},
				referencesCodeLens = {
					enabled = true,
				},
				references = {
					includeDecompiledSources = true,
				},
				format = {
					enabled = true,
					settings = {
						url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml",
						profile = "GoogleStyle",
					},
				},
				signatureHelp = { enabled = true },
				completion = {
					favoriteStaticMembers = {
						"org.hamcrest.MatcherAssert.assertThat",
						"org.hamcrest.Matchers.*",
						"org.hamcrest.CoreMatchers.*",
						"org.junit.jupiter.api.Assertions.*",
						"java.util.Objects.requireNonNull",
						"java.util.Objects.requireNonNullElse",
						"org.mockito.Mockito.*",
					},
					importOrder = {
						"java",
						"javax",
						"com",
						"org",
					},
				},
				sources = {
					organizeImports = {
						starThreshold = 9999,
						staticStarThreshold = 9999,
					},
				},
				codeGeneration = {
					toString = {
						template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
					},
					useBlocks = true,
				},
			},
		},
		init_options = {
			bundles = {},
		},
	})

	print("✅ LSP configurado correctamente para todos los lenguajes (incluye SQL y Java)")
end

-- Ejecutar la configuración
setup_lsp()

return {}
