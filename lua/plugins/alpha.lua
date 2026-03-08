return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Logotipo ASCII Personalizado (Solo CRISTOPHER)
			dashboard.section.header.val = {
				[[ ██████╗██████╗ ██╗███████╗████████╗ ██████╗ ██████╗ ██╗  ██╗███████╗██████╗ ]],
				[[██╔════╝██╔══██╗██║██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██║  ██║██╔════╝██╔══██╗]],
				[[██║     ██████╔╝██║███████╗   ██║   ██║   ██║██████╔╝███████║█████╗  ██████╔╝]],
				[[██║     ██╔══██╗██║╚════██║   ██║   ██║   ██║██╔═══╝ ██╔══██║██╔══╝  ██╔══██╗]],
				[[╚██████╗██║  ██║██║███████║   ██║   ╚██████╔╝██║     ██║  ██║███████╗██║  ██║]],
				[[ ╚═════╝╚═╝  ╚═╝╚═╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝]],
			}

			-- Color naranja para el nombre
			vim.api.nvim_set_hl(0, "AlphaHeaderOrange", { fg = "#FF8F40" })
			dashboard.section.header.opts.hl = "AlphaHeaderOrange"

			-- Botones del menú
			dashboard.section.buttons.val = {
				dashboard.button("n", "📄  Nuevo archivo", ":ene <BAR> startinsert <CR>"),
				dashboard.button("p", "🔍  Buscar archivos", ":Telescope find_files<CR>"),
				dashboard.button("r", "🕒  Recientes", ":Telescope oldfiles<CR>"),
				dashboard.button("s", "⚙️   Configuración", ":e $MYVIMRC <CR>"),
				dashboard.button("q", "❌  Salir", ":qa<CR>"),
			}

			-- Pie de página
			local handle = io.popen("date")
			local date = handle:read("*a")
			handle:close()
			dashboard.section.footer.val = "📅 " .. date

			-- Configuración final
			alpha.setup(dashboard.opts)

			-- Desactivar barra de estado en la bienvenida
			local alpha_group = vim.api.nvim_create_augroup("AlphaSettings", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = alpha_group,
				pattern = "alpha",
				callback = function()
					vim.opt.laststatus = 0
					vim.opt.showtabline = 0
					
					-- Al cerrar el buffer de alpha, restauramos los valores
					vim.api.nvim_create_autocmd("BufUnload", {
						group = alpha_group,
						buffer = 0,
						callback = function()
							vim.schedule(function()
								vim.opt.laststatus = 3
								vim.opt.showtabline = 2
							end)
						end,
					})
				end,
			})
		end,
	},
}
