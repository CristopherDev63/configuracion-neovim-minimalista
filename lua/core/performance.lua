-- 2. PROTECCIÓN CONTRA ARCHIVOS GRANDES (Optimización 1)
-- Desactiva cosas pesadas si el archivo es gigante (>1MB o >20k líneas)

local group = vim.api.nvim_create_augroup("BigFileDisable", { clear = true })

vim.api.nvim_create_autocmd("BufReadPre", {
	group = group,
	callback = function(ev)
		local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
		if ok and stats and (stats.size > 1024 * 1024) then -- 1 MB
			print("⚠️  Archivo grande detectado (>1MB). Desactivando funciones pesadas.")
			
			-- Desactivar Treesitter
			pcall(vim.treesitter.stop, ev.buf)
			
			-- Desactivar opciones costosas de UI
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.spell = false
			vim.opt_local.swapfile = false
			vim.opt_local.syntax = "off"
			
			-- Opcional: Desactivar LSP (más drástico)
			-- vim.diagnostic.disable(ev.buf)
		end
	end,
})

-- Autoguardado automático al cambiar de foco (Útil para no perder trabajo)
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
	pattern = "*",
	command = "silent! wa",
})
