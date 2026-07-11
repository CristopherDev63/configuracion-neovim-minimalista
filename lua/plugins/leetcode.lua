return {
	{
		"kawre/leetcode.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
			"rcarriga/nvim-notify",
		},
		cmd = "Leet",
		keys = {
			{ "<leader>lol", "<cmd>Leet<CR>", desc = "LeetCode: Abrir menú" },
			{ "<leader>lot", "<cmd>Leet tabs<CR>", desc = "LeetCode: Problemas por tag" },
			{ "<leader>loc", "<cmd>Leet list<CR>", desc = "LeetCode: Lista de problemas" },
			{ "<leader>lor", "<cmd>Leet random<CR>", desc = "LeetCode: Problema aleatorio" },
			{ "<leader>lod", "<cmd>Leet daily<CR>", desc = "LeetCode: Problema diario" },
			{ "<leader>los", "<cmd>Leet submit<CR>", desc = "LeetCode: Enviar solución" },
		},
		config = function()
			require("leetcode").setup({
				lang = "python3",
				plugins = {
					non_standalone = true,
				},
				theme = {
					normal = {
						fg = "#c0caf5",
						bg = "NONE",
					},
				},
				sql = {
					lang = "mysql",
				},
				logging = true,
				default_group = "leetcode",
				storage = {
					home = vim.fn.stdpath("data") .. "/leetcode",
					cache = vim.fn.stdpath("cache") .. "/leetcode",
				},
				injector = {},
				formatter = false,
				lsp = {
					provider = "none",
				},
				cursor = {
					enabled = true,
					text = "┃",
					hl = "Cursor",
				},
			})
		end,
	},
}
