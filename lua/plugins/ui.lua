return {
  -- Configuración de UI sincronizada con Flexoki Dark

  -- Barra de estado sincronizada con Flexoki
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto", -- Flexoki suele detectarse bien con 'auto'
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  -- Guías de indentación adaptadas a Flexoki Dark
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

      -- Colores adaptados a Flexoki Dark (Gris oscuro/negro)
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#404040", bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#404040", bg = "NONE" })
    end,
  },
}
