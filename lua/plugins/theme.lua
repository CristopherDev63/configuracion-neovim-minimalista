return {
  {
    "tanvirtin/monokai.nvim",
    name = "monokai",
    lazy = false,
    priority = 1000,
    config = function()
      local monokai = require("monokai")
      monokai.setup({
        palette = monokai.classic,
        custom_hlgroups = {
          ["Comment"] = { italic = true, fg = "#75715e" },
          ["@comment"] = { italic = true },
          ["@parameter"] = { italic = true },
          ["@variable.parameter"] = { italic = true },
          ["Keyword"] = { bold = true, fg = "#f92672" },
          ["@keyword"] = { bold = true },
          ["@keyword.function"] = { bold = true },
          ["@keyword.conditional"] = { bold = true },
        },
      })

      -- FUERZA BRUTA: Asegurar que los estilos se apliquen incluso si otros plugins intentan limpiarlos
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          vim.api.nvim_set_hl(0, "Comment", { italic = true, fg = "#75715e" })
          vim.api.nvim_set_hl(0, "@variable.parameter", { italic = true })
          vim.api.nvim_set_hl(0, "Keyword", { bold = true, fg = "#f92672" })
        end,
      })
    end,
  },
}
