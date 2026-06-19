return {
  {
    "preservim/nerdtree",
    dependencies = {
      "ryanoasis/vim-devicons", -- Soporte para iconos de NerdFont
      "tiagofumo/vim-nerdtree-syntax-highlight", -- Resaltado de sintaxis (colores) en NERDTree
    },
    cmd = { "NERDTreeToggle", "NERDTree" },
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

      -- 0. Personalizar fondo de NERDTree (más oscuro para Flexoki Dark)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "nerdtree",
        callback = function()
          -- Fondo transparente para NERDTree
          vim.api.nvim_set_hl(0, "NERDTreeNormal", { bg = "NONE", fg = "#cecece" })
          vim.api.nvim_set_hl(0, "NERDTreeNormalNC", { bg = "NONE" }) 
          vim.api.nvim_set_hl(0, "NERDTreeEndOfBuffer", { bg = "NONE", fg = "NONE" })
        end,
      })

      -- 1. SOLUCIÓN AL DASHBOARD (Alpha): 
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
