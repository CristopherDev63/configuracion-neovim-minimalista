-- plugins/utils.lua — Utilidades: which-key, trouble, todo-comments, comment, mini, conform, sleuth, project, persistence, colorizer, marks

return {
  ----------------------------------------------------------------
  -- Which-Key: ayuda para atajos de teclado
  ----------------------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = false },
      win = { border = "rounded" },
    },
  },

  ----------------------------------------------------------------
  -- Trouble: diagnóstico en ventana
  ----------------------------------------------------------------
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnósticos" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  ----------------------------------------------------------------
  -- Todo-comments: resaltado de TODO, FIXME, etc.
  ----------------------------------------------------------------
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  ----------------------------------------------------------------
  -- Comment.nvim: comentar/descomentar
  ----------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = true,
  },

  ----------------------------------------------------------------
  -- Mini.nvim: text objects, surrounds, pairs, icons, files
  ----------------------------------------------------------------
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup()       -- text objects inteligentes
      require("mini.surround").setup() -- surrounds
      require("mini.pairs").setup()    -- autocompletado de pares
      require("mini.icons").setup()    -- íconos minimalistas
    end,
  },

  ----------------------------------------------------------------
  -- Conform: formateo de código
  ----------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        html = { "prettierd" },
        css = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  ----------------------------------------------------------------
  -- vim-sleuth: detectar indentación automáticamente
  ----------------------------------------------------------------
  {
    "tpope/vim-sleuth",
    event = { "BufReadPost", "BufNewFile" },
  },

  ----------------------------------------------------------------
  -- project.nvim: gestión de proyectos
  ----------------------------------------------------------------
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    opts = { silent_chdir = true },
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },

  ----------------------------------------------------------------
  -- persistence: guardar sesiones
  ----------------------------------------------------------------
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { dir = vim.fn.stdpath("data") .. "/session/" },
    keys = {
      { "<leader>sr", function() require("persistence").load() end, desc = "Restaurar sesión" },
      { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Última sesión" },
      { "<leader>sd", function() require("persistence").stop() end, desc = "Detener sesión" },
    },
  },

  ----------------------------------------------------------------
  -- nvim-colorizer: mostrar colores inline
  ----------------------------------------------------------------
  {
    "norcalli/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = { "css", "html", "javascript", "typescript", "lua" },
  },

  ----------------------------------------------------------------
  -- marks.nvim: marcas visuales
  ----------------------------------------------------------------
  {
    "chentoast/marks.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  ----------------------------------------------------------------
  -- undotree: historial de cambios visual
  ----------------------------------------------------------------
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
    },
  },

  ----------------------------------------------------------------
  -- Codeium: autocompletado IA gratuito
  ----------------------------------------------------------------
  {
    "Exafunction/codeium.vim",
    event = "InsertEnter",
    config = function()
      vim.g.codeium_disable_map = true
    end,
  },

  ----------------------------------------------------------------
  -- markdown-preview: previsualización de Markdown
  ----------------------------------------------------------------
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  ----------------------------------------------------------------
  -- Alpha: dashboard futurista al abrir Neovim
  ----------------------------------------------------------------
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Header futurista (ASCII art minimalista)
      dashboard.section.header.val = {
        "                                                     ",
        "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "                                                     ",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Buscar archivo", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Archivos recientes", ":Telescope oldfiles<CR>"),
        dashboard.button("g", "  Buscar texto", ":Telescope live_grep<CR>"),
        dashboard.button("e", "  Nuevo archivo", ":ene <BAR> startinsert<CR>"),
        dashboard.button("s", "  Restaurar sesión", ":lua require('persistence').load()<CR>"),
        dashboard.button("c", "  Configuración", ":e $MYVIMRC<CR>"),
        dashboard.button("q", "  Salir", ":qa<CR>"),
      }

      -- Footer con info del sistema
      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        local loaded = stats.loaded
        local total = stats.count
        return "⚡ " .. loaded .. "/" .. total .. " plugins cargados"
      end

      alpha.setup(dashboard.opts)
    end,
  },

  ----------------------------------------------------------------
  -- Dressing: inputs y selects más elegantes
  ----------------------------------------------------------------
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        border = "rounded",
        win_options = { winhighlight = "Normal:Normal" },
      },
      select = {
        enabled = true,
        backend = { "telescope", "fzf", "builtin" },
        builtin = { border = "rounded" },
      },
    },
  },

  ----------------------------------------------------------------
  -- LSP Progress: indicador de progreso de LSP en la UI
  ----------------------------------------------------------------
  {
    "linrongbin16/lsp-progress.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("lsp-progress").setup(opts)
      -- Integrar con lualine
      vim.api.nvim_create_autocmd("User", {
        pattern = "LspProgressStatusUpdated",
        callback = function()
          vim.cmd("redrawstatus")
        end,
      })
    end,
  },

  ----------------------------------------------------------------
  -- Web DevIcons: íconos para archivos (futuristas)
  ----------------------------------------------------------------
  {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    opts = { default = true },
  },

  ----------------------------------------------------------------
  -- Render Markdown: preview de markdown en Neovim
  ----------------------------------------------------------------
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
