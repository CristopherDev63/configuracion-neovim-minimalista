-- Configuración LSP
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local opts = { buffer = args.buf, silent = true }

		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

		if client.supports_method("textDocument/hover") then
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		end

		if client.supports_method("textDocument/formatting") then
			vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
		end
	end,
})

-- Configuración específica para archivos PHP
vim.api.nvim_create_autocmd("FileType", {
	pattern = "php",
	callback = function()
		-- Configuración de indentación para PHP
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.expandtab = true

		-- Atajos específicos para PHP
		vim.keymap.set("n", "<leader>dd", ":!php -l %<CR>", { buffer = true, desc = "Verificar sintaxis PHP" })
		vim.keymap.set("n", "<leader>db", ":!php -f %<CR>", { buffer = true, desc = "Ejecutar archivo PHP" })
	end,
})

-- Configuración específica para archivos SQL
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	callback = function()
		-- Configuración para SQL
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true

		-- Atajos específicos para SQL
		vim.keymap.set(
			"n",
			"<leader>ds",
			":!mysql -u root -p < %<CR>",
			{ buffer = true, desc = "Ejecutar consulta MySQL" }
		)
		end,
	})

-- Autocomando para hacer el fondo transparente
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
		vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })
		vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
	end,
})
