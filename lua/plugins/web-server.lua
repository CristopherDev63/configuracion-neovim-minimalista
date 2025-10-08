-- lua/plugins/web-server.lua
-- Configuración ÚNICA y funcional para servidor web

return {
	{
		"nvim-lua/plenary.nvim",
		config = function()
			-- ========== ASEGURAR QUE LEADER ESTÁ CONFIGURADO ==========
			vim.g.mapleader = " "
			vim.g.maplocalleader = " "

			-- ========== FUNCIÓN SERVIDOR WEB SIMPLE ==========
			local function start_web_server()
				print("🌐 Iniciando servidor web...")

				-- Verificar qué comando usar
				local cmd = nil
				local port = "8000"

				if vim.fn.executable("python3") == 1 then
					cmd = "python3 -m http.server " .. port
				elseif vim.fn.executable("python") == 1 then
					cmd = "python -m SimpleHTTPServer " .. port
				elseif vim.fn.executable("php") == 1 then
					cmd = "php -S localhost:" .. port
				else
					print("❌ No se encontró Python o PHP")
					return
				end

				-- Abrir servidor en terminal split
				vim.cmd("split")
				vim.cmd("resize 10")
				vim.cmd("terminal " .. cmd)

				-- Intentar abrir navegador después de 2 segundos
				vim.defer_fn(function()
					local url = "http://localhost:" .. port

					-- Detectar navegador disponible
					if vim.fn.executable("firefox") == 1 then
						vim.fn.system("firefox " .. url .. " &")
					elseif vim.fn.executable("google-chrome") == 1 then
						vim.fn.system("google-chrome " .. url .. " &")
					elseif vim.fn.executable("chromium") == 1 then
						vim.fn.system("chromium " .. url .. " &")
					elseif vim.fn.executable("open") == 1 then -- macOS
						vim.fn.system("open " .. url)
					elseif vim.fn.executable("xdg-open") == 1 then -- Linux genérico
						vim.fn.system("xdg-open " .. url)
					end

					print("🚀 Servidor activo en " .. url)
				end, 2000)
			end

			-- ========== FUNCIÓN LIVE SERVER CON NPM ==========
			local function start_live_server()
				if vim.fn.executable("live-server") == 1 then
					print("🔄 Iniciando Live Server con auto-reload...")
					vim.cmd("split")
					vim.cmd("resize 10")
					vim.cmd("terminal live-server --port=8080")
					print("🚀 Live Server en http://localhost:8080")
				else
					print("❌ live-server no instalado. Ejecuta: npm install -g live-server")
					print("💡 Usando servidor Python como alternativa...")
					start_web_server()
				end
			end

			-- ========== FUNCIÓN BROWSER SYNC ==========
			local function start_browser_sync()
				if vim.fn.executable("browser-sync") == 1 then
					print("🔄 Iniciando Browser-Sync...")
					vim.cmd("split")
					vim.cmd("resize 10")
					vim.cmd('terminal browser-sync start --server . --files "*.html, *.css, *.js"')
					print("🚀 Browser-Sync en http://localhost:3000")
				else
					print("❌ browser-sync no instalado. Ejecuta: npm install -g browser-sync")
					start_web_server()
				end
			end

			-- ========== FUNCIÓN PARA ABRIR EN CHROME ESPECÍFICAMENTE ==========
			local function open_in_chrome()
				local file = vim.fn.expand("%:p")
				print("🌐 Abriendo archivo en Chrome...")

				-- Priorizar Chrome específicamente
				if vim.fn.executable("google-chrome") == 1 then
					vim.fn.system("google-chrome '" .. file .. "' &")
				elseif vim.fn.executable("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome") == 1 then -- macOS
					vim.fn.system("'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' '" .. file .. "' &")
				elseif vim.fn.executable("chromium") == 1 then
					vim.fn.system("chromium '" .. file .. "' &")
				elseif vim.fn.executable("chromium-browser") == 1 then
					vim.fn.system("chromium-browser '" .. file .. "' &")
				elseif vim.fn.executable("open") == 1 then -- macOS fallback
					vim.fn.system("open -a 'Google Chrome' '" .. file .. "' 2>/dev/null || open '" .. file .. "'")
				else
					print("❌ Chrome no encontrado, usando navegador por defecto")
					if vim.fn.executable("xdg-open") == 1 then
						vim.fn.system("xdg-open '" .. file .. "'")
					end
				end
			end

			-- ========== FUNCIÓN SERVIDOR WEB + CHROME AUTOMÁTICO ==========
			local function start_server_and_chrome()
				print("🚀 Iniciando servidor y abriendo en Chrome...")

				local port = "8000"
				local cmd = nil

				if vim.fn.executable("python3") == 1 then
					cmd = "python3 -m http.server " .. port
				elseif vim.fn.executable("python") == 1 then
					cmd = "python -m SimpleHTTPServer " .. port
				elseif vim.fn.executable("php") == 1 then
					cmd = "php -S localhost:" .. port
				else
					print("❌ No se encontró Python o PHP")
					return
				end

				-- Abrir servidor en terminal split
				vim.cmd("split")
				vim.cmd("resize 10")
				vim.cmd("terminal " .. cmd)

				-- Abrir Chrome después de 3 segundos
				vim.defer_fn(function()
					local url = "http://localhost:" .. port

					if vim.fn.executable("google-chrome") == 1 then
						vim.fn.system("google-chrome " .. url .. " &")
					elseif vim.fn.executable("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome") == 1 then
						vim.fn.system("'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' " .. url .. " &")
					elseif vim.fn.executable("open") == 1 then
						vim.fn.system("open -a 'Google Chrome' " .. url .. " 2>/dev/null || open " .. url)
					else
						print("❌ Chrome no encontrado")
						return
					end

					print("🌐 Servidor activo en " .. url .. " (Chrome)")
				end, 3000)
			end

			-- ========== FUNCIÓN PARA DETENER SERVIDORES ==========
			local function stop_all_servers()
				-- Cerrar todas las terminales
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					local name = vim.api.nvim_buf_get_name(buf)
					if string.match(name, "term://") then
						if vim.api.nvim_buf_is_valid(buf) then
							vim.api.nvim_buf_delete(buf, { force = true })
						end
					end
				end
				print("⏹️ Todos los servidores detenidos")
			end

			-- ========== MAPEOS DE TECLADO ==========
			-- Mapeo principal con leader
			vim.keymap.set("n", "<leader>ws", start_web_server, {
				desc = "🌐 Iniciar servidor web Python/PHP",
				noremap = true,
				silent = false,
			})

			-- Mapeos adicionales
			vim.keymap.set("n", "<leader>wl", start_live_server, {
				desc = "🔄 Iniciar Live Server (auto-reload)",
				noremap = true,
				silent = false,
			})

			vim.keymap.set("n", "<leader>wb", start_browser_sync, {
				desc = "🔄 Iniciar Browser-Sync",
				noremap = true,
				silent = false,
			})

			vim.keymap.set("n", "<leader>wo", open_in_chrome, {
				desc = "🌐 Abrir archivo en Chrome",
				noremap = true,
				silent = false,
			})

			vim.keymap.set("n", "<leader>wc", start_server_and_chrome, {
				desc = "🚀 Servidor + Chrome automático",
				noremap = true,
				silent = false,
			})

			vim.keymap.set("n", "<leader>wx", stop_all_servers, {
				desc = "⏹️ Detener todos los servidores",
				noremap = true,
				silent = false,
			})

			-- Mapeos alternativos con F-keys
			vim.keymap.set("n", "<F6>", start_web_server, { desc = "🌐 Servidor web" })
			vim.keymap.set("n", "<F7>", open_in_chrome, { desc = "🌐 Abrir en Chrome" })
			vim.keymap.set("n", "<F8>", start_server_and_chrome, { desc = "🚀 Servidor + Chrome" })

			-- ========== COMANDOS VIM ==========
			vim.api.nvim_create_user_command("WebServer", start_web_server, {
				desc = "Iniciar servidor web Python/PHP",
			})

			vim.api.nvim_create_user_command("LiveServer", start_live_server, {
				desc = "Iniciar Live Server con auto-reload",
			})

			vim.api.nvim_create_user_command("BrowserSync", start_browser_sync, {
				desc = "Iniciar Browser-Sync",
			})

			vim.api.nvim_create_user_command("WebOpen", open_in_chrome, {
				desc = "Abrir archivo actual en Chrome",
			})

			vim.api.nvim_create_user_command("WebChrome", start_server_and_chrome, {
				desc = "Iniciar servidor y abrir en Chrome automáticamente",
			})

			vim.api.nvim_create_user_command("WebStop", stop_all_servers, {
				desc = "Detener todos los servidores",
			})

			-- ========== MENÚ DE AYUDA ==========
			vim.api.nvim_create_user_command("WebHelp", function()
				local help_text = [[
🌐 SERVIDOR WEB - COMANDOS DISPONIBLES:

ATAJOS DE TECLADO:
  <leader>ws  - Servidor Python/PHP simple
  <leader>wl  - Live Server (auto-reload)
  <leader>wb  - Browser-Sync
  <leader>wo  - Abrir archivo en Chrome
  <leader>wc  - Servidor + Chrome automático ⭐
  <leader>wx  - Detener todos los servidores

  F6          - Servidor web (alternativo)
  F7          - Abrir en Chrome (alternativo)
  F8          - Servidor + Chrome automático ⭐

COMANDOS VIM:
  :WebServer   - Iniciar servidor Python/PHP
  :LiveServer  - Iniciar Live Server
  :BrowserSync - Iniciar Browser-Sync
  :WebOpen     - Abrir archivo en Chrome
  :WebChrome   - Servidor + Chrome automático ⭐
  :WebStop     - Detener servidores
  :WebHelp     - Mostrar esta ayuda

RECOMENDADO PARA HTML:
  <leader>wc o F8 - La opción más rápida para desarrollo web

REQUISITOS:
  Python3/PHP para servidor básico
  Google Chrome instalado
  npm install -g live-server (para auto-reload)
  npm install -g browser-sync (para sincronización)

NOTA: El leader key es la barra espaciadora (Space)
]]
				print(help_text)
			end, { desc = "Mostrar ayuda del servidor web" })

			-- ========== AUTO-COMANDO PARA ARCHIVOS HTML ==========
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "html", "htm" },
				callback = function()
					-- print("📄 Archivo HTML detectado")
					-- print("⭐ Usa <leader>wc o F8 para servidor + Chrome automático")
					-- print("💡 Otros: <leader>ws (servidor), <leader>wo (solo Chrome)")
				end,
			})

			-- ========== MENSAJE DE CONFIGURACIÓN ==========
			-- print("✅ Servidor web configurado")
			-- print("🌐 Usa <leader>ws o :WebHelp para más info")
		end,
	},
}
