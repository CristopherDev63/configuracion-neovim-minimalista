-- lua/plugins/markdown-preview.lua
-- Plugin estable para previsualizar Markdown en el navegador

return {
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			-- ========== CONFIGURACIÓN DEL PLUGIN ==========

			-- Configuración básica
			vim.g.mkdp_auto_start = 0 -- No abrir automáticamente
			vim.g.mkdp_auto_close = 1 -- Cerrar cuando cambies de buffer
			vim.g.mkdp_refresh_slow = 0 -- Refresh rápido
			vim.g.mkdp_command_for_global = 0 -- Solo para archivos markdown
			vim.g.mkdp_open_to_the_world = 0 -- Solo localhost
			vim.g.mkdp_open_ip = ""
			vim.g.mkdp_echo_preview_url = 0
			vim.g.mkdp_browserfunc = ""

			-- Configurar navegador (vacío usa el por defecto del sistema, e.g. Chrome)
			vim.g.mkdp_browser = "" 

			-- Configuración de puerto
			vim.g.mkdp_port = "8080"
			vim.g.mkdp_page_title = "【${name}】"

			-- Opciones de preview
			vim.g.mkdp_preview_options = {
				mkit = {},
				katex = {}, -- Soporte para LaTeX/matemáticas
				uml = {}, -- Diagramas UML
				maid = {}, -- Diagramas Mermaid
				disable_sync_scroll = 0, -- Scroll sincronizado
				sync_scroll_type = "middle",
				hide_yaml_meta = 1, -- Ocultar metadatos YAML
				sequence_diagrams = {},
				flowchart_diagrams = {},
				content_editable = false,
				disable_filename = 0,
				toc = {},
			}

			-- CSS personalizado (opcional)
			vim.g.mkdp_markdown_css = ""
			vim.g.mkdp_highlight_css = ""

			-- Temas disponibles: 'dark' o 'light'
			vim.g.mkdp_theme = "dark"

			-- ========== MAPEOS DE TECLADO ==========
			local keymap = vim.keymap

			-- Mapeos principales para Markdown
			keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", {
				desc = "📖 Abrir preview Markdown",
				noremap = true,
				silent = true,
			})

			keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<CR>", {
				desc = "⏹️ Cerrar preview Markdown",
				noremap = true,
				silent = true,
			})

			keymap.set("n", "<leader>mt", ":MarkdownPreviewToggle<CR>", {
				desc = "🔄 Toggle preview Markdown",
				noremap = true,
				silent = true,
			})

			-- Mapeos con F-keys para acceso rápido
			keymap.set("n", "<F8>", ":MarkdownPreviewToggle<CR>", {
				desc = "📖 Toggle Markdown Preview",
				noremap = true,
				silent = true,
			})

			-- ========== AUTO-COMANDOS ==========

			-- Auto-comando para archivos Markdown
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function()
					-- Configuración específica para Markdown
					vim.opt_local.conceallevel = 0 -- Mostrar todos los caracteres
					vim.opt_local.wrap = true -- Activar wrap para Markdown
					vim.opt_local.linebreak = true -- Break en palabras completas
					vim.opt_local.spell = true -- Corrector ortográfico
					vim.opt_local.spelllang = { "es", "en" } -- Español e inglés

					-- Mapeos específicos del buffer
					keymap.set("n", "<leader>mh", function()
						-- Insertar encabezado H1
						local line = vim.fn.line(".")
						local current_line = vim.fn.getline(line)
						vim.fn.setline(line, "# " .. current_line)
					end, { buffer = true, desc = "# Encabezado H1" })

					keymap.set("n", "<leader>m2", function()
						-- Insertar encabezado H2
						local line = vim.fn.line(".")
						local current_line = vim.fn.getline(line)
						vim.fn.setline(line, "## " .. current_line)
					end, { buffer = true, desc = "## Encabezado H2" })

					keymap.set("n", "<leader>m3", function()
						-- Insertar encabezado H3
						local line = vim.fn.line(".")
						local current_line = vim.fn.getline(line)
						vim.fn.setline(line, "### " .. current_line)
					end, { buffer = true, desc = "### Encabezado H3" })

					keymap.set("v", "<leader>mb", function()
						-- Poner texto en negrita
						vim.cmd('normal! c**<C-r>"**<Esc>')
					end, { buffer = true, desc = "**Negrita**" })

					keymap.set("v", "<leader>mi", function()
						-- Poner texto en cursiva
						vim.cmd('normal! c*<C-r>"*<Esc>')
					end, { buffer = true, desc = "*Cursiva*" })

					keymap.set("v", "<leader>mc", function()
						-- Poner texto como código
						vim.cmd('normal! c`<C-r>"`<Esc>')
					end, { buffer = true, desc = "`Código`" })
				end,
			})

			-- Mensaje de bienvenida para archivos Markdown
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "*.md",
				callback = function()
					-- Solo mostrar mensaje una vez por sesión
					if not vim.g.markdown_welcome_shown then
						vim.defer_fn(function()
							print("📖 Archivo Markdown detectado")
							print("💡 Usa F8 o <leader>mp para preview | :MarkdownHelp para ayuda")
						end, 100)
						vim.g.markdown_welcome_shown = true
					end
				end,
			})

			-- ========== COMANDOS PERSONALIZADOS ==========

			-- Comando para crear un Markdown básico
			vim.api.nvim_create_user_command("MarkdownTemplate", function(opts)
				local title = opts.args ~= "" and opts.args or "Mi Documento"
				local template = string.format(
					[[
# %s

## Introducción

Escribe aquí tu introducción.

## Contenido Principal

### Subsección 1

- Punto 1
- Punto 2
- Punto 3

### Subsección 2

1. Elemento numerado 1
2. Elemento numerado 2
3. Elemento numerado 3

## Código de Ejemplo

```bash
echo "Hola mundo"
```

```python
def saludar():
    print("¡Hola desde Python!")
```

## Enlaces y Referencias

- [Enlace de ejemplo](https://example.com)
- **Texto en negrita**
- *Texto en cursiva*
- `código inline`

## Conclusión

Escribe aquí tu conclusión.

---

*Documento creado con Neovim* 📝
]],
					title
				)

				-- Crear el archivo
				local lines = vim.split(template, "\n")
				vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

				print("📝 Template Markdown creado: " .. title)
			end, {
				nargs = "?",
				desc = "Crear template básico de Markdown",
			})

			-- Comando de ayuda para Markdown
			vim.api.nvim_create_user_command("MarkdownHelp", function()
				local help_text = [[
📖 MARKDOWN PREVIEW - COMANDOS DISPONIBLES:

📋 ATAJOS DE TECLADO:
  F8              - Toggle preview (abrir/cerrar)
  <leader>mp      - Abrir preview en navegador
  <leader>ms      - Cerrar preview
  <leader>mt      - Toggle preview

📝 EDICIÓN MARKDOWN (en archivos .md):
  <leader>mh      - Convertir línea a # H1
  <leader>m2      - Convertir línea a ## H2
  <leader>m3      - Convertir línea a ### H3
  <leader>mb      - **Negrita** (selección)
  <leader>mi      - *Cursiva* (selección)
  <leader>mc      - `Código` (selección)

🔧 COMANDOS:
  :MarkdownPreview        - Abrir preview
  :MarkdownPreviewStop    - Cerrar preview
  :MarkdownPreviewToggle  - Toggle preview
  :MarkdownTemplate título - Crear template básico
  :MarkdownHelp          - Mostrar esta ayuda

✨ CARACTERÍSTICAS:
  ✅ Preview en tiempo real en navegador
  ✅ Scroll sincronizado
  ✅ Soporte para LaTeX/matemáticas
  ✅ Diagramas Mermaid y UML
  ✅ Tema oscuro por defecto
  ✅ Corrector ortográfico automático
  ✅ Sintaxis highlighting

🚀 INICIO RÁPIDO:
  1. Abre un archivo .md o crea uno nuevo
  2. Presiona F8 para abrir preview
  3. Edita el archivo y ve cambios en tiempo real
  4. Usa <leader>mp para reabrir si se cierra

🌐 SERVIDOR:
  Puerto: 8080
  URL: http://localhost:8080

💡 TIP: El preview se abre automáticamente en tu navegador 
por defecto y se actualiza mientras escribes.
]]

				-- Mostrar en buffer temporal
				local buf = vim.api.nvim_create_buf(false, true)
				local lines = vim.split(help_text, "\n")
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
				vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
				vim.cmd("split")
				vim.api.nvim_win_set_buf(0, buf)
			end, { desc = "Mostrar ayuda de Markdown preview" })
		end,
	},
}
