return {
  {
    "w0ng/vim-hybrid",
    lazy = false,
    priority = 1000,
    config = function()
      -- Configuración para Hybrid Light
      vim.opt.background = "light"
      
      -- Cargar el esquema de colores
      vim.cmd("colorscheme hybrid")
    end,
  },
}
