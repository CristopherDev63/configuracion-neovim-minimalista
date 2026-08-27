-- plugins/init.lua — Importación maestra de plugins Nothing Edition
-- Cada plugin es un archivo separado en esta misma carpeta

return {
  -- Tema base
  { import = "plugins.theme" },

  -- UI
  { import = "plugins.ui" },

  -- Navegación
  { import = "plugins.nav" },

  -- Búsquedas
  { import = "plugins.telescope" },

  -- LSP
  { import = "plugins.lsp" },

  -- Autocompletado
  { import = "plugins.cmp" },

  -- Treesitter
  { import = "plugins.treesitter" },

  -- Git
  { import = "plugins.git" },

  -- Terminal
  { import = "plugins.toggleterm" },

  -- IA
  { import = "plugins.ai" },

  -- Depuración
  { import = "plugins.debug" },

  -- Utilidades
  { import = "plugins.utils" },
}
