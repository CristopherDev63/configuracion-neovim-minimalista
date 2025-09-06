return {
	-- No necesitas declarar el plugin en lazy.nvim para temas Vim tradicionales
	-- Solo configuraremos el tema aquí
	config = function()
		-- Cargar el tema wombat256i
		vim.cmd.colorscheme("wombat256i")

		-- Configurar transparencia
		vim.api.nvim_set_hl(0, "Normal", { fg = "#f6f3e8", bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#f6f3e8", bg = "none" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#857f78", bg = "none" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e5786d", bg = "none", bold = true })
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
		vim.api.nvim_set_hl(0, "NonText", { fg = "#555555", bg = "none" })
		vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#555555", bg = "none" })
		vim.api.nvim_set_hl(0, "Pmenu", { bg = "none", fg = "#f6f3e8" })
		vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#5f5a60", fg = "#ffffff" })
		vim.api.nvim_set_hl(0, "StatusLine", { bg = "none", fg = "#f6f3e8" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none", fg = "#857f78" })

		-- Mejorar colores de sintaxis
		vim.api.nvim_set_hl(0, "Comment", { fg = "#99968b", italic = true })
		vim.api.nvim_set_hl(0, "Keyword", { fg = "#88b8f6", bold = true })
		vim.api.nvim_set_hl(0, "String", { fg = "#95e454" })
		vim.api.nvim_set_hl(0, "Number", { fg = "#e5786d" })
		vim.api.nvim_set_hl(0, "Function", { fg = "#f6f3e8" })
		vim.api.nvim_set_hl(0, "Type", { fg = "#cae682", bold = true })
	end,
}
