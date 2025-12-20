-- Función para ejecutar código según el tipo de archivo (ahora con F9)
local function execute_code_based_on_filetype()
	local filetype = vim.bo.filetype
	local filename = vim.fn.expand("%")

	-- Guardar el archivo primero
	vim.cmd("write")

	if filetype == "python" or string.match(filename, "%.py$") then
		vim.cmd("!python3 %")
	elseif filetype == "sh" or filetype == "bash" or string.match(filename, "%.sh$") then
		vim.cmd("!bash %")
	elseif filetype == "javascript" or string.match(filename, "%.js$") then
		vim.cmd("!node %")
	elseif filetype == "typescript" or string.match(filename, "%.ts$") then
		vim.cmd("!ts-node %")
	elseif filetype == "lua" or string.match(filename, "%.lua$") then
		vim.cmd("!lua %")
	elseif filetype == "php" or string.match(filename, "%.php$") then
		vim.cmd("!php %")
	else
		print("Tipo de archivo no soportado para ejecución: " .. filetype)
	end
end

-- Atajos de teclado
local keymap = vim.keymap

-- Variables globales
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- EJECUTAR CÓDIGO - Cambiado a F9 (Ctrl+C ahora es para debugging)
keymap.set("n", "<F9>", execute_code_based_on_filetype, { desc = "▶️ Ejecutar código según tipo de archivo" })

-- Atajos básicos
keymap.set("n", "<F2>", ":w<CR>", { desc = "💾 Guardar archivo" })
keymap.set("n", "<F3>", ":q<CR>", { desc = "❌ Cerrar ventana" })
keymap.set("n", "<F4>", ":wq<CR>", { desc = "💾❌ Guardar y salir" })

-- Portapapeles
-- keymap.set("n", "<C-v>", '"+p', { desc = "📋 Pegar desde portapapeles" })
-- keymap.set("i", "<C-v>", "<C-r>+", { desc = "📋 Pegar en modo inserción" })

-- Navegación de buffers
keymap.set("n", "<Tab>", ":bnext<CR>", { desc = "➡️ Siguiente buffer" })
keymap.set("n", "<S-Tab>", ":bprevious<CR>", { desc = "⬅️ Buffer anterior" })

-- Desactivar teclas problemáticas
keymap.set("n", "Q", "<nop>")
keymap.set("n", "<C-z>", "<nop>", { desc = "Evita suspender Neovim" })

-- Bloqueo de flechas de navegación
keymap.set("n", "<Up>", "<nop>", { desc = "Desactivar flecha arriba" })
keymap.set("n", "<Down>", "<nop>", { desc = "Desactivar flecha abajo" })
keymap.set("n", "<Left>", "<nop>", { desc = "Desactivar flecha izquierda" })
keymap.set("n", "<Right>", "<nop>", { desc = "Desactivar flecha derecha" })
keymap.set("i", "<Up>", "<nop>", { desc = "Desactivar flecha arriba" })
keymap.set("i", "<Down>", "<nop>", { desc = "Desactivar flecha abajo" })
keymap.set("i", "<Left>", "<nop>", { desc = "Desactivar flecha izquierda" })
keymap.set("i", "<Right>", "<nop>", { desc = "Desactivar flecha derecha" })

-- Atajo para formatear con Ctrl+J
keymap.set("n", "<C-J>", function()
	require("conform").format({ async = true })
end, { desc = "🎨 Formatear código" })

-- Comando para recargar LSP y Treesitter cuando falle
keymap.set("n", "<leader>rr", function()
		local clients = vim.lsp.get_clients()
	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id)
	end

	vim.defer_fn(function()
		-- Reiniciar LSP para el buffer actual
		vim.lsp.start()

		-- Reiniciar Treesitter
		vim.treesitter.stop()
		vim.defer_fn(function()
			vim.treesitter.start()
			print("✓ LSP y Treesitter recargados correctamente")
		end, 100)
	end, 150)
end, { desc = "🔄 Recargar LSP y Treesitter" })

-- Diagnosticar estado LSP
keymap.set("n", "<leader>ld", function()
	local clients = vim.lsp.get_clients()
	local bufnr = vim.api.nvim_get_current_buf()

	if #clients == 0 then
		print("⚠ No hay clientes LSP activos")
	else
		for _, client in ipairs(clients) do
			local attached = client.attached_buffers[bufnr] and "✓ Activo" or "⚠ Inactivo"
			print("LSP: " .. client.name .. " - " .. attached)
		end
	end
end, { desc = "🔍 Diagnosticar estado LSP" })

-- ========== SERVIDOR WEB PARA HTML ==========
-- Función para abrir archivo en Chrome
local function open_in_chrome()
	local file = vim.fn.expand("%:p")
	print("🌐 Abriendo archivo en Chrome...")

	if vim.fn.executable("google-chrome") == 1 then
		vim.fn.system("google-chrome '" .. file .. "' &")
	elseif vim.fn.executable("/Applications/Google Chrome.app/Contents/MacOS/Google Chrome") == 1 then
		vim.fn.system("'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' '" .. file .. "' &")
	elseif vim.fn.executable("open") == 1 then -- macOS
		vim.fn.system("open -a 'Google Chrome' '" .. file .. "' 2>/dev/null || open '" .. file .. "'")
	else
		print("❌ Chrome no encontrado")
	end
end

-- Función para servidor web simple
local function start_web_server()
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

	vim.cmd("split")
	vim.cmd("resize 10")
	vim.cmd("terminal " .. cmd)
	print("🚀 Servidor iniciado en http://localhost:" .. port)
end

-- Función servidor + Chrome automático
local function start_server_and_chrome()
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
		end

		print("🌐 Servidor activo en " .. url .. " (Chrome)")
	end, 3000)
end

-- MAPEOS DE SERVIDOR WEB
keymap.set("n", "<leader>wo", open_in_chrome, { desc = "🌐 Abrir en Chrome" })

-- Mapeos con F-keys
keymap.set("n", "<F7>", open_in_chrome, { desc = "🌐 Abrir en Chrome" })