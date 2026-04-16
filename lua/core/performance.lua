-- 2. PROTECCIÓN CONTRA ARCHIVOS GRANDES (Optimización Radical)
-- Desactiva cosas pesadas si el archivo supera 100KB o 5000 líneas
local group = vim.api.nvim_create_augroup("BigFileDisable", { clear = true })

vim.api.nvim_create_autocmd("BufReadPre", {
	group = group,
	callback = function(ev)
		local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
		local line_count = vim.api.nvim_buf_line_count(ev.buf)
		
		if (ok and stats and stats.size > 100 * 1024) or line_count > 5000 then 
			print("⚠️  Archivo pesado detectado. Aplicando modo de alto rendimiento.")
			
			-- Desactivar Treesitter
			pcall(vim.treesitter.stop, ev.buf)
			
			-- Desactivar opciones costosas
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.spell = false
			vim.opt_local.swapfile = false
			vim.opt_local.syntax = "off"
			vim.opt_local.undofile = false
		end
	end,
})

-- 3. LIMPIEZA DE BUFFERS INACTIVOS (Diagnóstico y RAM)
-- Comando: :CleanBuffers
vim.api.nvim_create_user_command("CleanBuffers", function()
    local buffers = vim.api.nvim_list_bufs()
    local current_buf = vim.api.nvim_get_current_buf()
    local cleaned = 0
    
    for _, bufnr in ipairs(buffers) do
        if bufnr ~= current_buf and vim.api.nvim_buf_is_loaded(bufnr) and vim.fn.getbufvar(bufnr, "&modified") == 0 then
            vim.api.nvim_buf_delete(bufnr, { force = false })
            cleaned = cleaned + 1
        end
    end
    print("🧹 Buffers inactivos limpiados: " .. cleaned)
end, {})

-- Autoguardado automático al cambiar de foco (Útil para no perder trabajo)
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
	pattern = "*",
	command = "silent! wa",
})
