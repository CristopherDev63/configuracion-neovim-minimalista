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
vim.opt.number = true           -- Muestra números de línea absolutos
vim.opt.relativenumber = true   -- Muestra números de línea relativos (útil para moverse rápido)
vim.opt.cursorline = true       -- Resalta la línea actual del cursor
vim.opt.signcolumn = "yes"      -- Espacio para iconos (útil luego con LSP)

-- 2. Indentación y tabs (esencial para programar)
vim.opt.tabstop = 4             -- 1 tab = 4 espacios
vim.opt.shiftwidth = 4          -- Indentación automática = 4 espacios
vim.opt.expandtab = true        -- Convierte tabs en espacios
vim.opt.autoindent = true       -- Mantiene indentación al cambiar de línea

-- 3. Búsqueda y comportamiento del editor
vim.opt.ignorecase = true       -- Ignora mayúsculas/minúsculas al buscar
vim.opt.smartcase = true        -- Si la búsqueda tiene mayúsculas, hace match exacto
vim.opt.incsearch = true        -- Búsqueda incremental (muestra resultados mientras escribes)

-- 4. Rendimiento y archivos temporales
vim.opt.swapfile = false        -- Desactiva el archivo swap (molesto para algunos)
vim.opt.backup = false          -- Sin archivos de backup (puedes activarlo luego si lo prefieres)
vim.opt.undofile = true         -- Mantiene historial de cambios entre sesiones (útil)

-- 5. Tema y colores (configuración mínima)
vim.opt.termguicolors = true    -- Habilita colores verdaderos en terminales modernos

-- Configuración de scroll suave (para no perder contexto)
vim.opt.scrolloff = 8               -- Mínimo de líneas arriba/abajo del cursor (para padding visual)
vim.opt.sidescrolloff = 8           -- Mínimo de columnas laterales (para scroll horizontal)
vim.opt.splitkeep = "screen"        -- Mantiene el scroll al abrir splits (Neovim 0.9+)

-- Atajos de teclado sin tecla líder (keymaps directos)
local keymap = vim.keymap

-- 1. Guardar y salir (atajos universales)
keymap.set('n', '<F2>', ':w<CR>', { desc = 'Guardar archivo' })  -- F2 para guardar
keymap.set('n', '<F3>', ':q<CR>', { desc = 'Cerrar ventana' })   -- F3 para salir
keymap.set('n', '<F4>', ':wq<CR>', { desc = 'Guardar y salir' })  -- F4 para guardar + salir

-- 2. Copiar/pegar con portapapeles del sistema
keymap.set('v', '<C-c>', '"+y', { desc = 'Copiar al portapapeles' })  -- Ctrl + C en modo visual
keymap.set('n', '<C-v>', '"+p', { desc = 'Pegar desde portapapeles' }) -- Ctrl + V en modo normal
keymap.set('i', '<C-v>', '<C-r>+', { desc = 'Pegar desde portapapeles (insertar)' }) -- Ctrl + V en insertar

-- 3. Búsqueda y reemplazo rápido (sin leader)
keymap.set('n', '<F5>', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>', { desc = 'Reemplazar palabra bajo cursor' })

-- 4. Movimiento entre buffers (pestañas)
keymap.set('n', '<Tab>', ':bnext<CR>', { desc = 'Siguiente buffer' })       -- Tab para siguiente buffer
keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = 'Buffer anterior' }) -- Shift + Tab para anterior

-- 5. Deshabilitar teclas "peligrosas"
keymap.set('n', 'Q', '<nop>')  -- Desactiva el modo "Ex" (no útil en programación)
keymap.set('n', '<C-z>', '<nop>', { desc = 'Evita suspender Neovim' }) -- Ctrl + Z no hará nada

-- Configuración de transparencia (debe ir ANTES de cargar el tema)
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })

-- Plugins Mínimos
require("lazy").setup({
  { -- 1. Syntax highlighting mejorado (necesario para LSP)
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript" }, -- Lenguajes que quieras
        highlight = { enable = true },
      })
    end,
  },
  { -- 2. Búsqueda de archivos (Fuzzy Finder)
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- Atajo personalizado para buscar archivos (Ctrl + P)
      vim.keymap.set("n", "<C-p>", ":Telescope find_files<CR>", { desc = "Buscar archivos" })
    end,
  },
  { -- 3. Tema Sonokai (con transparencia)
    "sainnhe/sonokai",
    priority = 1000, -- Asegura que se cargue primero
    config = function()
      vim.g.sonokai_transparent_background = 1
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_style = "andromeda" -- Estilo más oscuro
      vim.cmd.colorscheme("sonokai")
    end,
  },
  { -- 4. Autocompletado (LSP + snippets)
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Fuente de autocompletado (LSP)
      "hrsh7th/cmp-path", -- Autocompletado para rutas de archivos
      "L3MON4D3/LuaSnip", -- Motor de snippets
      "saadparwaiz1/cmp_luasnip", -- Snippets para nvim-cmp
      "rafamadriz/friendly-snippets", -- Biblioteca de snippets (VS Code style)
    },
  },
  { -- 5. LSP Config (integración con servidores de lenguaje)
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").pyright.setup({}) -- Servidor para Python
      -- Más servidores pueden agregarse aquí (ej: tsserver para JavaScript)
    end,
  },
  { -- 6. Cierre automático de brackets/parentesis
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  { -- 7. Formateador de código (usando LSP o herramientas externas)
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "black", "isort" }, -- Formateadores para Python
        },
      })
    end,
  }
})

-- Configuración de nvim-cmp (autocompletado)
local cmp = require("cmp")
local luasnip = require("luasnip")

-- Carga snippets estándar (VS Code like)
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(), -- Trigger manual
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter para confirmar
    ["<Tab>"] = cmp.mapping.select_next_item(), -- Navegar entre sugerencias
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = "nvim-lsp" }, -- Fuente principal (LSP)
    { name = "luasnip" },  -- Snippets
    { name = "path" },     -- Rutas de archivos
  }),
})

-- Atajos específicos para LSP (cuando se adjunta a un buffer)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = args.buf, silent = true }

    -- Navegación entre errores/diagnósticos
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

    -- Formatear código con LSP
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    end
  end,
})

-- Asegúrate de tener instalados black e isort (formateadores de Python)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    require("conform").format({ async = true })
  end,
})
