local M = {}

function M.show_help()
    -- El contenido del texto de ayuda
    local help_text = {
        "# 🛠️  GUÍA RÁPIDA - VSCode Automation Mode",
        "",
        "## 📂 Archivos y Navegación",
        "- `-`         : Abrir carpeta actual (oil.nvim)",
        "- `<leader>n` : Explorador flotante de archivos",
        "- `<C-p>`     : Buscar archivos (Telescope)",
        "- `<Tab>`     : Siguiente buffer/pestaña",
        "- `<M-Tab>`   : Buffer anterior",
        "",
        "## 🐍 Python Automation (Ejecución rápida)",
        "- `<F9>`      : Ejecutar archivo actual (python3 ...)",
        "- `<leader>r` : Ejecutar en terminal flotante (toggleterm)",
        "",
        "## 🐛 Debugging (VSCode-like)",
        "- `<F5>`      : Continuar / Iniciar debug",
        "- `<F10>`     : Step over (saltar línea)",
        "- `<F11>`     : Step into (entrar a función)",
        "- `<F12>`     : Step out (salir de función)",
        "- `<leader>db`: Poner/quitar breakpoint",
        "- `<leader>dc`: Continuar ejecución",
        "- `<leader>du`: Abrir/cerrar panel DAP UI",
        "- `<leader>dr`: Abrir REPL de debugging",
        "- `<leader>di`: Inspeccionar variable (hover)",
        "",
        "## 🔍 Problemas y Diagnósticos",
        "- `<leader>xx`: Ver todos los problemas (Trouble)",
        "- `<leader>xw`: Problemas del archivo actual",
        "- `]e` / `[e`  : Ir al siguiente/anterior error",
        "- `[d` / `]d` : Ir al diagnóstico anterior/siguiente",
        "",
        "## 🧠 LSP (IntelliSense)",
        "- `gd`         : Ir a definición",
        "- `K`          : Ver documentación (hover)",
        "- `<C-J>`      : Formatear código",
        "- `<leader>ca`: Code actions (arreglos rápidos)",
        "",
        "## 🤖 IA Avante (asistente tipo Cursor)",
        "- `<leader>aa`: Abrir/cerrar sidebar",
        "- `<leader>an`: Nuevo chat",
        "- `<leader>ae`: Editar la selección",
        "- `<leader>af`: Enfocar sidebar",
        "- `<leader>ar`: Refrescar sidebar",
        "- `<leader>aS`: Detener generación",
        "- `A` / `a`    : Aplicar todo / solo lo del cursor",
        "- `co` / `ct`  : Diff: versión actual (co) / de la IA (ct)",
        "- `ca` / `cb`  : Diff: aceptar todo de la IA / ambas",
        "- `]x` / `[x`  : Diff: siguiente/anterior conflicto",
        "- `<S-Tab>`    : Expandir herramienta/edición del agente",
        "- `:AvanteAsk` : Preguntar sobre el archivo actual",
        "- `:AvanteChat`: Chatear con el código",
        "- El agente PIDE PERMISO antes de editar cada archivo",
        "- El 'thinking' está oculto (no molesta, sigue en el historial)",
        "",
        "## 🔌 IA OpenCode",
        "- `<C-a>`      : Preguntar a opencode (@this)",
        "- `<C-x>`      : Ejecutar acción de opencode",
        "- `<C-.>`      : Abrir/cerrar opencode",
        "",
        "## ✍️  Edición Avanzada",
        "- `<leader>d` : Seleccionar siguiente ocurrencia",
        "- `gcc`       : Comentar/descomentar línea",
        "- `ysiw\"`     : Rodear palabra con comillas",
        "- `ds\"`       : Borrar comillas circundantes",
        "",
        "## 💻 Terminal Integrada",
        "- `<C-\\>`    : Abrir/cerrar terminal flotante",
        "- `<leader>i` : Abrir REPL de Python interactivo",
        "",
        "## 🔧 Git",
        "- `<leader>gs`: Status de git (fugitive)",
        "- `]c` / `[c` : Siguiente/anterior cambio (gitsigns)",
        "- `<leader>gp`: Preview del cambio (gitsigns)",
        "- `<leader>gd`: Diff contra HEAD (gitsigns)",
        "",
        "## 📊 Datos y CSV",
        "- `<leader>cv`: Ver CSV como tabla (alinear columnas)",
        "",
        "## 🔍 Buscar y Reemplazar",
        "- `<leader>ss`: Búsqueda global (Spectre)",
        "- `<leader>sw`: Buscar palabra bajo cursor",
        "",
        "## ⚡ Rendimiento (MacBook Pro 2015)",
        "- `:CleanBuffers` : Cerrar buffers inactivos (libera RAM)",
        "- `:LspKillAll`   : Detener LSP (para enfriar el sistema)",
        "- Avante/opencode cargan solo al usarlos (lazy, no afectan el arranque)",
        "",
        "---",
        "ℹ️  Presiona 'q' o 'Esc' para cerrar esta ventana"
    }

    -- Crear un buffer nuevo (no listado en buffers, scratch)
    local buf = vim.api.nvim_create_buf(false, true)

    -- Poner el texto en el buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, help_text)

    -- Calcular dimensiones de la ventana (máx 90% del alto de pantalla)
    local ui = vim.api.nvim_list_uis()[1] or { height = vim.o.lines, width = vim.o.columns }
    local width = 60
    local height = math.min(#help_text + 2, math.floor(ui.height * 0.9))
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
