return {
  -- Configuración de UI sincronizada con Ayu

  -- Barra de estado sincronizada con ayu
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "ayu",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  -- Guías de indentación adaptadas a Ayu Light
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

      -- Colores adaptados a Ayu Light (Gris suave)
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#abb2bf", bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#abb2bf", bg = "NONE" })
    end,
  },
}
