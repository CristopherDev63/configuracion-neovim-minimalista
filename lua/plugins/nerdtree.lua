return {
  {
    "preservim/nerdtree",
    dependencies = {
      "ryanoasis/vim-devicons", -- Soporte para iconos de NerdFont
      "tiagofumo/vim-nerdtree-syntax-highlight", -- Resaltado de sintaxis (colores) en NERDTree
    },
    config = function()
      -- Mapeo principal: <leader>e para alternar el árbol
      vim.keymap.set("n", "<leader>e", ":NERDTreeToggle<CR>", { desc = "🔍 Alternar NERDTree" })

      -- Configuraciones básicas de NERDTree
      vim.g.NERDTreeShowHidden = 1      -- Mostrar archivos ocultos
      vim.g.NERDTreeMinimalUI = 1       -- Interfaz limpia (sin ayuda arriba)
      vim.g.NERDTreeDirArrowExpandable = '󰅂'
      vim.g.NERDTreeDirArrowCollapsible = '󰅀'

      -- Configuración para colores en los iconos y nombres (vim-nerdtree-syntax-highlight)
      vim.g.NERDTreeFileExtensionHighlightFullName = 1 -- Resaltar el nombre completo, no solo el icono
      vim.g.NERDTreeExactMatchHighlightFullName = 1
      vim.g.NERDTreePatternMatchHighlightFullName = 1
      vim.g.NERDTreeHighlightCursorline = 1           -- Resaltar la línea bajo el cursor

      -- 0. Personalizar fondo de NERDTree (más grisáceo/arena para Gruvbox)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "nerdtree",
        callback = function()
          -- Color beige oscuro que combina con Gruvbox Light (#f2e5bc)
          vim.api.nvim_set_hl(0, "NERDTreeNormal", { bg = "#f2e5bc", fg = "#3c3836" })
          vim.api.nvim_set_hl(0, "NERDTreeNormalNC", { bg = "#f2e5bc" }) 
          vim.api.nvim_set_hl(0, "NERDTreeEndOfBuffer", { bg = "#f2e5bc", fg = "#f2e5bc" })
        end,
      })

      -- 1. Abrir NERDTree automáticamente al iniciar Neovim
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Solo abrir si no se ha especificado un archivo (abriendo el dashboard)
          -- o si se abre un directorio.
          if vim.fn.argc() == 0 or vim.fn.isdirectory(vim.fn.expand("%")) == 1 then
            vim.cmd("NERDTree")
            vim.cmd("wincmd p") -- Volver al buffer principal (Alpha o el archivo)
          end
        end,
      })

      -- 2. SOLUCIÓN AL DASHBOARD (Alpha): 
      -- Cuando abres un archivo desde NERDTree, este comando asegura que
      -- si el buffer actual es de tipo 'alpha', se elimine para que no quede detrás.
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          -- Si el buffer anterior era alpha, lo cerramos
          local buffers = vim.api.nvim_list_bufs()
          for _, buf in ipairs(buffers) do
            if vim.bo[buf].filetype == "alpha" then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
      })

      -- 3. Cerrar Neovim si NERDTree es la única ventana abierta
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if vim.fn.winnr("$") == 1 and vim.fn.exists("b:NERDTree") == 1 and vim.fn.isdirectory(vim.fn.expand("%")) == 0 then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
}
