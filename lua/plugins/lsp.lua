-- Configuración de LSP mejorada y moderna
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- Obtener capacidades de forma segura
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    -- Función on_attach común
    local function on_attach(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      -- Mapeos LSP básicos
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    end

    -- Tabla de servidores a configurar
    local servers = {
      -- PHP
      intelephense = {
        settings = {
          intelephense = {
            files = { maxSize = 5000000 },
            diagnostics = { enable = true },
            stubs = { "apache", "bcmath", "bz2", "calendar", "com_dotnet", "Core", "ctype", "curl", "date", "dba", "dom", "enchant", "exif", "fileinfo", "filter", "fpm", "ftp", "gd", "gettext", "gmp", "hash", "iconv", "imap", "intl", "json", "ldap", "libxml", "mbstring", "meta", "mysqli", "oci8", "odbc", "openssl", "pcntl", "pcre", "PDO", "pdo_mysql", "pdo_pgsql", "pdo_sqlite", "pgsql", "Phar", "posix", "pspell", "readline", "Reflection", "session", "shmop", "SimpleXML", "soap", "sockets", "sodium", "SPL", "sqlite3", "standard", "superglobals", "sysvmsg", "sysvsem", "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter", "xsl", "Zend OPcache", "zip", "zlib" },
          },
        },
      },
      -- Python
      pyright = {
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
      },
      -- Lua
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
      },
      -- Bash
      bashls = {
        filetypes = { "sh", "bash" },
        settings = {
          bashIde = {
            globPattern = "*@(.sh|.bash|.bats)",
            explainshellEndpoint = "",
            includeAllWorkspaceSymbols = false,
            enableSourceErrorDiagnostics = true,
          },
        },
      },
      -- C/C++
      clangd = {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu", "--completion-style=detailed", "--function-arg-placeholders", "--fallback-style=llvm" },
        init_options = { usePlaceholders = true, completeUnimported = true, clangdFileStatus = true },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      },
      -- Go
      gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
            hints = { assignVariableTypes = true, compositeLiteralFields = true, compositeLiteralTypes = true, constantValues = true, functionTypeParameters = true, parameterNames = true, rangeVariableTypes = true },
          },
        },
      },
      -- CSS
      cssls = {
        filetypes = { "css", "scss", "less" },
        settings = {
          css = { validate = true, lint = { unknownAtRules = "ignore" } },
          scss = { validate = true, lint = { unknownAtRules = "ignore" } },
          less = { validate = true, lint = { unknownAtRules = "ignore" } },
        },
      },
      -- HTML
      html = {
        filetypes = { "html", "templ" },
        init_options = { configurationSection = { "html", "css", "javascript" }, embeddedLanguages = { css = true, javascript = true }, provideFormatter = false },
      },
      -- SQL
      sqls = {
        cmd = { "sqls" },
        filetypes = { "sql", "mysql", "plsql" },
        root_dir = require("lspconfig").util.root_pattern(".sqllsrc", ".git"),
        settings = {
          sqls = {
            connections = {},
          },
        },
      },
      -- Java
      jdtls = {
        cmd = { "jdtls" },
        filetypes = { "java" },
        root_dir = require("lspconfig").util.root_pattern("gradlew", "gradle.build", "build.gradle", "pom.xml", ".git", "mvnw", "build.xml"),
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "<leader>oi", "<Cmd>lua require'jdtls'.organize_imports()<CR>", bufopts)
          vim.keymap.set("n", "<leader>crv", "<Cmd>lua require'jdtls'.extract_variable()<CR>", bufopts)
          vim.keymap.set("v", "<leader>crm", "<Esc><Cmd>lua require'jdtls'.extract_method(true)<CR>", bufopts)
          vim.keymap.set("n", "<leader>crc", "<Cmd>lua require'jdtls'.extract_constant()<CR>", bufopts)
        end,
        settings = {
          java = {
            eclipse = { downloadSources = true },
            configuration = { updateBuildConfiguration = "interactive" },
            maven = { downloadSources = true },
            implementationsCodeLens = { enabled = true },
            referencesCodeLens = { enabled = true },
            references = { includeDecompiledSources = true },
            format = { enabled = true, settings = { url = vim.fn.stdpath("config") .. "/lang-servers/intellij-java-google-style.xml", profile = "GoogleStyle" } },
            signatureHelp = { enabled = true },
            completion = {
              favoriteStaticMembers = { "org.hamcrest.MatcherAssert.assertThat", "org.hamcrest.Matchers.*", "org.hamcrest.CoreMatchers.*", "org.junit.jupiter.api.Assertions.*", "java.util.Objects.requireNonNull", "java.util.Objects.requireNonNullElse", "org.mockito.Mockito.*" },
              importOrder = { "java", "javax", "com", "org" },
            },
            sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
            codeGeneration = { toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" }, useBlocks = true },
          },
        },
        init_options = { bundles = {} },
      },
      gdscript = {},
    }

    -- Configurar cada servidor explícitamente (método moderno)
    local lspconfig = require("lspconfig")

    -- Crear una configuración base para no repetir código
    local base_config = {
      capabilities = capabilities,
      on_attach = on_attach,
      flags = { debounce_text_changes = 150 },
      single_file_support = true,
    }

    -- Configurar cada servidor fusionando la config base con la específica
    lspconfig.intelephense.setup(vim.tbl_deep_extend("force", base_config, servers.intelephense or {}))
    lspconfig.pyright.setup(vim.tbl_deep_extend("force", base_config, servers.pyright or {}))
    lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", base_config, servers.lua_ls or {}))
    lspconfig.bashls.setup(vim.tbl_deep_extend("force", base_config, servers.bashls or {}))
    lspconfig.clangd.setup(vim.tbl_deep_extend("force", base_config, servers.clangd or {}))
    lspconfig.gopls.setup(vim.tbl_deep_extend("force", base_config, servers.gopls or {}))
    lspconfig.cssls.setup(vim.tbl_deep_extend("force", base_config, servers.cssls or {}))
    lspconfig.html.setup(vim.tbl_deep_extend("force", base_config, servers.html or {}))
    lspconfig.sqls.setup(vim.tbl_deep_extend("force", base_config, servers.sqls or {}))
    lspconfig.jdtls.setup(vim.tbl_deep_extend("force", base_config, servers.jdtls or {}))
    lspconfig.gdscript.setup(vim.tbl_deep_extend("force", base_config, servers.gdscript or {}))
  end,
}