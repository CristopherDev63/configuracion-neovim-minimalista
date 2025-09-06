return {
	{
		"projekt0n/github-nvim-theme",
		priority = 1000,
		config = function()
			require("github-theme").setup({
				theme_style = "dark_default",
				transparent = true, -- ¡FONDO TRANSPARENTE!
				dark_float = true,
				dark_sidebar = true,
				hide_end_of_buffer = true,
				hide_inactive_statusline = true,

				-- Configuración específica para transparencia
				colors = {
					bg = "NONE", -- Fondo transparente
					bg_dark = "NONE", -- Fondo oscuro transparente
					bg_highlight = "#161b22", -- Resaltado semi-transparente
					bg_statusline = "NONE",

					-- Colores de sintaxis GitHub
					fg = "#c9d1d9", -- Texto principal
					fg_dark = "#8b949e", -- Texto secundario
					fg_gutter = "#6e7681", -- Números de línea

					red = "#ff7b72",
					orange = "#ffa657",
					yellow = "#d29922",
					green = "#3fb950",
					cyan = "#56d364",
					blue = "#58a6ff",
					purple = "#bc8cff",
					magenta = "#d2a8ff",
					grey = "#8b949e",
				},

				highlights = {
					-- FONDOS TRANSPARENTES
					Normal = { fg = "#c9d1d9", bg = "NONE" },
					NormalFloat = { fg = "#c9d1d9", bg = "NONE" },
					SignColumn = { bg = "NONE" },
					LineNr = { fg = "#6e7681", bg = "NONE" },
					CursorLineNr = { fg = "#58a6ff", bg = "NONE", bold = true },
					CursorLine = { bg = "NONE" },
					NonText = { fg = "#6e7681", bg = "NONE" },
					EndOfBuffer = { fg = "#6e7681", bg = "NONE" },
					Folded = { fg = "#8b949e", bg = "NONE" },
					FoldColumn = { fg = "#6e7681", bg = "NONE" },

					-- Comentarios
					Comment = { fg = "#8b949e", italic = true },

					-- Sintaxis GitHub con transparencia
					Keyword = { fg = "#ff7b72", bold = true, bg = "NONE" },
					Function = { fg = "#d2a8ff", bg = "NONE" },
					String = { fg = "#a5d6ff", bg = "NONE" },
					Number = { fg = "#79c0ff", bg = "NONE" },
					Type = { fg = "#ffa657", bold = true, bg = "NONE" },
					Identifier = { fg = "#c9d1d9", bg = "NONE" },
					Constant = { fg = "#79c0ff", bg = "NONE" },

					-- UI elements transparentes
					Pmenu = { bg = "NONE", fg = "#c9d1d9" },
					PmenuSel = { bg = "#1f6feb", fg = "#ffffff" },
					PmenuSbar = { bg = "NONE" },
					PmenuThumb = { bg = "#6e7681" },

					Search = { fg = "#ffffff", bg = "#3fb950" },
					IncSearch = { fg = "#ffffff", bg = "#ff7b72" },

					Visual = { bg = "#264f78" },

					-- Borders and separators transparentes
					VertSplit = { fg = "#6e7681", bg = "NONE" },
					WinSeparator = { fg = "#6e7681", bg = "NONE" },
					StatusLine = { fg = "#c9d1d9", bg = "NONE" },
					StatusLineNC = { fg = "#8b949e", bg = "NONE" },

					-- Diagnosticos
					DiagnosticError = { fg = "#ff7b72", bg = "NONE" },
					DiagnosticWarn = { fg = "#ffa657", bg = "NONE" },
					DiagnosticInfo = { fg = "#58a6ff", bg = "NONE" },
					DiagnosticHint = { fg = "#56d364", bg = "NONE" },
				},
			})

			vim.cmd.colorscheme("github_dark_default")

			-- Asegurar transparencia en todos los elementos
			vim.api.nvim_set_hl(0, "Normal", { fg = "#c9d1d9", bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#c9d1d9", bg = "none" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#6e7681", bg = "none" })
			vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
			vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })
		end,
	},
}
