# 🎯 Neovim - Atajos de Teclado y Funcionalidades

## 🚀 Ejecución Universal de Código

| Atajo | Descripción | Archivo |
|-------|-------------|---------|
| `F9` | Ejecutar archivo actual (Python, JS, PHP, Bash, etc.) | `simple-universal-debug.lua` |
| `F10` | Ejecutar archivo con argumentos | `simple-universal-debug.lua` |
| `Shift+Enter` | Ejecutar archivo (alternativo) | `simple-universal-debug.lua` |
| `<leader>dr` | Debug: Ejecutar archivo | `simple-universal-debug.lua` |
| `<leader>da` | Debug: Ejecutar con argumentos | `simple-universal-debug.lua` |
| `<leader>ds` | Debug: Ejecutar selección (modo visual) | `simple-universal-debug.lua` |
| `<leader>dc` | Limpiar terminales de debug | `simple-universal-debug.lua` |

**Lenguajes soportados**: Python, JavaScript, TypeScript, PHP, Lua, Bash, Java, C, C++, Go, Rust, Ruby

## 🐛 Sistema de Debug Avanzado

| Atajo | Descripción | Archivo |
|-------|-------------|---------|
| `Ctrl+C` | Iniciar debugging inteligente | `debug.lua` |
| `F5` | Continuar debugging | `debug.lua` |
| `F10` | Step Over (en modo debug) | `debug.lua` |
| `F11` | Step Into | `debug.lua` |
| `F12` | Step Out | `debug.lua` |
| `<leader>b` | Toggle Breakpoint | `debug.lua` |
| `<leader>B` | Breakpoint Condicional | `debug.lua` |
| `<leader>dt` | Terminar Debug | `debug.lua` |
| `<leader>du` | Toggle Debug UI | `debug.lua` |
| `<leader>dr` | Abrir REPL | `debug.lua` |
| `<leader>dv` | Evaluar expresión | `debug.lua` |

**Características**:
- Auto-instalación de debugpy para Python
- UI visual similar a VSCode
- Breakpoints automáticos si no existen
- Debugging de Python, JavaScript, PHP, Bash

## 💾 Sistema Básico

| Atajo | Descripción | Archivo |
|-------|-------------|---------|
| `F2` | Guardar archivo | `keymaps.lua` |
| `F3` | Cerrar ventana | `keymaps.lua` |
| `F4` | Guardar y salir | `keymaps.lua` |
| `Tab` | Siguiente buffer | `keymaps.lua` |
| `Shift+Tab` | Buffer anterior | `keymaps.lua` |
| `Ctrl+V` | Pegar desde portapapeles | `keymaps.lua` |
| `Ctrl+P` | Buscar archivos (Telescope) | `telescope.lua` |

## 🔧 Refactoring Avanzado (Como PyCharm)

| Atajo | Descripción | Archivo |
|-------|-------------|---------|
| `<leader>rr` | Renombrar variable en todo el proyecto | `rope-refactoring.lua` |
| `<leader>rf` | Extraer función (selección) | `rope-refactoring.lua` |
| `<leader>rv` | Extraer variable | `rope-refactoring.lua` |
| `<leader>ri` | Inline variable | `rope-refactoring.lua` |
| `<leader>ro` | Organizar imports | `rope-refactoring.lua` |
| `<leader>rk` | Extraer constante | `rope-refactoring.lua` |
| `<leader>rp` | Agregar print debug | `rope-refactoring.lua` |
| `<leader>rc` | Limpiar debug prints | `rope-refactoring.lua` |

**Tecnologías**:
- **Rope** para Python (refactoring profesional)
- **refactoring.nvim** para múltiples lenguajes
- Integración con LSP para renombrado inteligente

## 🌐 Desarrollo Web

| Atajo | Descripción | Archivo |
|-------|-------------|---------|
| `<leader>ws` | Iniciar servidor web / Bracey | `live-server.lua` |
| `<leader>wl` | Live Server (auto-reload) | `live-server.lua` |
| `<leader>wb` | Abrir en navegador | `live-server.lua` |
| `<leader>wo` | Abrir archivo en navegador | `live-server.lua` |
| `<leader>wx` | Detener todos los servidores | `live-server.lua` |
| `<leader>ps` | Servidor Python HTTP | `live-server.lua` |
| `F6` | Servidor web (alternativo) | `live-server.lua` |
| `F7` | Abrir en navegador (alternativo) | `live-server.lua` |

**Características**:
- **Bracey.vim** para live-reload automático
- Servidor Python HTTP integrado
- Auto-apertura en navegador (Firefox, Chrome, Chromium)
- Snippet HTML5 automático

## 🔍 Navegación y LSP

| Atajo | Descripción | Archivo |
|-------|-------------|---------|
| `K` | Documentación hover | `lsp.lua` |
| `gD` | Ir a declaración | `lsp.lua` |
| `gd` | Ir a definición | `lsp.lua` |
| `gi` | Ir a implementación | `lsp.lua` |
| `Ctrl+K` | Signature help | `lsp.lua` |
| `[d` | Diagnóstico anterior | `autocommands.lua` |
| `]d` | Diagnóstico siguiente | `autocommands.lua` |
| `<leader>ld` | Diagnosticar estado LSP | `keymaps.lua` |
| `<leader>rr` | Recargar LSP y Treesitter | `keymaps.lua` |

**LSP Configurado**:
- **Python**: Pyright
- **PHP**: Intelephense
- **JavaScript/TypeScript**: ts_ls
- **Bash**: bashls
- **Lua**: lua_ls

## 🎨 Formateo y Productividad

| Atajo | Descripción | Archivo |
|-------|-------------|---------|
| `<leader>f` | Formatear código | `autocommands.lua` |
| `Ctrl+J` | Formatear código (alternativo) | `keymaps.lua` |

**Formateadores**:
- **Python**: autopep8/black
- **JavaScript/TypeScript**: prettier
- **PHP**: php_cs_fixer
- **Bash**: shfmt
- **Lua**: stylua

## 🤖 IA y Autocompletado

| Atajo | Descripción | Archivo |
|-------|-------------|---------|
| `Ctrl+G` | Forzar sugerencia Gemini / Aceptar | `gemini-autocomplete.lua` |
| `Ctrl+E` | Rechazar sugerencia IA | `cmp.lua` |
| `Tab` | Aceptar sugerencia o siguiente | `cmp.lua` |
| `Shift+Tab` | Opción anterior | `cmp.lua` |
| `Ctrl+Space` | Activar autocompletado | `cmp.lua` |
| `Enter` | Confirmar selección | `cmp.lua` |

**Características**:
- **Gemini AI** integrado con API key
- **nvim-cmp** para autocompletado inteligente
- **LuaSnip** para snippets
- Rate limiting y configuración avanzada

## 📝 Indentación Inteligente

| Atajo | Descripción | Archivo |
|-------|-------------|---------|
| `Enter` | Nueva línea con indentación inteligente | `smart-indentation.lua` |
| `Tab` | Indentar (al inicio de línea) | `smart-indentation.lua` |
| `Shift+Tab` | Des-indentar/retroceder nivel | `smart-indentation.lua` |

**Detección Automática**:
- **Python**: `def`, `class`, `if`, `for`, `while`, `try`, `:`
- **JavaScript**: `function`, `if`, `for`, `{`
- **PHP**: `function`, `if`, `foreach`, `{`
- **CSS**: selectores, `@media`, `{`
- **HTML**: tags `>`
- **Bash**: `if`, `for`, `then`, `do`

## 🎯 Lenguajes Específicos

### Python
| Atajo | Descripción |
|-------|-------------|
| `<leader>dd` | Verificar sintaxis PHP |
| `<leader>db` | Ejecutar archivo PHP |

### MySQL/SQL
| Atajo | Descripción |
|-------|-------------|
| `<leader>ds` | Ejecutar consulta MySQL |

### Java (si habilitado)
| Atajo | Descripción |
|-------|-------------|
| `<leader>jo` | Organizar imports Java |
| `<leader>jr` | Compilar y ejecutar Java |
| `<leader>jc` | Compilar Java |

## ⭐ Comandos Útiles

| Comando | Descripción | Archivo |
|---------|-------------|---------|
| `:Cheat` | Mostrar cheat sheet completo | `keymaps-cheatsheet.lua` |
| `:CheatCompact` | Cheat sheet compacto | `keymaps-cheatsheet.lua` |
| `:DebugHelp` | Ayuda de debugging | `simple-universal-debug.lua` |
| `:RefactorHelp` | Ayuda de refactoring | `rope-refactoring.lua` |
| `:WebHelp` | Ayuda de servidor web | `live-server.lua` |
| `:SmartIndentHelp` | Ayuda de indentación | `smart-indentation.lua` |
| `:GeminiStatus` | Estado de Gemini IA | `gemini-autocomplete.lua` |
| `:GeminiToggle` | Toggle Gemini IA | `gemini-autocomplete.lua` |

## 🎨 Tema y UI

**Tema**: Sonokai Andromeda con transparencia total
- **Archivo**: `sonokai-theme.lua`
- **Lualine**: Barra de estado personalizada con ícono de Apple
- **Mini.indentscope**: Guías de indentación
- **nvim-autopairs**: Auto-pares de caracteres

## 🔧 Configuración

| Archivo | Propósito |
|---------|-----------|
| `init.lua` | Punto de entrada, carga lazy.nvim |
| `core/options.lua` | Configuración básica de Neovim |
| `core/keymaps.lua` | Mapeos de teclado fundamentales |
| `core/autocommands.lua` | Auto-comandos y LSP |
| `lazy-lock.json` | Versiones bloqueadas de plugins |

## 💡 Información Importante

- **Leader Key**: `Espacio`
- **Flechas direccionales**: Desactivadas (usar hjkl)
- **Indentación**: Automática según tipo de archivo
- **Transparencia**: Total en terminal
- **LSP**: Auto-reparación si falla

## 🚀 Flujo de Trabajo Típico

1. **Escribir código** en cualquier lenguaje soportado
2. **F9** para ejecutar y probar rápidamente
3. **Ctrl+C** para debugging si hay errores
4. **`<leader>rr`** para renombrar variables
5. **`<leader>ro`** para organizar imports
6. **`<leader>f`** para formatear código final
7. **`<leader>ws`** para servidor web si es necesario

## 📦 Plugins Principales

- **lazy.nvim**: Gestor de plugins
- **nvim-lspconfig**: Configuración LSP
- **nvim-cmp**: Autocompletado
- **nvim-dap**: Debugging
- **telescope.nvim**: Búsqueda de archivos
- **nvim-treesitter**: Sintaxis highlighting
- **rope**: Refactoring Python
- **bracey.vim**: Live server web
- **sonokai**: Tema
- **lualine.nvim**: Barra de estado
