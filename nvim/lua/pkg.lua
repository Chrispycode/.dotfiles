-- Unified package manager: npm LSP deps + nvim plugins (vim.pack).
-- Commands: :Pkg            (menu, also bound to <leader>ln)
local M = {}

-- ---------------------------------------------------------------------------
-- Output helpers
-- ---------------------------------------------------------------------------

local function show_output(title, text)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, '\n', { plain = true }))
	vim.bo[buf].bufhidden = 'wipe'
	vim.bo[buf].filetype = 'log'
	vim.bo[buf].modifiable = false

	local w = math.floor(vim.o.columns * 0.8)
	local h = math.floor(vim.o.lines * 0.8)
	vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = w,
		height = h,
		col = math.floor((vim.o.columns - w) / 2),
		row = math.floor((vim.o.lines - h) / 2),
		border = 'rounded',
		title = ' ' .. title .. ' ',
		title_pos = 'center',
	})
	vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
end

local function input_then(prompt, fn)
	vim.ui.input({ prompt = prompt }, function(v)
		if v and v ~= '' then fn(v) end
	end)
end

-- ---------------------------------------------------------------------------
-- npm source
-- ---------------------------------------------------------------------------

local function npm(args)
	local label = 'npm ' .. table.concat(args, ' ')
	vim.notify('󰇚 ' .. label, vim.log.levels.INFO)
	vim.system(vim.list_extend({ 'npm' }, args), {
		cwd = vim.fn.stdpath('config'),
		text = true,
	}, function(obj)
		vim.schedule(function()
			local output = (obj.stdout or '') .. (obj.stderr or '')
			if output == '' then output = '(no output)' end
			show_output(label .. '  [exit ' .. obj.code .. ']', output)
		end)
	end)
end

-- ---------------------------------------------------------------------------
-- Plugins source (vim.pack)
-- ---------------------------------------------------------------------------

local function plugin_names()
	local names = {}
	for _, p in ipairs(vim.pack.get()) do
		table.insert(names, p.spec.name or p.spec.src)
	end
	table.sort(names)
	return names
end

local function plugins_list()
	local list = vim.pack.get()
	local lines = { string.format('%d plugins installed', #list), '' }
	for _, p in ipairs(list) do
		local name = p.spec.name or p.spec.src or '?'
		local active = p.active and '●' or '○'
		table.insert(lines, string.format('  %s %-40s %s', active, name, p.spec.src or ''))
	end
	show_output('Installed plugins', table.concat(lines, '\n'))
end

local function plugins_pick(prompt, fn)
	vim.ui.select(plugin_names(), { prompt = prompt }, function(n) if n then fn(n) end end)
end

-- ---------------------------------------------------------------------------
-- Action registry (flat list)
-- ---------------------------------------------------------------------------

local actions = {
	-- npm
	{ label = 'npm: List installed',     fn = function() npm({ 'ls', '--depth=0' }) end },
	{ label = 'npm: Show outdated',      fn = function() npm({ 'outdated' }) end },
	{ label = 'npm: Update all',         fn = function() npm({ 'update' }) end },
	{ label = 'npm: Reinstall (ci)',     fn = function() npm({ 'ci' }) end },
	{ label = 'npm: Audit',              fn = function() npm({ 'audit' }) end },
	{ label = 'npm: Audit signatures',   fn = function() npm({ 'audit', 'signatures' }) end },
	{ label = 'npm: Install…',           fn = function() input_then('Install: ', function(n) npm({ 'install', '--save-dev', n }) end) end },
	{ label = 'npm: Uninstall…',         fn = function() input_then('Uninstall: ', function(n) npm({ 'uninstall', n }) end) end },
	{ label = 'npm: Upgrade to latest…', fn = function() input_then('Upgrade: ', function(n) npm({ 'install', '--save-dev', n .. '@latest' }) end) end },

	-- plugins (vim.pack)
	{ label = 'plugins: List installed', fn = plugins_list },
	{ label = 'plugins: Update all',     fn = function() vim.pack.update() end },
	{ label = 'plugins: Update one…',    fn = function() plugins_pick('Update: ', function(n) vim.pack.update({ n }) end) end },
	{ label = 'plugins: Delete…',        fn = function() plugins_pick('Delete: ', function(n) vim.pack.del({ n }) end) end },
}

function M.menu()
	vim.ui.select(actions, {
		prompt = 'Package manager:',
		format_item = function(i) return i.label end,
	}, function(c) if c then c.fn() end end)
end

vim.api.nvim_create_user_command('Pkg', M.menu, { desc = 'Package manager (npm + plugins)' })
vim.keymap.set('n', '<leader>lp', M.menu, { desc = '[L]SP/Pkg [P]ackage manager' })

return M
