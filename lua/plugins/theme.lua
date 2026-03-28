return {
  {
    "mhartington/oceanic-next",
    lazy = false,
    priority = 1000,
    config = function()
      -- Configuración para OceanicNext Light
      vim.opt.background = "light"
      
      -- Cargar el esquema de colores
      vim.cmd("colorscheme OceanicNext")
    end,
  },
}
