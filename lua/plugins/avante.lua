return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		build = "make",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope.nvim", -- selector de archivos
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
		keys = {
			{ "<leader>aa", "<cmd>AvanteToggle<CR>", desc = "Avante: Toggle sidebar" },
			{ "<leader>an", "<cmd>AvanteChatNew<CR>", desc = "Avante: Nuevo chat" },
			{ "<leader>ae", "<cmd>AvanteEdit<CR>", desc = "Avante: Editar selección" },
			{ "<leader>af", "<cmd>AvanteFocus<CR>", desc = "Avante: Enfocar sidebar" },
			{ "<leader>ar", "<cmd>AvanteRefresh<CR>", desc = "Avante: Refrescar" },
			{ "<leader>aS", "<cmd>AvanteStop<CR>", desc = "Avante: Detener generación" },
		},
		config = function()
			local opencode_bin = vim.fn.exepath("opencode")
			require("avante").setup({
				provider = "opencode",
				acp_providers = {
					["opencode"] = {
						command = opencode_bin ~= "" and opencode_bin or "opencode",
						args = { "acp" },
						env = {
							NODE_NO_WARNINGS = "1",
							PATH = vim.env.PATH,
						},
					},
				},
				mode = "agentic",
				system_prompt = [[Eres un asistente de programación atómico, minimalista e incremental. Tu único objetivo es trabajar bloque por bloque, bajo la estricta dirección del usuario y dentro del buffer de texto activo.

### Infraestructura y entornos (prohibición absoluta de acción)
- NUNCA ejecutes ni sugieras comandos de terminal de ningún tipo.
- NUNCA crees ni manipules entornos virtuales (venv, conda, bun, etc.).
- NUNCA toques ni ejecutes comandos de Git (git init, git add, git commit, etc.). La gestión del repositorio y de versiones es 100% responsabilidad del usuario.
- NUNCA generes archivos de configuración de entorno, automatización o ignorados (.gitignore, .env, Dockerfile) a menos que el usuario los pida explícitamente dentro de la ventana de chat.

### Trabajo en código (estrictamente atómico)
- MODO ARCHIVO ÚNICO: Trabaja ÚNICAMENTE en el archivo o bloque de código que el usuario tiene abierto o especifica. NUNCA crees múltiples archivos, módulos extras o archivos auxiliares.
- MODO BLOQUE POR BLOQUE: Si el usuario te pide implementar una función, clase o variable, escribe SOLAMENTE esa entidad en su forma más simple y directa.
- PROHIBIDO PROSPECTAR: No agregues lógica futura, llamadas de prueba (main/test), funciones secundarias, refactorizaciones ni abstracciones no solicitadas (Keep It Simple).
- ESTRUCTURA PRIMERO: Si el usuario te da una instrucción amplia (ej. "hagamos la función de pagos"), escribe SOLAMENTE la firma/estructura base y genera 1 o 2 preguntas breves sobre los parámetros o lógica de negocio antes de implementar el cuerpo.
- ESPERA CONFIRMACIÓN: No avances al siguiente paso sin una instrucción explícita del usuario.

### Formato de respuesta
- CERO PREÁMBULOS: No saludes, no digas "¡Claro!", ni expliques lo que vas a hacer.
- CERO RESÚMENES: No cierres la respuesta con conclusiones ni notas explicativas innecesarias.
- ENTREGABLE DIRECTO: Muestra únicamente el fragmento de código solicitado en Markdown.
- DUDAS / AMBIGÜEDAD: Si falta información crítica, limita tu respuesta a 1-2 preguntas directas y espera a que el usuario responda.]],
				behaviour = {
					auto_suggestions = false,
					-- NO auto-aplicar los bloques de código del chat: con ACP el agente
					-- ya aplica sus cambios con herramientas y esto duplica el código
					-- insertando marcadores de conflicto (corrupción).
					auto_apply_diff_after_generation = false,
					minimize_diff = true,
					enable_token_counting = false,
					auto_add_current_file = true,
					auto_set_keymaps = true,
					auto_set_highlight_group = true,
					auto_approve_tool_permissions = false,
					confirmation_ui_style = "inline_buttons",
				},
				selection = {
					enabled = true,
					hint_display = "delayed",
				},
				selector = {
					provider = "telescope",
				},
				windows = {
					position = "right",
					wrap = true,
					width = 30,
					sidebar_header = {
						enabled = true,
						align = "center",
						rounded = true,
					},
				},
				highlights = {
					diff = {
						current = "DiffText",
						incoming = "DiffAdd",
					},
				},
			})

			-- Ocultar el "thinking" de la IA en el sidebar (solo visual).
			-- Los datos siguen en el historial; no se borran ni se dejan de enviar.
			local ok, render = pcall(require, "avante.history.render")
			if ok and render and render.message_to_lines then
				local orig_message_to_lines = render.message_to_lines
				render.message_to_lines = function(message, messages, expanded)
					local content = message.message.content
					if type(content) == "table" then
						local new_content, collapsed = {}, false
						for _, item in ipairs(content) do
							if
								type(item) == "table"
								and (item.type == "thinking" or item.type == "redacted_thinking")
							then
								local text = item.thinking or item.data or ""
								local lineas = #vim.split(text, "\n")
								table.insert(new_content, {
									type = "text",
									text = "🤔 Pensamiento oculto (" .. lineas .. " líneas)",
								})
								collapsed = true
							else
								table.insert(new_content, item)
							end
						end
						if collapsed then
							local copy = vim.tbl_extend("keep", {}, message)
							copy.message = vim.tbl_extend("keep", {}, message.message)
							copy.message.content = new_content
							return orig_message_to_lines(copy, messages, expanded)
						end
					end
					return orig_message_to_lines(message, messages, expanded)
				end
			end

			-- Cerrar las ventanas de avante al cerrar el buffer principal de código,
			-- o cuando ya no queda ningún archivo real abierto en la pestaña.
			local close_group = vim.api.nvim_create_augroup("AvanteCloseOnBuffer", { clear = true })

			local function get_sidebar()
				return require("avante").get(false)
			end

			-- Recarga "en vivo" de buffers mientras avante esté abierto: opencode
			-- (ACP) escribe los archivos en disco con sus propias tools y nvim no
			-- lo detecta. El evento AvanteViewBufferUpdated solo se emite al
			-- terminar la generación, así que un timer con checktime periódico
			-- permite ver los cambios en tiempo real en cualquier buffer.
			local reload_timer
			local function start_live_reload()
				if reload_timer then return end
				reload_timer = vim.uv.new_timer()
				reload_timer:start(0, 300, vim.schedule_wrap(function()
					pcall(function()
						if get_sidebar() and get_sidebar():is_open() then
							pcall(vim.cmd, "checktime")
						end
					end)
				end))
			end

			local function stop_live_reload()
				if reload_timer then
					reload_timer:stop()
					reload_timer:close()
					reload_timer = nil
				end
			end

			local function close_sidebar()
				local sidebar = get_sidebar()
				if sidebar and sidebar:is_open() then
					stop_live_reload()
					sidebar:close()
				end
			end

			-- Recargar los buffers desde disco cuando el agente termina de generar:
			-- opencode (ACP) escribe los archivos con sus propias tools y avante solo
			-- navega a la ubicación, no refresca el buffer.
			vim.api.nvim_create_autocmd("User", {
				group = close_group,
				pattern = "AvanteViewBufferUpdated",
				callback = function()
					vim.defer_fn(function() pcall(vim.cmd, "checktime") end, 50)
				end,
			})

			-- Activar la recarga "en vivo" al enviar un mensaje o edición, y
			-- desactivarla cuando el sidebar se cierre (ver close_sidebar).
			vim.api.nvim_create_autocmd("User", {
				group = close_group,
				pattern = { "AvanteInputSubmitted", "AvanteEditSubmitted" },
				callback = function() start_live_reload() end,
			})

			-- No cerrar el sidebar mientras el usuario esté escribiendo código
			-- manualmente: modo insert/visual o un buffer con cambios sin guardar.
			local function is_editing_in_progress()
				if vim.fn.mode(1):match("^[iRcv]") then return true end
				local buf = vim.api.nvim_get_current_buf()
				if
					vim.api.nvim_buf_is_valid(buf)
					and vim.api.nvim_buf_get_option(buf, "modified")
				then
					return true
				end
				return false
			end

			local function close_if_main_buffer(bufnr)
				if is_editing_in_progress() then return end
				pcall(function()
					local sidebar = get_sidebar()
					if sidebar and sidebar.code and sidebar.code.bufnr == bufnr then
						close_sidebar()
					end
				end)
			end

			local function has_real_file_window()
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_get_config(win).relative == "" then
						local buf = vim.api.nvim_win_get_buf(win)
						if
							vim.api.nvim_buf_is_valid(buf)
							and vim.api.nvim_buf_get_option(buf, "buftype") == ""
							and vim.api.nvim_buf_get_name(buf) ~= ""
						then
							return true
						end
					end
				end
				return false
			end

			local function close_if_no_files_left()
				vim.defer_fn(function()
					pcall(function()
						if is_editing_in_progress() then return end
						if not has_real_file_window() then close_sidebar() end
					end)
				end, 20)
			end

			vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
				group = close_group,
				callback = function(args)
					close_if_main_buffer(args.buf)
					close_if_no_files_left()
				end,
			})
			vim.api.nvim_create_autocmd({ "WinClosed", "QuitPre" }, {
				group = close_group,
				callback = function()
					if is_editing_in_progress() then return end
					pcall(function()
						local sidebar = get_sidebar()
						local cur_buf = vim.api.nvim_get_current_buf()
						if
							sidebar
							and sidebar.code
							and sidebar.code.bufnr == cur_buf
							and #vim.fn.win_findbuf(cur_buf) <= 1
						then
							close_sidebar()
						end
					end)
					close_if_no_files_left()
				end,
			})
		end,
	},
}
