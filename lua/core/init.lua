-- Configuración inicial de Lazy.nvim (gestor de plugins)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- versión estable
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 1. Opciones básicas de visualización
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"

-- 2. Indentación y tabs
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

-- 5. Tema y colores
vim.opt.termguicolors = true

-- Configuración de scroll
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitkeep = "screen"

-- Agrega estas líneas a tu configuración (en lua/core/init.lua o donde tengas tus opciones básicas)
vim.opt.wrap = false          -- Desactiva el wrap de texto (no dividir líneas largas)
vim.opt.linebreak = false     -- Desactiva el quiebre en palabras
vim.opt.textwidth = 0         -- Ancho máximo de texto (0 para desactivar)
vim.opt.wrapmargin = 0        -- Margen para wrap (0 para desactivar)

-- Atajos de teclado
local keymap = vim.keymap
keymap.set('n', '<F2>', ':w<CR>', { desc = 'Guardar archivo' })
keymap.set('n', '<F3>', ':q<CR>', { desc = 'Cerrar ventana' })
keymap.set('n', '<F4>', ':wq<CR>', { desc = 'Guardar y salir' })
keymap.set('v', '<C-c>', '"+y', { desc = 'Copiar al portapapeles' })
keymap.set('n', '<C-v>', '"+p', { desc = 'Pegar desde portapapeles' })
keymap.set('i', '<C-v>', '<C-r>+', { desc = 'Pegar en modo inserción' })
keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Siguiente buffer' })
keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Buffer anterior' })
keymap.set('n', 'Q', '<nop>')
keymap.set('n', '<C-z>', '<nop>', { desc = 'Evita suspender Neovim' })

-- Transparencia
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })

-- Plugins Mínimos
require("lazy").setup({
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "python", "lua", "javascript", "typescript" },
        highlight = { enable = true },
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
    "sainnhe/sonokai",
    priority = 1000,
    config = function()
      vim.g.sonokai_transparent_background = 1
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_style = "andromeda"
      vim.cmd.colorscheme("sonokai")
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
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Configuración para Python (Pyright)
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              diagnosticMode = "workspace",
              inlayHints = {
                variableTypes = true,
                functionReturnTypes = true,
                parameterNames = true,
              },
            },
          },
        },
      })

      -- Configuración para TypeScript (ts_ls)
      lspconfig.tsserver.setup({ enabled = false }) -- Desactivar el obsoleto
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      })

      -- Configuración para Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = {'vim'} },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          }
        }
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup({}) end,
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
        },
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        indent = { char = "│" },
        scope = { show_start = false, show_end = false },
      })
    end
  },
})

-- Configuración de autocompletado
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Carga snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
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
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Configuración LSP corregida (sin error de inlay hints)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = args.buf, silent = true }

    -- Navegación entre diagnósticos
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

    -- Funcionalidades LSP
    if client.supports_method("textDocument/hover") then
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    end
    
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
    end

    -- Configuración CORREGIDA para inlay hints (usando booleano)
    if client.name == "pyright" then
      vim.lsp.inlay_hint.enable(args.buf, true) -- Usando true booleano
    end
  end,
})

-- Autoformateo
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.py", "*.lua", "*.js", "*.ts" },
  callback = function()
    require("conform").format({ async = true })
  end,
})

-- Configuración adicional para snippets
vim.keymap.set({ "i", "s" }, "<c-l>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end)
