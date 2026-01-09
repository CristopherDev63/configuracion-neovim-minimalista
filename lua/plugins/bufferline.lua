return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers", -- Mostrar buffers como pestañas
          -- style_preset = require("bufferline").style_preset.minimal, -- Comentado para permitir estilo con separadores
          separator_style = "slope", -- Estilo de pestaña con pendiente/marco
          always_show_bufferline = true,
          show_buffer_close_icons = false, -- Sin icono de cerrar en cada buffer
          show_close_icon = false, -- Sin icono de cerrar global
          color_icons = false, -- Iconos monocromáticos
          diagnostics = false, -- No mostrar diagnósticos (ya tienes error-lens)
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
          -- Fondo transparente para integración con transparent.nvim
          fill = {
            bg = "NONE",
          },
          background = {
            bg = "NONE",
          },
          tab = {
            bg = "NONE",
          },
          tab_selected = {
            bg = "NONE",
          },
          buffer_visible = {
            bg = "NONE",
          },
          buffer_selected = {
            bg = "NONE",
            bold = true,
            italic = true,
          },
          separator = {
            fg = "#4e555b", -- Color sutil para separadores
            bg = "NONE",
          },
          separator_selected = {
            bg = "NONE",
          },
          separator_visible = {
            bg = "NONE",
          },
          modified = {
            bg = "NONE",
          },
          modified_selected = {
            bg = "NONE",
          },
        },
      })
    end,
  },
}
