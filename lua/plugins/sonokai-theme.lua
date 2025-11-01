-- lua/plugins/molokai-theme.lua - Tema Molokai clásico
return {
	{
		"tomasr/molokai",
		priority = 1000,
		config = function()
			-- ========== CARGAR EL TEMA ==========
			vim.cmd.colorscheme("molokai")

			-- ========== CONFIGURACIONES DE TRANSPARENCIA ==========
			-- Hacer que todos los fondos sean transparentes
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
			vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
			vim.api.nvim_set_hl(0, "NonText", { bg = "none" })
			vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
			vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
			vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
			vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })

			-- ========== AUTOCOMPLETADO TRANSPARENTE ==========
			vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
			vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "none" })
			vim.api.nvim_set_hl(0, "PmenuBorder", { bg = "none" })

			-- ========== SEPARADORES TRANSPARENTES ==========
			vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
			vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none" })

			-- ========== CONFIGURACIÓN ESPECÍFICA MOLOKAI ==========
			-- Mejorar algunos colores específicos para mejor visibilidad con transparencia total
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#E6DB74", bg = "NONE", bold = true }) -- Amarillo Molokai
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#75715E", bg = "NONE" }) -- Gris Molokai

			-- ========== ASEGURAR TRANSPARENCIA TOTAL ==========
			-- Usar defer_fn para asegurar que se aplique después de cargar el tema
			vim.defer_fn(function()
				-- Forzar transparencia en elementos que podrían sobrescribirse
				local transparent_groups = {
					"Normal",
					"NormalNC",
					"NormalFloat",
					"SignColumn",
					"LineNr",
					"Folded",
					"EndOfBuffer",
					"CursorLine",
					"ColorColumn",
					"StatusLine",
					"StatusLineNC",
					"Pmenu",
					"PmenuSbar",
					"PmenuThumb",
					"VertSplit",
					"WinSeparator",
					"TelescopeNormal",
					"TelescopeBorder",
					"FloatBorder",
				}

				for _, group in ipairs(transparent_groups) do
					vim.api.nvim_set_hl(0, group, { bg = "NONE" })
				end
			end, 0)

			-- print("🎨 Tema Molokai cargado con transparencia TOTAL")
		end,
	},
}
