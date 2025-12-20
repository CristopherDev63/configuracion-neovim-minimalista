-- Configuración de LSP mejorada y moderna
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    -- Obtener capacidades de forma segura con blink.cmp
    local capabilities = require('blink.cmp').get_lsp_capabilities()

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
      gdscript = {},
    }

    -- Crear una configuración base para no repetir código
    local base_config = {
      capabilities = capabilities,
      on_attach = on_attach,
      flags = { 
          debounce_text_changes = 300, -- (Optimización 4) Retraso para no saturar CPU al escribir
      },
      single_file_support = true,
    }

    -- Configurar cada servidor dinámicamente
    local lspconfig = require("lspconfig")
    for server_name, server_config in pairs(servers) do
      -- Fusionar la configuración base con la específica del servidor
      local final_config = vim.tbl_deep_extend("force", base_config, server_config or {})
      vim.lsp.config[server_name] = final_config
    end
  end,
}