# Neovim v2 Minimal — Teenage Engineering Style

Configuración minimalista de Neovim optimizada para MacBook Pro 2015.
Estética retro: ámbar, mostaza, gris cálido sobre fondo oscuro.
Integración con IA vía OpenCode.

## Estructura

```
~/.config/nvim/
├── init.lua              # Punto de entrada
├── lua/
│   ├── core/
│   │   ├── options.lua   # Opciones de Neovim
│   │   ├── keymaps.lua   # Atajos de teclado
│   │   ├── autocommands.lua  # Autocomandos
│   │   └── performance.lua   # Optimización Mac 2015
│   └── plugins/
│       ├── theme.lua     # Tema Teenage Engineering
│       ├── lualine.lua   # Barra de estado
│       ├── telescope.lua # Búsquedas
│       ├── nvim-tree.lua # Explorador de archivos
│       ├── treesitter.lua # Resaltado de sintaxis
│       ├── lsp.lua       # Mason + LSPconfig
│       ├── cmp.lua       # Autocompletado
│       ├── gitsigns.lua  # Indicadores Git
│       ├── which-key.lua # Atajos disponibles
│       ├── marks.lua     # Marcas visuales
│       ├── toggleterm.lua # Terminal
│       └── opencode.lua  # Integración IA
```

## Atajos de teclado (Leader = espacio)

### Búsqueda
| Atajo | Acción |
|-------|--------|
| `<leader>ff` | Buscar archivos |
| `<leader>fg` | Buscar texto (grep) |
| `<leader>fb` | Buscar buffers |
| `<leader>fh` | Buscar ayuda |
| `<leader>fr` | Archivos recientes |

### IA (OpenCode)
| Atajo | Acción |
|-------|--------|
| `<leader>ic` | Abrir/cerrar chat con IA |
| `<leader>ia` | Enviar selección a IA |
| `<leader>ie` | Explicar código |
| `<leader>ir` | Refactorizar |
| `<leader>id` | Documentar |
| `<leader>it` | Generar tests |
| `<leader>if` | Arreglar errores |

### Git
| Atajo | Acción |
|-------|--------|
| `<leader>gs` | Siguiente cambio |
| `<leader>gp` | Cambio anterior |
| `<leader>gd` | Previsualizar cambio |
| `<leader>gr` | Restablecer cambio |

### Archivos
| Atajo | Acción |
|-------|--------|
| `<leader>e` | Explorador de archivos |
| `<leader>w` | Guardar |
| `<leader>q` | Cerrar buffer |
| `<leader>t` | Terminal flotante |

### General
| Atajo | Acción |
|-------|--------|
| `<leader>r` | Recargar configuración |
| `<leader>cp` | Copiar ruta del archivo |
| `Esc` | Limpiar búsqueda |

### LSP (se activan con LSP cargado)
| Atajo | Acción |
|-------|--------|
| `gd` | Ir a definición |
| `gr` | Referencias |
| `K` | Documentación |
| `<leader>rn` | Renombrar |
| `<leader>ca` | Acciones de código |

## Vibe coding con IA

### Requisitos
1. Instalar OpenCode: `curl -fsSL https://opencode.ai/install | bash`
2. Configurar modelos gratuitos en `~/.config/opencode/opencode.json`:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "openrouter/z-ai/glm-5.2"
}
```

### Flujo de trabajo
1. Selecciona código en modo visual
2. Presiona `<leader>ia` y escribe qué quieres que haga la IA
3. La IA responde y puede editar el código directamente
4. Revisa los cambios y guarda con `<leader>w`

### Modelos gratuitos (via OpenRouter)
- `openrouter/z-ai/glm-5.2` — GLM 5.2 (prioridad 1)
- `openrouter/qwen/qwen-2.5-coder-32b-instruct` — Qwen (prioridad 2)
- `opencode/big-pickle` — Big Pickle (prioridad 3)

## Instalación

```bash
# Clonar o copiar la configuración
git clone <repo> ~/.config/nvim

# Abrir Neovim (instala plugins automáticamente)
nvim

# Esperar a que lazy.nvim instale todo
# Listo
```

## Soporte de lenguajes

- **JavaScript/TypeScript** — via ts_ls
- **Python** — via pyright
- **HTML/CSS/JSON** — via LSP nativo
- **Lua** — via lua_ls

## Optimización

- Plugins con lazy loading (solo se cargan cuando se necesitan)
- Límite de 3 LSPs activos
- Sin iconos (ahorra tiempo de carga)
- Undo limitado a 100 niveles
- Swap deshabilitado
- Providers no usados deshabilitados

## Personalización

- Colores en `plugins/theme.lua` (valores hex: ámbar #FFB347, mostaza #D4A017)
- Atajos en `core/keymaps.lua`
- Opciones en `core/options.lua`
- Plugins: crear archivo en `lua/plugins/` e importar en `init.lua`
