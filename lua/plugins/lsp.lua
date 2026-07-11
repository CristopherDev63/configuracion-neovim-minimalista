-- Configuración de LSP Optimizada para bajo rendimiento
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  ft = { "python", "javascript", "typescript", "javascriptreact", "typescriptreact", "css", "html", "java", "php" },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local function on_attach(client, bufnr)
      client.server_capabilities.workspace = client.server_capabilities.workspace or {}
      client.server_capabilities.workspace.didChangeWatchedFiles = false

      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    end

    -- Configuración base optimizada
    local base_config = {
      capabilities = capabilities,
      on_attach = on_attach,
		flags = { 
          debounce_text_changes = 800, -- (Optimización Radical) Menos frecuencia de actualización del servidor
      },
      single_file_support = true,
    }

    local servers = {
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = false,
              useLibraryCodeForTypes = false,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      },
      ts_ls = {
        settings = {
          typescript = {
            tsserver = {
                maxTsServerMemory = 1024,
            }
          }
        }
      },
      cssls = {},
      html = {},
      jdtls = {
        root_dir = vim.fs.root(0, { ".git", "pom.xml", "gradlew", "build.gradle" }),
      },
    }

    for server_name, server_config in pairs(servers) do
      local user_config = vim.tbl_deep_extend("force", base_config, server_config or {})
      local existing = vim.lsp.config[server_name] or {}
      vim.lsp.config[server_name] = vim.tbl_deep_extend("force", existing, user_config)
      vim.lsp.enable(server_name)
    end
    end,
    }