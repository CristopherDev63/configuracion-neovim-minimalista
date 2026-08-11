# Instrucciones para este repositorio (configuración de Neovim)

Este es un repositorio de configuración de Neovim gestionado con lazy.nvim.
Las reglas de "Programación atómica" del AGENTS.md global **NO aplican aquí**.
Este proyecto sustituye esa sección por lo siguiente:

## Alcance y comportamiento
- Trabaja normalmente sobre la configuración: puedes crear y editar varios
  archivos del repo si una tarea lo requiere. No hay "modo archivo único".
- Puedes ejecutar comandos de terminal y de Git necesarios para la tarea
  (la gestión del repo sigue siendo del usuario, salvo que pida otra cosa).
- No crees archivos de configuración de entorno ni automatización
  (.env, Dockerfile, .gitignore, etc.) a menos que se pidan explícitamente.

## Estructura del repo
- `init.lua`: arranque, plugins vía `require("lazy").setup({...})`.
- `lua/core/`: configuración base — `options.lua`, `keymaps.lua`,
  `autocommands.lua`, `performance.lua`, `graphing.lua`, `help.lua`,
  `lag-monitor.lua`.
- `lua/plugins/`: un archivo por plugin, con formato `{ "autor/repo", opts = {...} }`.

## Convenciones
- Un plugin = un archivo en `lua/plugins/<nombre>.lua`; regístralo en
  `init.lua` con `{ import = "plugins.<nombre>" }`.
- Respeta el estilo existente (tabs, comillas, orden de claves).
- Documenta cambios en español, breve y en el propio código.
- Verifica cambios con `nvim --headless` antes de dar por terminada la tarea.

## Formato de respuesta
- Responde en español, sin preámbulos ni resúmenes innecesarios.
- Si falta información crítica, haz 1-2 preguntas directas antes de tocar código.
