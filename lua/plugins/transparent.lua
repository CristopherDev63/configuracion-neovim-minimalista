return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 1001, -- Un poco más alto que el tema
    config = function()
      require("transparent").setup({
        extra_groups = {
          "NormalFloat",
          "NvimTreeNormal",
          "OilNormal",
          "TelescopeNormal",
          "TelescopeBorder",
          "LspFloatWinNormal",
        },
      })
      -- Activar transparencia inmediatamente
      -- vim.cmd("TransparentEnable")
    end,
  },
}
