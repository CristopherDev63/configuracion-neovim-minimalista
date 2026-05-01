# 🚀 Optimización Radical - MacBook Pro 2015

Este documento resume los cambios realizados en la configuración de Neovim para solucionar problemas de sobrecalentamiento, uso excesivo de CPU y fugas de memoria virtual (+100GB).

## 🛠️ 1. Ajustes de Sistema (`lua/core/options.lua` y `performance.lua`)
- **Redrawtime (1500ms)**: Se aumentó el tiempo de redibujado para reducir el estrés en la GPU/CPU al renderizar la interfaz.
- **Updatetime (300ms)**: Optimizado para que los eventos de Neovim no saturen el disco.
- **Desactivación de Providers**: Se eliminó la búsqueda automática de soporte para Python2, Ruby, Perl y Node al iniciar. Esto elimina procesos innecesarios en segundo plano.

## 🧠 2. Optimización de LSP (El "Cerebro")
El LSP era la causa principal del consumo de 100GB de memoria virtual. Se aplicaron las siguientes "cercas":
- **Vigilancia de Archivos Desactivada**: `didChangeWatchedFiles = false`. El LSP ya no escanea el disco constantemente buscando cambios.
- **Exclusión de Carpetas Pesadas**: El LSP ignora explícitamente `node_modules`, `.git`, `__pycache__`, `venv`, `dist`, y `.next`.
- **Debounce de 500ms**: El servidor LSP ahora espera medio segundo después de que dejas de escribir para procesar diagnósticos, bajando el uso de CPU.
- **Límite de Memoria**: El servidor de TypeScript (`ts_ls`) tiene ahora un límite estricto de 1GB de RAM.

## ⚡ 3. Carga Perezosa Radical (Lazy Loading)
Ningún plugin pesado se carga al iniciar Neovim. Solo se activan cuando realmente los necesitas:
- **LSP y Treesitter**: Solo se cargan al abrir un archivo de código (`BufReadPre`, `BufNewFile`).
- **Telescope**: Solo se carga al ejecutar el comando o usar el atajo de búsqueda.
- **Codeium (IA)**: **Desactivado por defecto**. No consume recursos hasta que lo activas manualmente.

## 🛡️ 4. Modo de Alto Rendimiento para Archivos Grandes
En `lua/core/performance.lua`, se configuró un protector automático:
- Si un archivo pesa más de **100KB** o tiene más de **5000 líneas**:
    - Se apaga Treesitter (colores complejos).
    - Se desactiva el autoguardado y el archivo de intercambio (swap).
    - Se apaga la sintaxis pesada para permitir navegación fluida.

## 🚨 5. Nuevos Comandos de Emergencia
Si notas que el sistema se calienta o la RAM se llena, puedes usar:

| Comando | Acción |
| :--- | :--- |
| `:CleanBuffers` | Cierra todos los buffers abiertos que no estás usando para liberar RAM. |
| `:LspKillAll` | Detiene todos los servidores LSP instantáneamente (Ideal si los ventiladores se disparan). |
| `:CodeiumEnable` | Activa la IA solo cuando decidas usarla (Atajo: `<leader>ct`). |

---
*Configuración optimizada para durabilidad y rendimiento en hardware antiguo.*
