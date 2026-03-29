return {
  -- Configuración de UI sincronizada con Bluloco Light

  -- Barra de estado sincronizada con bluloco
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "bluloco",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },

  -- Guías de indentación adaptadas a Bluloco Light
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

      -- Colores adaptados a Bluloco Light (Azul grisáceo suave)
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#383a42", bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#383a42", bg = "NONE" })
    end,
  },
}
