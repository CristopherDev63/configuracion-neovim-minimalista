local M = {}

function M.run_file()
	local file = vim.fn.expand("%")
	if not file:match("%.py$") then
		print("No es un archivo .py")
		return
	end

	vim.cmd("write")

	local cmd = "python3 " .. vim.fn.shellescape(file)
	local output = vim.fn.systemlist(cmd)
	local lines = {}

	for _, line in ipairs(output) do
		table.insert(lines, line)
	end

	if #lines == 0 then
		lines = { "(sin salida)" }
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].filetype = "pythonoutput"

	local width = math.min(vim.o.columns - 4, 80)
	local height = math.min(#lines + 2, vim.o.lines - 5)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Python Output ",
		title_pos = "center",
	})

	vim.api.nvim_win_set_option(win, "wrap", false)
	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { silent = true })
end

function M.run_selection()
	vim.cmd('noau normal! "vy"')
	local code = vim.fn.getreg("v")
	if code == "" then
		print("Selecciona código primero")
		return
	end

	local tmp = vim.fn.tempname() .. ".py"
	local f = io.open(tmp, "w")
	if f then
		f:write(code)
		f:close()
	end

	local output = vim.fn.systemlist("python3 " .. vim.fn.shellescape(tmp))
	vim.fn.delete(tmp)

	if #output == 0 then
		output = { "(sin salida)" }
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"

	local width = math.min(vim.o.columns - 4, 80)
	local height = math.min(#output + 2, vim.o.lines - 5)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Python Selection ",
		title_pos = "center",
	})

	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { silent = true })
end

return M
