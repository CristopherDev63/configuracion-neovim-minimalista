return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          style_preset = require("bufferline").style_preset.minimal,
          separator_style = "thin",
          indicator = {
            style = "icon",
            icon = "▎",
          },
          show_buffer_close_icons = false,
          show_close_icon = false,
          color_icons = true,
          show_tab_indicators = true,
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
          fill = {
            bg = "#e8e9ec",
          },
          background = {
            fg = "#757a90",
            bg = "#e8e9ec",
          },
          buffer_selected = {
            fg = "#33374c",
            bg = "#e8e9ec",
            bold = true,
            italic = true,
          },
          separator = {
            fg = "#cbd0e0",
            bg = "#e8e9ec",
          },
          separator_selected = {
            fg = "#cbd0e0",
            bg = "#e8e9ec",
          },
          indicator_selected = {
            fg = "#2d539e",
            bg = "#e8e9ec",
          },
          modified = {
            fg = "#b36941",
            bg = "#e8e9ec",
          },
          modified_selected = {
            fg = "#b36941",
            bg = "#e8e9ec",
          },
        },
      })
    end,
  },
}