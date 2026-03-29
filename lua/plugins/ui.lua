return {
  -- Configuración de UI sincronizada con Gruvbox

  -- Barra de estado sincronizada con gruvbox
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "gruvbox",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  -- Guías de indentación adaptadas a Gruvbox Light
  {
    "echasnovski/mini.indentscope",
    version = false,
    config = function()
      require("mini.indentscope").setup({
        symbol = "▏",
        options = {
          try_as_border = true,
          indent_at_cursor = true,
        },
        draw = {
          delay = 100,
          animation = require("mini.indentscope").gen_animation.none(),
        },
      })

      -- Colores adaptados a Gruvbox Light (Gris característico)
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#928374", bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#928374", bg = "NONE" })
    end,
  },
}
