-- lua/plugins/java-run.lua
-- Ejecutar Java con F9 - SIMPLE Y DIRECTO

return {
	{
		"nvim-lua/plenary.nvim",
		init = function()
			-- Función para ejecutar Java
			local function run_java()
				print("🔥 F9 presionado - ejecutando run_java()...")

				local filepath = vim.fn.expand("%:p")
				local filename = vim.fn.expand("%:t")
				local dir = vim.fn.expand("%:p:h")
				local classname = vim.fn.expand("%:t:r")

				print("📁 Archivo: " .. filename)
				print("📂 Directorio: " .. dir)
				print("📦 Clase: " .. classname)

				-- Guardar archivo
				vim.cmd("write")

				-- Verificar que sea un archivo .java
				if not filename:match("%.java$") then
					print("❌ No es un archivo Java")
					return
				end

				-- Verificar Java
				if vim.fn.executable("java") == 0 then
					print("❌ java no está instalado o no está en PATH")
					return
				end

				if vim.fn.executable("javac") == 0 then
					print("❌ javac no está instalado o no está en PATH")
					return
				end

				print("✅ java y javac encontrados")
				print("☕ Compilando y ejecutando " .. classname .. "...")

				-- Comando completo (primero eliminar .class viejo, luego compilar y ejecutar)
				local cmd = string.format(
					'cd "%s" && rm -f "%s.class" && javac "%s" && java %s',
					dir,
					classname,
					filename,
					classname
				)

				print("🚀 Ejecutando comando:")
				print("   " .. cmd)

				-- Ejecutar en terminal
				vim.cmd("split")
				vim.cmd("resize 12")
				vim.cmd("terminal " .. cmd)

				-- Volver al archivo
				vim.defer_fn(function()
					vim.cmd("wincmd p")
				end, 200)
			end

			-- Mapeo F9 solo para archivos Java
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					-- Remover mapeo anterior de F9 si existe
					pcall(vim.keymap.del, "n", "<F9>", { buffer = true })

					vim.keymap.set("n", "<F9>", run_java, {
						buffer = true,
						desc = "☕ Ejecutar Java",
						noremap = true,
						silent = false, -- Mostrar errores si hay
					})
					-- print("☕ F9 está listo para ejecutar Java (presiona F9 ahora)")
				end,
			})
		end,
	},
}
