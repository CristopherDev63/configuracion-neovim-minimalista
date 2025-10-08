-- lua/plugins/keymaps-cheatsheet.lua
-- Cheat sheet visual de todos los mapeos de teclado

return {
	{
		"nvim-lua/plenary.nvim",
		config = function()
			-- ========== FUNCIÓN PARA MOSTRAR CHEAT SHEET ==========
			local function show_keymaps_cheatsheet()
				local keymaps_content = [[
🎯 NEOVIM - CHEAT SHEET DE MAPEOS
════════════════════════════════════════════════════════════════════════

🚀 EJECUCIÓN DE CÓDIGO (MÁS IMPORTANTE)
┌─────────────────────────────────────────────────────────────────────┐
│ F9              🎯 Ejecutar archivo actual (universal)             │
│ F10             ⚙️ Ejecutar con argumentos                         │
│ Shift+Enter     🚀 Ejecutar archivo (alternativo)                  │
│ <leader>dr      🎯 Debug: Ejecutar archivo                         │
│ <leader>da      ⚙️ Debug: Ejecutar con argumentos                  │
│ <leader>ds      🔍 Debug: Ejecutar selección (visual)              │
│ <leader>dc      🧹 Limpiar terminales de debug                     │
└─────────────────────────────────────────────────────────────────────┘

🐛 DEBUGGING AVANZADO
┌─────────────────────────────────────────────────────────────────────┐
│ Ctrl+C          🐛 Iniciar debugging inteligente                   │
│ F5              ▶️ Continuar debugging                              │
│ F10             ⏭ Step Over (en debug mode)                       │
│ F11             ⏬ Step Into                                        │
│ F12             ⏮ Step Out                                         │
│ <leader>b       🔴 Toggle Breakpoint                              │
│ <leader>B       ❓ Breakpoint Condicional                         │
│ <leader>dt      ⏹ Terminar Debug                                  │
│ <leader>du      🖥️ Toggle Debug UI                                │
│ <leader>dr      📝 Abrir REPL                                     │
│ <leader>dv      🔍 Evaluar expresión                              │
└─────────────────────────────────────────────────────────────────────┘

💾 SISTEMA BÁSICO
┌─────────────────────────────────────────────────────────────────────┐
│ F2              💾 Guardar archivo                                 │
│ F3              ❌ Cerrar ventana                                   │
│ F4              💾❌ Guardar y salir                                │
│ Tab             ➡️ Siguiente buffer                                │
│ Shift+Tab       ⬅️ Buffer anterior / Des-indentar                 │
│ Ctrl+V          📋 Pegar desde portapapeles                        │
│ Ctrl+P          🔍 Buscar archivos (Telescope)                     │
└─────────────────────────────────────────────────────────────────────┘

🔧 REFACTORING (Rope - Para código limpio)
┌─────────────────────────────────────────────────────────────────────┐
│ <leader>rr      🔄 Renombrar variable en proyecto                  │
│ <leader>rf      📁 Extraer función (selección)                     │
│ <leader>rv      📝 Extraer variable                                │
│ <leader>ri      ↩️ Inline variable                                 │
│ <leader>ro      📋 Organizar imports                               │
│ <leader>rk      🔧 Extraer constante                               │
│ <leader>rp      🐛 Agregar print debug                             │
│ <leader>rc      🧹 Limpiar debug prints                            │
└─────────────────────────────────────────────────────────────────────┘

🌐 SERVIDOR WEB (Para desarrollo web)
┌─────────────────────────────────────────────────────────────────────┐
│ <leader>ws      🌐 Iniciar servidor web / Bracey                   │
│ <leader>wl      🔄 Live Server (auto-reload)                       │
│ <leader>wb      🌍 Abrir en navegador                              │
│ <leader>wo      📂 Abrir archivo en navegador                      │
│ <leader>wx      ⏹️ Detener todos los servidores                    │
│ <leader>ps      🐍 Servidor Python HTTP                           │
│ F6              🌐 Servidor web (alternativo)                      │
│ F7              🌍 Abrir en navegador (alternativo)                │
└─────────────────────────────────────────────────────────────────────┘

🔍 NAVEGACIÓN Y LSP
┌─────────────────────────────────────────────────────────────────────┐
│ K               📖 Documentación hover                             │
│ gd              🎯 Ir a definición                                 │
│ gD              📍 Ir a declaración                                │
│ gi              🔗 Ir a implementación                             │
│ Ctrl+K          📋 Signature help                                  │
│ [d              ⬆️ Diagnóstico anterior                            │
│ ]d              ⬇️ Diagnóstico siguiente                           │
└─────────────────────────────────────────────────────────────────────┘

🎨 FORMATEO Y PRODUCTIVIDAD
┌─────────────────────────────────────────────────────────────────────┐
│ <leader>f       🎨 Formatear código                                │
│ Ctrl+J          🎨 Formatear código (alternativo)                  │
│ <leader>rr      🔄 Recargar LSP y Treesitter                      │
│ <leader>ld      🔍 Diagnosticar estado LSP                        │
└─────────────────────────────────────────────────────────────────────┘

🤖 AUTOCOMPLETADO INTELIGENTE (CODEIUM + LSP)
┌─────────────────────────────────────────────────────────────────────┐
│ Tab             ⬇️ Siguiente sugerencia en menú                     │
│ Shift+Tab       ⬆️ Sugerencia anterior en menú                     │
│ Enter           ✅ Aceptar sugerencia seleccionada                 │
│ Ctrl+Space      🔍 Mostrar autocompletado manual                   │
│ Ctrl+E          ❌ Cerrar menú autocompletado                      │
│ Enter           ✅ Confirmar selección                             │
│ Ctrl+J          ⬇️ Siguiente opción (CMP)                          │
│ Ctrl+K          ⬆️ Opción anterior (CMP)                           │
└─────────────────────────────────────────────────────────────────────┘

📝 INDENTACIÓN INTELIGENTE
┌─────────────────────────────────────────────────────────────────────┐
│ Enter           ↩️ Nueva línea con indentación inteligente         │
│ Tab             ➡️ Indentar (al inicio de línea)                  │
│ Shift+Tab       ⬅️ Des-indentar/retroceder nivel                  │
│ Alt+K           🔄 Expandir/saltar snippet                         │
│ Alt+J           ↩️ Saltar atrás en snippet                         │
└─────────────────────────────────────────────────────────────────────┘

🎯 LENGUAJES ESPECÍFICOS
┌─────────────────────────────────────────────────────────────────────┐
│ PHP:                                                                │
│ <leader>dd      🔍 Verificar sintaxis PHP                          │
│ <leader>db      🚀 Ejecutar archivo PHP                            │
│                                                                     │
│ MySQL/SQL:                                                          │
│ <leader>ds      🗃️ Ejecutar consulta MySQL                         │
│                                                                     │
│ Java (si habilitado):                                               │
│ <leader>jo      📋 Organizar imports Java                          │
│ <leader>jr      ☕ Compilar y ejecutar Java                        │
│ <leader>jc      🔧 Compilar Java                                   │
└─────────────────────────────────────────────────────────────────────┘

⭐ COMANDOS ÚTILES
┌─────────────────────────────────────────────────────────────────────┐
│ :Cheat          📋 Mostrar este cheat sheet                        │
│ :DebugHelp      🐛 Ayuda de debugging                              │
│ :RefactorHelp   🔧 Ayuda de refactoring                            │
│ :WebHelp        🌐 Ayuda de servidor web                           │
│ :SmartIndentHelp 📝 Ayuda de indentación                          │
└─────────────────────────────────────────────────────────────────────┘

💡 TIPS IMPORTANTES:
├─ Leader Key = ESPACIO (Space)
├─ F9 es tu mejor amigo (ejecuta cualquier archivo)
├─ Ctrl+C para debugging con breakpoints
├─ <leader>ws para servidor web rápido
├─ <leader>rr para renombrar variables en todo el proyecto
└─ Flechas ↑↓←→ están desactivadas (usa hjkl como un pro)

🚀 FLUJO TÍPICO DE AUTOMATIZACIÓN:
1️⃣ Abre tu script.py
2️⃣ F9 para probar rápido
3️⃣ Ctrl+C para debugging si hay errores
4️⃣ <leader>rr para renombrar variables
5️⃣ <leader>ro para organizar imports
6️⃣ <leader>f para formatear código final

¡CTRL+Q para cerrar este cheat sheet!
]]

				-- Crear buffer temporal
				local buf = vim.api.nvim_create_buf(false, true)
				local lines = vim.split(keymaps_content, "\n")
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				vim.api.nvim_buf_set_option(buf, "filetype", "help")
				vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
				vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
				vim.api.nvim_buf_set_option(buf, "swapfile", false)

				-- Abrir en ventana completa
				vim.cmd("tabnew")
				vim.api.nvim_win_set_buf(0, buf)

				-- Hacer buffer de solo lectura
				vim.api.nvim_buf_set_option(buf, "modifiable", false)
				vim.api.nvim_buf_set_option(buf, "readonly", true)

				-- Mapeo para cerrar con q o Ctrl+Q
				vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(buf, "n", "<C-q>", ":q<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q<CR>", { noremap = true, silent = true })

				-- Título del buffer
				vim.api.nvim_buf_set_name(buf, "🎯 Neovim Cheat Sheet")

				print("📋 Cheat Sheet abierto. Presiona 'q' o Ctrl+Q para cerrar")
			end

			-- ========== FUNCIÓN CHEAT SHEET COMPACTO ==========
			local function show_compact_cheatsheet()
				local compact_content = [[
🎯 MAPEOS ESENCIALES (Los más usados):

🔥 EJECUTAR CÓDIGO:
F9 = Ejecutar archivo | F10 = Con argumentos | Ctrl+C = Debug

💾 BÁSICOS:
F2 = Guardar | F3 = Cerrar | F4 = Guardar+Cerrar | Tab = Buffer+/-

🔧 REFACTORING:
<leader>rr = Renombrar | <leader>rf = Extraer función | <leader>ro = Organizar

🌐 WEB:
<leader>ws = Servidor | <leader>wb = Navegador | F6/F7 = Alternativos

🔍 NAVEGACIÓN:
K = Docs | gd = Definición | Ctrl+P = Buscar archivos

⚡ PRODUCTIVIDAD:
<leader>f = Formatear | Ctrl+G = IA | Ctrl+Space = Autocompletado

Leader Key = ESPACIO | :Cheat = Cheat sheet completo
]]
				print(compact_content)
			end

			-- ========== FUNCIÓN MAPEOS POR CATEGORÍA ==========
			local function show_category_help(category)
				local categories = {
					ejecutar = [[
🚀 MAPEOS DE EJECUCIÓN:
F9              - Ejecutar archivo actual
F10             - Ejecutar con argumentos  
Shift+Enter     - Ejecutar archivo (alternativo)
<leader>dr      - Debug: Ejecutar archivo
<leader>da      - Debug: Ejecutar con argumentos
<leader>ds      - Debug: Ejecutar selección (visual)
<leader>dc      - Limpiar terminales de debug
]],
					debug = [[
🐛 MAPEOS DE DEBUGGING:
Ctrl+C          - Iniciar debugging inteligente
F5              - Continuar debugging
F10             - Step Over (en debug mode)
F11             - Step Into
F12             - Step Out
<leader>b       - Toggle Breakpoint
<leader>B       - Breakpoint Condicional  
<leader>dt      - Terminar Debug
<leader>du      - Toggle Debug UI
]],
					refactor = [[
🔧 MAPEOS DE REFACTORING:
<leader>rr      - Renombrar variable en proyecto
<leader>rf      - Extraer función (selección)
<leader>rv      - Extraer variable
<leader>ri      - Inline variable
<leader>ro      - Organizar imports
<leader>rk      - Extraer constante
<leader>rp      - Agregar print debug
<leader>rc      - Limpiar debug prints
]],
					web = [[
🌐 MAPEOS DE SERVIDOR WEB:
<leader>ws      - Iniciar servidor web / Bracey
<leader>wl      - Live Server (auto-reload)
<leader>wb      - Abrir en navegador
<leader>wo      - Abrir archivo en navegador
<leader>wx      - Detener todos los servidores
<leader>ps      - Servidor Python HTTP
F6              - Servidor web (alternativo)
F7              - Abrir en navegador (alternativo)
]],
					basico = [[
💾 MAPEOS BÁSICOS:
F2              - Guardar archivo
F3              - Cerrar ventana
F4              - Guardar y salir
Tab             - Siguiente buffer
Shift+Tab       - Buffer anterior / Des-indentar
Ctrl+V          - Pegar desde portapapeles
Ctrl+P          - Buscar archivos (Telescope)
]],
				}

				if categories[category] then
					print(categories[category])
				else
					print("Categorías disponibles: ejecutar, debug, refactor, web, basico")
				end
			end

			-- ========== COMANDOS VIM ==========

			-- Comando principal para cheat sheet completo
			vim.api.nvim_create_user_command("Cheat", show_keymaps_cheatsheet, {
				desc = "Mostrar cheat sheet completo de mapeos",
			})

			-- Comando para cheat sheet compacto
			vim.api.nvim_create_user_command("CheatCompact", show_compact_cheatsheet, {
				desc = "Mostrar mapeos esenciales (compacto)",
			})

			-- Comando para mostrar por categorías
			vim.api.nvim_create_user_command("CheatCategory", function(opts)
				show_category_help(opts.args)
			end, {
				nargs = 1,
				complete = function()
					return { "ejecutar", "debug", "refactor", "web", "basico" }
				end,
				desc = "Mostrar mapeos por categoría",
			})

			-- Mapeo rápido para cheat sheet
			vim.keymap.set("n", "<leader>?", show_keymaps_cheatsheet, {
				desc = "📋 Mostrar cheat sheet de mapeos",
				noremap = true,
				silent = true,
			})

			-- Mapeo para cheat compacto
			vim.keymap.set("n", "<leader><leader>?", show_compact_cheatsheet, {
				desc = "📋 Cheat sheet compacto",
				noremap = true,
				silent = true,
			})

			-- ========== AUTO-COMANDO AL INICIAR NEOVIM (DESACTIVADO) ==========

			-- Variable para controlar si mostrar al inicio (DESACTIVADO por defecto)
			vim.g.show_cheatsheet_on_start = false

			-- Mensaje simple al iniciar (solo si no hay archivos)
			-- vim.api.nvim_create_autocmd("VimEnter", {
			-- 	callback = function()
			-- 		-- Solo mostrar mensaje simple si no se abrió con archivos
			-- 		if #vim.fn.argv() == 0 then
			-- 			vim.defer_fn(function()
			-- 				print(
			-- 					"✅ Neovim configurado listo. Usa :Cheat para ver mapeos o F9 para ejecutar archivos"
			-- 				)
			-- 			end, 100)
			-- 		end
			-- 	end,
			-- 	desc = "Mensaje simple al iniciar Neovim",
			-- })

			-- Comando para toggle del cheat sheet al inicio
			vim.api.nvim_create_user_command("CheatStartToggle", function()
				vim.g.show_cheatsheet_on_start = not vim.g.show_cheatsheet_on_start
				local status = vim.g.show_cheatsheet_on_start and "ACTIVADO" or "DESACTIVADO"
				print("📋 Cheat sheet al inicio: " .. status)
			end, { desc = "Toggle mostrar cheat sheet al iniciar" })

			-- print("✅ Cheat Sheet configurado. Usa :Cheat o <leader>? para verlo")
		end,
	},
}
