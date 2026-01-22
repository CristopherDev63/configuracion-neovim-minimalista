return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          transparent = true,
          mode = "buffers",
          style_preset = require("bufferline").style_preset.minimal, -- Estilo minimalista base
          separator_style = { "|", "|" }, -- Separador vertical simple como en la imagen
          indicator = {
            style = "icon",
            icon = "▎", -- Barra lateral sólida indicando el activo
          },
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = true, -- Iconos a color como en la imagen
          show_tab_indicators = true,
          enforce_regular_tabs = false,
          view = "multiwindow",
          show_duplicate_prefix = true,
          offsets = {
            {
              filetype = "NvimTree",
              text = "",
              text_align = "left",
              separator = true,
            },
          },
        },
        highlights = {
          -- Fondo transparente global
          fill = {
            bg = "NONE",
          },
          
          -- Pestañas Inactivas
          background = {
            fg = "#586e75", -- Gris oscuro (Base01)
            bg = "NONE",
          },
          
          -- Pestaña Activa (Seleccionada)
          buffer_selected = {
            fg = "#eee8d5", -- Blanco hueso brillante (Base2)
            bg = "NONE",
            bold = true,
            italic = true,
          },
          
          -- Separadores
          separator = {
            fg = "#586e75", -- Color del separador inactivo
            bg = "NONE",
          },
          separator_selected = {
            fg = "#b58900", -- Amarillo para el separador del activo
            bg = "NONE",
          },
          
          -- Indicador (La barra lateral)
          indicator_selected = {
            fg = "#b58900", -- Amarillo Solarized
            bg = "NONE",
          },
          
          -- Modificados
          modified = {
            fg = "#cb4b16",
            bg = "NONE",
          },
          modified_selected = {
            fg = "#cb4b16", -- Naranja brillante
            bg = "NONE",
          },
          
          -- Compatibilidad
          trunc_marker = { bg = "NONE" },
        },
      })
    end,
  },
}