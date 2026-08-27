-- core/lazy.lua — Bootstrap de lazy.nvim + carga de módulos

-- Instalar lazy.nvim si no existe
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Cargar módulos core primero
require("core.options")
require("core.colors")
require("core.keymaps")
require("core.autocmds")
require("user.settings")

-- Cargar todos los plugins desde lua/plugins/
-- lazy.nvim escanea automáticamente los archivos en la carpeta plugins/
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  ui = {
    border = "rounded",
    icons = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen",
        "netrwPlugin", "tarPlugin", "tohtml",
        "tutor", "zipPlugin",
      },
    },
  },
})

-- Cargar atajos personalizados después de los plugins
require("user.shortcuts")
