-- Configuración de LSP Optimizada para bajo rendimiento
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" }, -- (Optimización Radical) Cargar solo al abrir archivos
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Ignorar carpetas pesadas explícitamente para reducir carga de indexación
    local ignored_folders = { "node_modules", ".git", "__pycache__", "venv", ".env", "dist", "build", ".next" }

    local function on_attach(client, bufnr)
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      -- Desactivar escaneo de carpetas ignoradas
      for _, folder in ipairs(ignored_folders) do
          if vim.fn.getcwd():find(folder) then
              client.stop()
              return
          end
      end

      -- Mapeos LSP básicos
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    end

    -- Configuración base optimizada
    local base_config = {
      capabilities = capabilities,
      on_attach = on_attach,
      flags = { 
          debounce_text_changes = 500, -- (Optimización Radical) Menos frecuencia de actualización del servidor
      },
      single_file_support = true,
    }

    local lspconfig = require("lspconfig")
    local servers = {
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = false, -- No buscar automáticamente en todo el sistema
              useLibraryCodeForTypes = false,
              diagnosticMode = "openFilesOnly", -- Solo archivos abiertos
            },
          },
        },
      },
      ts_ls = {
        settings = {
          typescript = {
            tsserver = {
                maxTsServerMemory = 1024, -- Limitar memoria para el servidor de TS
            }
          }
        }
      },
      lua_ls = {},
      bashls = {},
      clangd = {},
      gopls = {},
      cssls = {},
      html = {},
    }

    for server_name, server_config in pairs(servers) do
      local final_config = vim.tbl_deep_extend("force", base_config, server_config or {})
      lspconfig[server_name].setup(final_config)
    end
  end,
}