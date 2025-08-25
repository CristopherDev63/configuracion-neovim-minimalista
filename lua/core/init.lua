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

-- Atajos de teclado
local keymap = vim.keymap
keymap.set("n", "<F2>", ":w<CR>", { desc = "Guardar archivo" })
keymap.set("n", "<F3>", ":q<CR>", { desc = "Cerrar ventana" })
keymap.set("n", "<F4>", ":wq<CR>", { desc = "Guardar y salir" })
keymap.set("v", "<C-c>", '"+y', { desc = "Copiar al portapapeles" })
keymap.set("n", "<C-v>", '"+p', { desc = "Pegar desde portapapeles" })
keymap.set("i", "<C-v>", "<C-r>+", { desc = "Pegar en modo inserción" })
keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "Siguiente buffer" })
keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "Buffer anterior" })
keymap.set("n", "Q", "<nop>")
keymap.set("n", "<C-z>", "<nop>", { desc = "Evita suspender Neovim"})
keymap.set("n", "<C-b>", "w !python3")

-- Bloqueo de flechas de navegación
keymap.set("n", "<Up>", "<nop>", { desc = "Desactivar flecha arriba" })
keymap.set("n", "<Down>", "<nop>", { desc = "Desactivar flecha abajo" })
keymap.set("n", "<Left>", "<nop>", { desc = "Desactivar flecha izquierda" })
keymap.set("n", "<Right>", "<nop>", { desc = "Desactivar flecha derecha" })
keymap.set("i", "<Up>", "<nop>", { desc = "Desactivar flecha arriba" })
keymap.set("i", "<Down>", "<nop>", { desc = "Desactivar flecha abajo" })
keymap.set("i", "<Left>", "<nop>", { desc = "Desactivar flecha izquierda" })
keymap.set("i", "<Right>", "<nop>", { desc = "Desactivar flecha derecha" })

-- Plugins Mínimos
require("lazy").setup({
  -- Tema Jellybeans
  {
    "nanotech/jellybeans.vim",
    priority = 1000, -- Alta prioridad para cargar primero
    config = function()
      -- Configuración del tema Jellybeans
      vim.g.jellybeans_use_term_italics = 0
      vim.g.jellybeans_use_lowcolor_black = 0
      
      -- Aplicar el tema
      vim.cmd.colorscheme("jellybeans")
      
      -- Configuración de transparencia para toda la UI
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
      vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
      vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
      vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })
      
      -- Bordes y separadores en blanco
      vim.api.nvim_set_hl(0, "VertSplit", { fg = "#ffffff", bg = "none" })
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ffffff", bg = "none" })
      
      -- Transparencia para el menú de autocompletado con bordes blancos
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#444444", fg = "white" })
      vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "none" })
      vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#666666" })
      vim.api.nvim_set_hl(0, "PmenuBorder", { bg = "none", fg = "#ffffff" })
      
      -- Ajustar colores para mejor contraste con transparencia
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#888888", bg = "none" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bg = "none", bold = true })
    end,
  },
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
  -- AUTCOMPLETADO CON IA (CODÉIUM)
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
      
      -- Atajos de teclado para Codeium
      vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, desc = "Codeium: Accept suggestion" })
      vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, desc = "Codeium: Next suggestion" })
      vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, desc = "Codeium: Prev suggestion" })
      vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, desc = "Codeium: Clear suggestion" })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configuración para Python (Pyright)
      lspconfig.pyright.setup({
        capabilities = capabilities,
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

      -- Configuración para TypeScript (ts_ls)
      lspconfig.tsserver.setup({ enabled = false })
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
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
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
        },
      })
    end,
  },
  -- Mini.indentscope para guías de indentación
  {
    "echasnovski/mini.indentscope",
    version = false,
    config = function()
      require("mini.indentscope").setup({
        symbol = "│",
        options = {
          try_as_border = true,
          indent_at_cursor = true,
        },
        draw = {
          delay = 100,
          animation = require("mini.indentscope").gen_animation.none()
        }
      })

      -- Guías de indentación en BLANCO
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#ffffff", bg = "none" })
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#ffffff", bg = "none" })
    end,
  },
  -- Plugin lualine.nvim
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "jellybeans",
          component_separators = { left = "│", right = "│" },
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
    end,
  },
})

-- Configuración de autocompletado (después de que los plugins se carguen)
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- Carga snippets
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

    -- Configuración adicional de transparencia para el autocompletado con bordes BLANCOS
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#ffffff" }) -- Borde BLANCO
    vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#f8f8f2", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#75715e", bg = "none", strikethrough = true })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#66d9ef", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#66d9ef", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#a6e22e", bg = "none" })
    
    -- Colores para los tipos de items con transparencia
    vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#fd971f", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#a6e22e", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#a6e22e", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#f92672", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#fd971f", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#fd971f", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#e6db74", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#e6db74", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#e6db74", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#ae81ff", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#f8f8f2", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#ae81ff", bg = "none" })
    vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#ae81ff", bg = "none" })
  end
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
