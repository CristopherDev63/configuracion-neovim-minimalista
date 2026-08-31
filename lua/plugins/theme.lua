return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Configuración predeterminada de Kanagawa
      require("kanagawa").setup({
        compile = false,             -- compila el tema para un inicio más rápido
        undercurl = true,            -- habilita undercurls
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,         -- fondo no transparente
        dimInactive = false,         -- atenúa ventanas inactivas
        terminalColors = true,       -- define vim.g.terminal_color_*
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors) -- agregar/modificar highlights
          return {}
        end,
        theme = "wave",              -- Carga el tema "wave" cuando no se establece 'background'
        background = {               -- mapea el valor de la opción 'background' a un tema
          dark = "wave",             -- prueba "dragon" también para una alternativa más oscura
          light = "lotus"
        },
      })

      -- Cargar el esquema de colores
      vim.cmd("colorscheme kanagawa")
    end,
  },
}