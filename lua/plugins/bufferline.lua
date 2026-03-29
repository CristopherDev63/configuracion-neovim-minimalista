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
      })
    end,
  },
}