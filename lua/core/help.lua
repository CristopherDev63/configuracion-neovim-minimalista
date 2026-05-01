local M = {}

function M.show_help()
    -- El contenido del texto de ayuda
    local help_text = {
        "# 🛠️  GUÍA RÁPIDA DE NEOVIM (Tu Configuración)",
        "",
        "## 💾 Archivos (Oil.nvim)",
        "- `-`        : Abrir carpeta actual (Editar como texto)",
        "- `<leader>n`: Explorador flotante",
        "- `<C-p>`    : Buscar archivos por nombre",
        "",
        "## 📊 Datos y CSV",
        "- `<leader>cv`: Ver CSV como Excel (Alinear columnas)",
        "- `<Tab>`    : Saltar a siguiente celda (en modo CSV)",
        "",
        "## 🔍 Buscar y Reemplazar (Spectre)",
        "- `<leader>ss`: Abrir panel de búsqueda global",
        "- `<leader>sw`: Buscar palabra bajo cursor en todo el proyecto",
        "",
        "## 🚀 Ejecución de Código",
        "- <F9>       : Ejecutar archivo actual (Java, Python, JS, etc.)",
        "",
        "## 🧠 Inteligencia (LSP)",
        "- `gd`         : Ir a definición",
        "- `K`          : Ver documentación (Hover)",
        "- <C-J>      : Formatear código (Prettier/Java)",
        "- `<leader>ca`: Acciones rápidas (Code Actions)",
        "- `<leader>xx`: Ver panel de errores",
        "",
        "## 🤖 IA Supermaven (tipo Cursor/Copilot)",
        "- `<M-l>` (Alt+l) : Aceptar sugerencia completa",
        "- `<M-c>` (Alt+c) : Cancelar sugerencia",
        "- `<M-]>` / `<M-[>`: Siguiente/anterior sugerencia",
        "",
        "## ✍️  Edición Avanzada (Multi-cursor)",
        "- `<leader>d`: Seleccionar siguiente (Espacio+D)",
        "- `Ctrl+s`   : Saltar palabra actual (Ctrl+S)",
        "- `<leader>x`: Añadir cursor manual (Donde estás)",
        "- `<leader>q`: Quitar cursor actual",
        "- `<leader>A`: Seleccionar TODO en el archivo",
        "- `<leader>c`: Duplicar cursores (desde bloque)",
        "",
        "## 🪄 Trucos Neovim",
        "- `gcc`      : Comentar línea",
        "- `ysiw\"`    : Rodear palabra con comillas (Surround)",
        "- `ds\"`      : Borrar comillas circundantes",
        "- `qa` / `q` : Grabar/Parar Macro",
        "- `@a`       : Ejecutar Macro",
        "",
        "## 🌐 Web",
        "- `<F7>`       : Abrir en Chrome",
        "- `<C-e>`      : Expandir Emmet (HTML)",
        "",
        "---",
        "ℹ️  Presiona 'q' o 'Esc' para cerrar esta ventana"
    }

    -- Crear un buffer nuevo (no listado en buffers, scratch)
    local buf = vim.api.nvim_create_buf(false, true)

    -- Poner el texto en el buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, help_text)

    -- Calcular dimensiones de la ventana
    local width = 60
    local height = #help_text + 2
    local ui = vim.api.nvim_list_uis()[1]
    local row = (ui.height - height) / 2
    local col = (ui.width - width) / 2

    local opts = {
        style = "minimal",
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        border = "rounded",
        title = " Ayuda ",
        title_pos = "center"
    }

    -- Abrir la ventana flotante
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Configurar opciones del buffer/ventana
    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "markdown" -- Para que se vea bonito con colores
    vim.wo[win].wrap = false

    -- Mapeos para cerrar la ventana
    local close_keys = { "q", "<Esc>", "<CR>" }
    for _, key in ipairs(close_keys) do
        vim.keymap.set("n", key, function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end, { buffer = buf, nowait = true, silent = true })
    end
end

-- Crear el comando de usuario :Ayuda
vim.api.nvim_create_user_command("Ayuda", M.show_help, {})

return M
