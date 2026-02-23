return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local colors = {
        bg       = "#0B0E14",
        fg       = "#E6E1CF", -- Más brillante
        purple   = "#C397F2", -- Más vibrante
        orange   = "#FFB454", -- Más neón
        green    = "#B1E642", -- Verde lima eléctrico
        red      = "#FF6666", -- Rojo coral brillante
        blue     = "#73D0FF", -- Azul cielo con más luz
        cyan     = "#5ED6B3", -- Cian más claro
        grey     = "#5c6773", -- Comentarios un poco más visibles
      }

      require("onedark").setup({
        style = "darker",
        transparent = true,
        term_colors = true,
        colors = {
          bg0 = colors.bg,
          fg = colors.fg,
          purple = colors.purple,
          orange = colors.orange,
          green = colors.green,
          red = colors.red,
          blue = colors.blue,
          cyan = colors.cyan,
          grey = colors.grey,
        },
        highlights = {
          -- Aplicación de tus grupos con brillo extra
          ["Keyword"] = { fg = colors.purple, fmt = "bold" },
          ["Function"] = { fg = colors.orange, fmt = "bold" },
          ["String"] = { fg = colors.green },
          ["Identifier"] = { fg = colors.red, fmt = "italic" },
          ["Type"] = { fg = colors.blue, fmt = "bold" },
          
          -- Treesitter con colores saturados
          ["@keyword"] = { fg = colors.purple, fmt = "bold" },
          ["@function"] = { fg = colors.orange, fmt = "bold" },
          ["@string"] = { fg = colors.green },
          ["@variable"] = { fg = colors.red, fmt = "italic" },
          ["@type"] = { fg = colors.blue, fmt = "bold" },
          ["@constant"] = { fg = colors.orange, fmt = "bold" },
          ["@parameter"] = { fg = colors.red, fmt = "italic" },
          
          -- UI
          ["Normal"] = { bg = "NONE" },
          ["NormalFloat"] = { bg = "NONE" },
          ["FloatBorder"] = { fg = colors.bg, bg = "NONE" },
          ["WinSeparator"] = { fg = colors.bg, bg = "NONE" },
          ["CursorLineNr"] = { fg = colors.cyan, fmt = "bold" },
          ["LineNr"] = { fg = colors.grey },
        }
      })
      
      vim.cmd("colorscheme onedark")
      
      -- Refuerzo de transparencia
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },
}
