-- lua/plugins/live-server-fixed.lua
-- Configuración CORREGIDA para servidor web en tiempo real

return {
	-- ========== BRACEY.VIM (PRINCIPAL) ==========
	{
		"turbio/bracey.vim",
		build = "npm install --prefix server",
		cmd = { "Bracey", "BraceyStop", "BraceyReload", "BraceyEval" },
		ft = { "html", "css", "javascript" },
		config = function()
			-- Configuración de Bracey
			vim.g.bracey_browser_command = "firefox" -- Cambia por tu navegador
			vim.g.bracey_auto_start_browser = 1
			vim.g.bracey_refresh_on_save = 1
			vim.g.bracey_eval_on_save = 1
			vim.g.bracey_auto_start_server = 0
			vim.g.bracey_server_port = 3000

			-- Mapeos SEGUROS
			vim.keymap.set("n", "<leader>ws", ":Bracey<CR>", { desc = "🌐 Iniciar servidor web" })
			vim.keymap.set("n", "<leader>we", ":BraceyStop<CR>", { desc = "⏹️ Parar servidor web" })
			vim.keymap.set("n", "<leader>wr", ":BraceyReload<CR>", { desc = "🔄 Recargar página" })

			-- print("🌐 Bracey configurado - Usa <leader>ws para iniciar")
		end,
	},

	-- ========== SERVIDOR PYTHON SIMPLE ==========
	{
		"nvim-lua/plenary.nvim", -- Dependencia necesaria
		config = function()
			-- Función para servidor Python HTTP
			local function start_python_server()
				local port = vim.fn.input("Puerto (Enter para 8000): ")
				if port == "" then
					port = "8000"
				end

				-- Comando según la versión de Python disponible
				local python_cmd
				if vim.fn.executable("python3") == 1 then
					python_cmd = "python3 -m http.server " .. port
				elseif vim.fn.executable("python") == 1 then
					python_cmd = "python -m SimpleHTTPServer " .. port
				else
					print("❌ Python no encontrado")
					return
				end

				-- Iniciar en terminal
				vim.cmd("split | terminal " .. python_cmd)
				print("🐍 Servidor Python en http://localhost:" .. port)
			end

			-- Mapeo para servidor Python
			vim.keymap.set("n", "<leader>ps", start_python_server, { desc = "🐍 Servidor Python HTTP" })
		end,
	},

	-- ========== COMANDOS PERSONALIZADOS ==========
	{
		"nvim-lua/plenary.nvim", -- Ya cargado arriba, solo configuración
		config = function()
			-- Comando para crear proyecto web básico
			vim.api.nvim_create_user_command("WebProject", function(opts)
				local project_name = opts.args ~= "" and opts.args or "mi-proyecto-web"

				-- Crear archivos básicos
				local html_content = string.format(
					[[<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>%s</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%%, #764ba2 100%%);
            color: white;
            text-align: center;
        }
        .container {
            background: rgba(255, 255, 255, 0.1);
            padding: 2rem;
            border-radius: 10px;
            margin: 2rem 0;
        }
        button {
            background: #ff6b6b;
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background: #ff5252;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>¡Bienvenido a %s!</h1>
        <p>Este proyecto fue creado desde Neovim.</p>
        <button onclick="cambiarColor()">Cambiar Color</button>
        <p id="mensaje"></p>
    </div>

    <script>
        function cambiarColor() {
            const colores = ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#feca57'];
            const colorAleatorio = colores[Math.floor(Math.random() * colores.length)];
            document.querySelector('button').style.background = colorAleatorio;
            document.getElementById('mensaje').textContent = '¡Color cambiado! 🎨';
        }
        console.log('🚀 Proyecto cargado desde Neovim!');
    </script>
</body>
</html>]],
					project_name,
					project_name
				)

				-- Escribir archivo
				vim.fn.writefile(vim.split(html_content, "\n"), "index.html")

				-- Abrir archivo
				vim.cmd("edit index.html")

				print("🎉 Proyecto '" .. project_name .. "' creado! Archivo: index.html")
			end, { nargs = "?", desc = "Crear proyecto web simple" })

			-- Comando para abrir en navegador
			vim.api.nvim_create_user_command("OpenInBrowser", function()
				local file = vim.fn.expand("%:p")
				if vim.fn.executable("firefox") == 1 then
					vim.fn.system("firefox " .. file)
				elseif vim.fn.executable("google-chrome") == 1 then
					vim.fn.system("google-chrome " .. file)
				elseif vim.fn.executable("chromium") == 1 then
					vim.fn.system("chromium " .. file)
				else
					print("❌ No se encontró navegador")
				end
			end, { desc = "Abrir archivo actual en navegador" })

			-- Mapeo para abrir en navegador
			vim.keymap.set("n", "<leader>wb", ":OpenInBrowser<CR>", { desc = "🌐 Abrir en navegador" })
		end,
	},

	-- ========== AUTOCOMANDOS PARA WEB ==========
	{
		"nvim-lua/plenary.nvim", -- Ya cargado
		config = function()
			-- Configuración específica para archivos web
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "html", "css", "javascript" },
				callback = function()
					-- Configuración de indentación para web
					vim.opt_local.tabstop = 2
					vim.opt_local.shiftwidth = 2
					vim.opt_local.expandtab = true

					-- Mensaje de ayuda
					-- print("🌐 Archivo web detectado. Usa <leader>ws para servidor o <leader>wb para navegador")
				end,
			})

			-- Auto-comando para mostrar ayuda en archivos HTML
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "html",
				callback = function()
					-- Crear mapeo temporal para snippet básico
					vim.keymap.set("i", "html5", function()
						local snippet = [[<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    
</body>
</html>]]
						-- Insertar snippet
						local lines = vim.split(snippet, "\n")
						vim.api.nvim_put(lines, "l", true, true)
					end, { buffer = true, desc = "Insertar HTML5 básico" })
				end,
			})
		end,
	},

	-- ========== INFORMACIÓN DE AYUDA ==========
	{
		"nvim-lua/plenary.nvim", -- Ya cargado
		config = function()
			-- Comando de ayuda
			vim.api.nvim_create_user_command("WebHelp", function()
				local help_text = [[
🌐 SERVIDOR WEB - COMANDOS DISPONIBLES:

📋 ATAJOS DE TECLADO:
  <leader>ws  - Iniciar servidor Bracey
  <leader>we  - Parar servidor Bracey  
  <leader>wr  - Recargar página
  <leader>ps  - Servidor Python HTTP
  <leader>wb  - Abrir en navegador

🔧 COMANDOS:
  :WebProject nombre  - Crear proyecto web
  :OpenInBrowser     - Abrir archivo en navegador
  :Bracey           - Iniciar Bracey manualmente
  :BraceyStop       - Parar Bracey
  
📝 EN ARCHIVOS HTML:
  html5 (en modo inserción) - Snippet HTML5 básico

🚀 INICIO RÁPIDO:
  1. :WebProject test
  2. <leader>ws
  3. Editar archivo y ver cambios en tiempo real
]]

				-- Mostrar en buffer temporal
				local buf = vim.api.nvim_create_buf(false, true)
				local lines = vim.split(help_text, "\n")
				vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
				vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
				vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
				vim.cmd("split")
				vim.api.nvim_win_set_buf(0, buf)
			end, { desc = "Mostrar ayuda del servidor web" })

			-- print("✅ Servidor web configurado. Usa :WebHelp para ver comandos")
		end,
	},
}
