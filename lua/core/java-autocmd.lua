-- lua/core/java-autocmd.lua
-- Autocomando para ejecutar Java con F9

-- Función para ejecutar Java con tu comando personalizado
local function run_java()
	local filepath = vim.fn.expand("%:p")      -- Ruta completa
	local filename = vim.fn.expand("%:t")       -- Solo nombre del archivo
	local classname = vim.fn.expand("%:t:r")    -- Nombre sin extensión
	local dir = vim.fn.expand("%:p:h")          -- Directorio del archivo

	-- Guardar primero
	vim.cmd("write")

	-- CAMBIAR al directorio del archivo, luego ejecutar
	local cmd = string.format("!cd '%s' && rm -f %s.class && javac %s && java %s",
		dir, classname, filename, classname)

	print("Ejecutando en: " .. dir)
	vim.cmd(cmd)
end

-- Configurar F9 para archivos Java
vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		vim.keymap.set("n", "<F9>", run_java, {
			buffer = true,
			desc = "☕ Ejecutar Java",
			noremap = true,
			silent = false,
		})
		print("☕ F9 configurado para Java en este buffer")
	end,
})

print("✅ Autocomando de Java cargado")
