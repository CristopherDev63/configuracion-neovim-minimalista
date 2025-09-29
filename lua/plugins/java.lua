-- lua/plugins/java.lua
-- Configuración completa para Java en Neovim

return {
	-- nvim-jdtls - Plugin principal para Java
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
		},
		config = function()
			local jdtls = require("jdtls")

			-- Detectar el sistema operativo
			local home = os.getenv("HOME")
			local workspace_path = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

			-- Configuración de jdtls
			local config = {
				cmd = {
					"java",
					"-Declipse.application=org.eclipse.jdt.ls.core.id1",
					"-Dosgi.bundles.defaultStartLevel=4",
					"-Declipse.product=org.eclipse.jdt.ls.core.product",
					"-Dlog.protocol=true",
					"-Dlog.level=ALL",
					"-Xms1g",
					"--add-modules=ALL-SYSTEM",
					"--add-opens",
					"java.base/java.util=ALL-UNNAMED",
					"--add-opens",
					"java.base/java.lang=ALL-UNNAMED",
					"-jar",
					-- Cambiar esta ruta por donde tengas instalado jdt-language-server
					vim.fn.glob(
						home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
					),
					"-configuration",
					home .. "/.local/share/nvim/mason/packages/jdtls/config_mac",
					"-data",
					workspace_path,
				},

				root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

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
					},
					contentProvider = { preferred = "fernflower" },
					extendedClientCapabilities = jdtls.extendedClientCapabilities,
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

				flags = {
					allow_incremental_sync = true,
				},
				init_options = {
					bundles = {},
				},
			}

			-- Mapeos específicos para Java
			local function setup_java_keymaps()
				local opts = { noremap = true, silent = true }

				-- LSP básico
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

				-- Específicos de Java
				vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, { desc = "Organizar imports" })
				vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, { desc = "Extraer variable" })
				vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, { desc = "Extraer constante" })
				vim.keymap.set(
					"v",
					"<leader>jm",
					"<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
					{ desc = "Extraer método" }
				)

				-- Test
				vim.keymap.set("n", "<leader>tc", jdtls.test_class, { desc = "Test clase" })
				vim.keymap.set("n", "<leader>tm", jdtls.test_nearest_method, { desc = "Test método" })
			end

			-- Inicializar jdtls
			jdtls.start_or_attach(config)
			setup_java_keymaps()
		end,
	},

	-- Mason para instalar automáticamente jdtls
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"jdtls",
				"java-debug-adapter",
				"java-test",
			},
		},
	},

	-- Debugging para Java
	{
		"mfussenegger/nvim-dap",
		optional = true,
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					vim.list_extend(opts.ensure_installed, { "java-debug-adapter", "java-test" })
				end,
			},
		},
		ft = "java",
		opts = function()
			local dap = require("dap")
			if not dap.adapters["java"] then
				dap.adapters["java"] = function(callback, config)
					-- Aquí va la configuración del adaptador de debug para Java
					callback({
						type = "server",
						host = config.host or "127.0.0.1",
						port = config.port or 5005,
					})
				end
			end

			for _, language in ipairs({ "java" }) do
				if not dap.configurations[language] then
					dap.configurations[language] = {
						{
							type = "java",
							request = "attach",
							name = "Debug (Attach) - Remote",
							hostName = "127.0.0.1",
							port = 5005,
						},
					}
				end
			end
		end,
	},

	-- Treesitter para Java
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "java" })
		end,
	},

	-- Conform para formateo
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters_by_ft = {
				java = { "google-java-format" },
			},
		},
	},

	-- Auto-comando para configurar Java
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
		opts = function()
			return {
				-- Configuración adicional si es necesaria
			}
		end,
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					-- Configuración específica para archivos Java
					vim.opt_local.tabstop = 4
					vim.opt_local.shiftwidth = 4
					vim.opt_local.expandtab = true

					-- Mapeos específicos para Java
					vim.keymap.set(
						"n",
						"<leader>jr",
						":!javac % && java %:r<CR>",
						{ buffer = true, desc = "Compilar y ejecutar Java" }
					)
					vim.keymap.set("n", "<leader>jc", ":!javac %<CR>", { buffer = true, desc = "Compilar Java" })
					vim.keymap.set(
						"n",
						"<leader>jj",
						":!java %:r<CR>",
						{ buffer = true, desc = "Ejecutar Java compilado" }
					)

					-- Maven/Gradle shortcuts
					vim.keymap.set("n", "<leader>mb", ":!mvn compile<CR>", { buffer = true, desc = "Maven compile" })
					vim.keymap.set("n", "<leader>mt", ":!mvn test<CR>", { buffer = true, desc = "Maven test" })
					vim.keymap.set(
						"n",
						"<leader>mr",
						":!mvn spring-boot:run<CR>",
						{ buffer = true, desc = "Maven run Spring Boot" }
					)

					vim.keymap.set("n", "<leader>gb", ":!./gradlew build<CR>", { buffer = true, desc = "Gradle build" })
					vim.keymap.set("n", "<leader>gt", ":!./gradlew test<CR>", { buffer = true, desc = "Gradle test" })
					vim.keymap.set(
						"n",
						"<leader>gr",
						":!./gradlew bootRun<CR>",
						{ buffer = true, desc = "Gradle run Spring Boot" }
					)
				end,
			})
		end,
	},
}
