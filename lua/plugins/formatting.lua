-- Formateador de código
return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					python = { "autopep8" },
					sh = { "shfmt" },
					bash = { "shfmt" },
					php = { "php_cs_fixer" },
					jsx = { "prettier" }, -- Agregado para React
					tsx = { "prettier" }, -- Agregado para React
				},
				format_on_save = nil,
			})
		end,
	},
}
