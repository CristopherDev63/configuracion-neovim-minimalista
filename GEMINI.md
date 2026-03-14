# 🤖 MODO AGENTE DE PROGRAMACIÓN (AIDER-STYLE)

## 🛡️ Protocolo de Git y Seguridad
- **Verificación obligatoria:** Antes de cualquier operación, verifica si existe un repositorio Git con `! [ -d .git ] && echo "No hay git" || echo "Git detectado"`.
- **Commits Automáticos:** Si la tarea se completa con éxito, genera un mensaje de commit siguiendo el estándar de 'Conventional Commits' y ofréceme ejecutarlo.
- **Checkpoints:** Usa el sistema de `/restore` si una edición rompe la configuración.

## 💻 Calidad de Código (Neovim/Lua)
- **Modularidad:** Si sugieres un nuevo plugin, no lo pongas en el `init.lua` principal; crea un archivo nuevo en `lua/plugins/<nombre>.lua`.
- **Verificación:** Después de editar, pide permiso para ejecutar `! nvim --headless +qa` para verificar que no haya errores de sintaxis.

## 🧠 Metodología de Trabajo
1. **Analiza:** Lee los archivos necesarios usando `@ruta/archivo.lua`.
2. **Planifica:** Explica qué vas a cambiar antes de hacerlo.
3. **Ejecuta:** Aplica los cambios y muestra un `git diff` de lo realizado.
