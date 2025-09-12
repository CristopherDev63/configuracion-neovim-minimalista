-- Función para verificar y reparar automáticamente LSP
local function check_and_repair_lsp()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo.filetype
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

    if #clients == 0 then
        vim.defer_fn(function()
            if filetype == "python" then
                require("lspconfig").pyright.launch()
                print("↪ LSP reactivado automáticamente para Python")
            elseif filetype == "sh" or filetype == "bash" then
                require("lspconfig").bashls.launch()
                print("↪ LSP reactivado automáticamente para Bash")
            elseif filetype == "php" then
                require("lspconfig").intelephense.launch()
                print("↪ LSP reactivado automáticamente para PHP")
            end
        end, 200)
    end
end

-- Auto-comandos para manejar problemas de LSP y Treesitter
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "sh", "bash", "php" },
    callback = function()
        local filetype = vim.bo.filetype

        -- Verificar y forzar LSP si no está activo
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then
            vim.defer_fn(function()
                if filetype == "python" then
                    require("lspconfig").pyright.launch()
                elseif filetype == "sh" or filetype == "bash" then
                    require("lspconfig").bashls.launch()
                elseif filetype == "php" then
                    require("lspconfig").intelephense.launch()
                end
            end, 100)
        end

        -- Verificar y forzar Treesitter si no está activo
        if not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
            vim.defer_fn(function()
                vim.treesitter.start()
            end, 150)
        end
    end,
    desc = "Asegurar LSP y Treesitter para Python, Bash y PHP",
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.py", "*.sh", "*.bash", "*.php" },
    callback = function()
        local filetype = vim.bo.filetype

        -- Verificación adicional al entrar al buffer
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then
            vim.defer_fn(function()
                if filetype == "python" then
                    require("lspconfig").pyright.launch()
                elseif filetype == "sh" or filetype == "bash" then
                    require("lspconfig").bashls.launch()
                elseif filetype == "php" then
                    require("lspconfig").intelephense.launch()
                end
            end, 50)
        end
    end,
    desc = "Verificar LSP al entrar a buffer Python, Bash o PHP",
})

-- Configuración LSP
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local opts = { buffer = args.buf, silent = true }

        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

        if client.supports_method("textDocument/hover") then
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        end

        if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
        end
    end,
})

-- Verificar periódicamente (cada 2 segundos cuando está en modo normal)
vim.api.nvim_create_autocmd("CursorHold", {
    callback = check_and_repair_lsp,
    desc = "Verificar estado LSP periódicamente",
})

-- Configuración específica para archivos PHP
vim.api.nvim_create_autocmd("FileType", {
    pattern = "php",
    callback = function()
        -- Configuración de indentación para PHP
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true

        -- Atajos específicos para PHP
        vim.keymap.set("n", "<leader>dd", ":!php -l %<CR>", { buffer = true, desc = "Verificar sintaxis PHP" })
        vim.keymap.set("n", "<leader>db", ":!php -f %<CR>", { buffer = true, desc = "Ejecutar archivo PHP" })
    end,
})

-- Configuración específica para archivos SQL
vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql",
    callback = function()
        -- Configuración para SQL
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true

        -- Atajos específicos para SQL
        vim.keymap.set(
            "n",
            "<leader>ds",
            ":!mysql -u root -p < %<CR>",
            { buffer = true, desc = "Ejecutar consulta MySQL" }
        )
    end,
})

-- AGREGA ESTO AL FINAL de tu archivo lua/core/autocommands.lua existente:

-- ========== CONFIGURACIÓN ESPECÍFICA PARA HTML/CSS ==========

-- Configuración específica para archivos HTML
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "htm" },
    callback = function()
        -- Configuración de indentación para HTML
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true

        -- Atajos específicos para HTML
        vim.keymap.set("i", ";;", ": ;<Left>", { buffer = true, desc = "CSS: Propiedad rápida" })
        vim.keymap.set("i", "{{", " {<CR>}<Up><End>", { buffer = true, desc = "CSS: Bloque rápido" })

        print("🌐 HTML configurado - Tab funciona normal, Ctrl+j/k para autocompletar")
    end,
})

-- Configuración específica para archivos CSS
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "css", "scss", "sass", "less" },
    callback = function()
        -- Configuración de indentación para CSS
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.expandtab = true

        -- Atajos específicos para CSS
        vim.keymap.set("i", ";;", ": ;<Left>", { buffer = true, desc = "CSS: Propiedad rápida" })
        vim.keymap.set("i", "{{", " {<CR>}<Up><End>", { buffer = true, desc = "CSS: Bloque rápido" })

        -- Variables CSS rápidas
        vim.keymap.set("n", "<leader>cv", function()
            local var_name = vim.fn.input("Nombre de variable: ")
            local var_value = vim.fn.input("Valor: ")
            if var_name ~= "" and var_value ~= "" then
                vim.api.nvim_put({ "--" .. var_name .. ": " .. var_value .. ";" }, "l", true, true)
            end
        end, { buffer = true, desc = "Crear variable CSS" })

        print("🎨 CSS configurado - Tab normal, ;; para propiedades, {{ para bloques")
    end,
})

-- Comando de ayuda para los nuevos atajos
vim.api.nvim_create_user_command("AutocompleteHelp", function()
    local help_text = [[
⌨️ AUTOCOMPLETADO SIN CONFLICTOS:

📋 NAVEGACIÓN AUTOCOMPLETADO:
  Ctrl+Space  - Activar autocompletado
  Ctrl+j      - Siguiente opción
  Ctrl+k      - Opción anterior
  Enter       - Confirmar selección

✨ TAB FUNCIONA NORMAL:
  Tab         - Indentación normal ✅
  Shift+Tab   - Des-indentación ✅

🔧 SNIPPETS:
  Tab         - Saltar al siguiente campo (solo en snippets)
  Alt+k       - Expandir/saltar snippet
  Alt+j       - Saltar atrás en snippet

🌐 HTML/CSS:
  ;;          - : ; (cursor en medio)
  {{          - { } (bloque CSS)
  <leader>cv  - Crear variable CSS

💡 CODEIUM (IA):
  Ctrl+g      - Aceptar sugerencia
  Ctrl+;      - Siguiente sugerencia
  Ctrl+,      - Sugerencia anterior
  Ctrl+x      - Limpiar sugerencias
]]

    print(help_text)
end, { desc = "Mostrar ayuda de autocompletado" })

print("✅ Configuración HTML/CSS agregada a autocommands")
