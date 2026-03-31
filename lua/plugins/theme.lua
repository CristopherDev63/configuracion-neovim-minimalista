return {
  {
    "tanvirtin/monokai.nvim",
    name = "monokai",
    lazy = false,
    priority = 1000,
    config = function()
      local monokai = require("monokai")
      monokai.setup({
        custom_hlgroups = {
          -- 1. USO DE ITALICS (CURSIVA)
          -- Separar descripción del código (comentarios, parámetros, atributos)
          ["Comment"] = { italic = true },
          ["@comment"] = { italic = true },
          ["@parameter"] = { italic = true },
          ["@variable.parameter"] = { italic = true },
          ["@attribute"] = { italic = true },
          ["@tag.attribute"] = { italic = true },
          ["@variable.builtin"] = { italic = true }, -- Para 'self' en Python o 'this' en JS

          -- 2. USO DE BOLD (NEGRITA)
          -- Pilares de estructura (control, definiciones, títulos)
          ["Keyword"] = { bold = true },
          ["@keyword"] = { bold = true },
          ["@keyword.function"] = { bold = true },
          ["@keyword.return"] = { bold = true },
          ["@keyword.operator"] = { bold = true },
          ["@type"] = { bold = true },
          ["@constructor"] = { bold = true },
          ["@text.title"] = { bold = true }, -- Markdown headers
        },
      })
    end,
  },
}
