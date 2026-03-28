return {
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({
        -- Opciones adicionales si las necesitas en el futuro
        options = {
          transparent = false,
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          },
        },
      })

      -- Cargar el tema específico github_light
      vim.cmd("colorscheme github_light")
    end,
  },
}
