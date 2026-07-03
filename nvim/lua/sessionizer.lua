local sessionizer = vim.fn.expand('~/.dotfiles/scripts/sessionizer')

local function sessionizer_lines(...)
 	local result = vim.system({ sessionizer, ... }, { text = true }):wait()
 	if result.code ~= 0 then return {} end
 	return vim.split(vim.trim(result.stdout or ''), '\n', { plain = true, trimempty = true })
end

local function sessionizer_one(...)
 	return sessionizer_lines(...)[1]
end

local function nvim_server_socket(name)
	return sessionizer_one('nvim-socket', name)
end

local function nvim_server_alive(socket)
	return vim.system({ 'nvim', '--server', socket, '--remote-expr', '1' }):wait().code == 0
end

local function nvim_server_sockets()
	return sessionizer_lines('nvim-sockets')
end

local function sessions()
	local sockets = nvim_server_sockets()

	local seen = {}
	local items = {}
	for _, socket in ipairs(sockets) do
		if not seen[socket] then
			seen[socket] = true
			local name = vim.fn.fnamemodify(socket, ':t'):gsub('^nvim%-', ''):gsub('%.pipe$', '')
			local current = socket == vim.v.servername
			table.insert(items, { name = name, socket = socket, current = current })
		end
	end

	if #items == 0 then
		vim.notify('No Nvim server sessions found', vim.log.levels.WARN)
		return
	end

	table.sort(items, function(a, b) return a.name < b.name end)
	vim.ui.select(items, {
		prompt = 'Nvim sessions',
		format_item = function(item)
			return (item.current and '* ' or '  ') .. item.name
		end,
	}, function(item)
		if not item or item.current then return end
		vim.fn.mkdir(vim.fn.stdpath('state'), 'p')
		vim.fn.writefile({ vim.v.servername }, vim.fn.stdpath('state') .. '/previous-server')
		vim.fn.writefile({ item.socket }, vim.fn.stdpath('state') .. '/last-server')
		vim.cmd('connect ' .. vim.fn.fnameescape(item.socket))
	end)
end

local function last_session()
	local previous_server_file = vim.fn.stdpath('state') .. '/previous-server'
	if vim.fn.filereadable(previous_server_file) == 0 then
		vim.notify('No previous Nvim server recorded', vim.log.levels.WARN)
		return
	end

	local socket = vim.fn.readfile(previous_server_file)[1]
	if not socket or socket == '' then
		vim.notify('No previous Nvim server recorded', vim.log.levels.WARN)
		return
	end

	if socket == vim.v.servername then
		vim.notify('Already attached to previous Nvim server', vim.log.levels.INFO)
		return
	end

	vim.fn.writefile({ vim.v.servername }, previous_server_file)
	vim.fn.writefile({ socket }, vim.fn.stdpath('state') .. '/last-server')
	vim.cmd('connect ' .. vim.fn.fnameescape(socket))
end

local function connect_or_start_session(dir, name)
	dir = vim.fn.fnamemodify(vim.fn.expand(dir), ':p')
	name = name:gsub('%.', '_'):gsub('[^%w_-]', '_')
	local socket = nvim_server_socket(name)

	if not nvim_server_alive(socket) then
		local log = '/tmp/nvim-' .. vim.env.USER .. '-' .. name .. '.log'
		vim.fn.jobstart({ 'nvim', '--headless', '--listen', socket }, {
			cwd = dir,
			detach = true,
			stdout = log,
			stderr = log,
		})

		local ok = vim.wait(3000, function()
			local type = vim.fn.getftype(socket)
			return type == 'socket' or type == 'fifo'
		end, 50)
		if not ok then
			vim.notify('Nvim server did not start: ' .. socket, vim.log.levels.ERROR)
			return
		end
	end

	vim.fn.writefile({ vim.v.servername }, vim.fn.stdpath('state') .. '/previous-server')
	vim.fn.writefile({ socket }, vim.fn.stdpath('state') .. '/last-server')
	vim.cmd('connect ' .. vim.fn.fnameescape(socket))
end

local function project_items()
	local items = {}
	for _, line in ipairs(sessionizer_lines('nvim-projects')) do
		local fields = vim.split(line, '\t', { plain = true })
		table.insert(items, {
			text = fields[1],
			name = fields[2],
			dir = fields[3],
			file = fields[4] ~= '' and fields[4] or nil,
		})
	end
	table.sort(items, function(a, b) return a.text < b.text end)
	return items
end

local function new_session()
	local items = project_items()
	local function select_item(item)
		if not item then return end
		connect_or_start_session(item.dir, item.name)
		if item.file then
			vim.schedule(function() vim.cmd('edit ' .. vim.fn.fnameescape(item.dir .. '/' .. item.file)) end)
		end
	end

	vim.ui.select(items, {
		prompt = 'Nvim new session',
		format_item = function(item) return item.text end,
	}, select_item)
end

vim.api.nvim_create_user_command('NvimSessions', sessions, {})
vim.api.nvim_create_user_command('NvimLastSession', last_session, {})
vim.api.nvim_create_user_command('NvimNewSession', new_session, {})
vim.keymap.set('n', '<leader>ns', sessions, { desc = '[N]vim [S]essions' })
vim.keymap.set('n', '<leader>nl', last_session, { desc = '[N]vim [L]ast session' })
vim.keymap.set('n', '<leader>nn', new_session, { desc = '[N]vim [N]ew session' })
vim.keymap.set('n', '<leader>nd', '<cmd>detach<cr>', { desc = '[N]vim [D]etach UI' })
