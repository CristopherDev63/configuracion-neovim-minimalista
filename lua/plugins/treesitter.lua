return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" }, -- (Optimización Radical) Lazy Loading
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "python", "lua", "java", "javascript", "typescript", "bash", "php", "sql", "html", "css" },
				highlight = {
					enable = function(lang)
						local html_langs = { "html", "css", "javascript", "typescript", "jsx", "tsx" }
						return vim.tbl_contains(html_langs, lang)
					end,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
						if vim.api.nvim_buf_line_count(buf) > 5000 then
							return true
						end
					end,
					additional_vim_regex_highlighting = false,
				},
				indent = {
				enable = { "python" },
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
					if vim.api.nvim_buf_line_count(buf) > 5000 then
						return true
					end
				end,
			},
			})
		end,
	},
}
