-- Función para verificar y reparar automáticamente LSP
local function check_and_repair_lsp()
	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.bo.filetype
	local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

	if #clients == 0 then
		vim.defer_fn(function()
			if filetype == "python" then
				require("lspconfig").pyright.launch()
				print("↪ LSP reactivado automáticamente para Python")
			elseif filetype == "sh" or filetype == "bash" then
				require("lspconfig").bashls.launch()
				print("↪ LSP reactivado automáticamente para Bash")
			elseif filetype == "php" then
				require("lspconfig").intelephense.launch()
				print("↪ LSP reactivado automáticamente para PHP")
			end
		end, 200)
	end
end

-- Auto-comandos para manejar problemas de LSP y Treesitter
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python", "sh", "bash", "php" },
	callback = function()
		local filetype = vim.bo.filetype

		-- Verificar y forzar LSP si no está activo
		local clients = vim.lsp.get_active_clients({ bufnr = 0 })
		if #clients == 0 then
			vim.defer_fn(function()
				if filetype == "python" then
					require("lspconfig").pyright.launch()
				elseif filetype == "sh" or filetype == "bash" then
					require("lspconfig").bashls.launch()
				elseif filetype == "php" then
					require("lspconfig").intelephense.launch()
				end
			end, 100)
		end

		-- Verificar y forzar Treesitter si no está activo
		if not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
			vim.defer_fn(function()
				vim.treesitter.start()
			end, 150)
		end
	end,
	desc = "Asegurar LSP y Treesitter para Python, Bash y PHP",
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.py", "*.sh", "*.bash", "*.php" },
	callback = function()
		local filetype = vim.bo.filetype

		-- Verificación adicional al entrar al buffer
		local clients = vim.lsp.get_active_clients({ bufnr = 0 })
		if #clients == 0 then
			vim.defer_fn(function()
				if filetype == "python" then
					require("lspconfig").pyright.launch()
				elseif filetype == "sh" or filetype == "bash" then
					require("lspconfig").bashls.launch()
				elseif filetype == "php" then
					require("lspconfig").intelephense.launch()
				end
			end, 50)
		end
	end,
	desc = "Verificar LSP al entrar a buffer Python, Bash o PHP",
})

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

-- Verificar periódicamente (cada 2 segundos cuando está en modo normal)
vim.api.nvim_create_autocmd("CursorHold", {
	callback = check_and_repair_lsp,
	desc = "Verificar estado LSP periódicamente",
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
