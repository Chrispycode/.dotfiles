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
-- Generic command runner
-- ---------------------------------------------------------------------------

local function run(cmd, args, opts)
	opts = opts or {}
	local label = cmd .. ' ' .. table.concat(args, ' ')
	vim.notify('󰇚 ' .. label, vim.log.levels.INFO)
	vim.system(vim.list_extend({ cmd }, args), {
		cwd = opts.cwd or vim.fn.stdpath('config'),
		env = opts.env,
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
-- npm source
-- ---------------------------------------------------------------------------

local function npm(args) run('npm', args) end

-- ---------------------------------------------------------------------------
-- bundle source (only enabled if GLOBAL_GEMFILE is set)
-- ---------------------------------------------------------------------------

local global_gemfile = vim.env.GLOBAL_GEMFILE
local function bundle(args)
	run('bundle', args, {
		cwd = vim.fn.fnamemodify(global_gemfile, ':h'),
		env = { BUNDLE_GEMFILE = global_gemfile },
	})
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

local has_bundle = global_gemfile and global_gemfile ~= ''

-- Run multiple jobs concurrently, rendering live status into one floating buffer.
-- A job is either:
--   { name = 'npm update', cmd = 'npm', args = { 'update' }, cwd = …, env = … }
--   { name = 'plugins',    fn  = function() vim.pack.update() end, note = '…' }
local function run_all(title, jobs)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = 'wipe'
	vim.bo[buf].filetype = 'log'

	local w = math.floor(vim.o.columns * 0.8)
	local h = math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(buf, true, {
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

	local state = {}
	for i, job in ipairs(jobs) do
		state[i] = { name = job.name, status = 'running', output = '' }
	end

	local icons = { running = '⏳', done = '✓', failed = '✗', info = 'ℹ' }

	local function render()
		if not vim.api.nvim_buf_is_valid(buf) then return end
		local running = 0
		for _, s in ipairs(state) do
			if s.status == 'running' then running = running + 1 end
		end
		local header = running > 0
			and string.format('%d/%d still running…', running, #state)
			or string.format('all %d done', #state)
		local lines = { header, '' }
		for _, s in ipairs(state) do
			table.insert(lines, string.format('%s %s', icons[s.status], s.name))
			if s.output ~= '' then
				for _, l in ipairs(vim.split(s.output, '\n', { plain = true })) do
					table.insert(lines, '    ' .. l)
				end
			end
			table.insert(lines, '')
		end
		vim.bo[buf].modifiable = true
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		vim.bo[buf].modifiable = false
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_set_config(win, {
				title = ' ' .. title .. (running > 0 and ' (running)' or ' (done)') .. ' ',
			})
		end
	end

	render()

	for i, job in ipairs(jobs) do
		if job.fn then
			job.fn()
			state[i].status = 'info'
			state[i].output = job.note or ''
			render()
		else
			vim.system(vim.list_extend({ job.cmd }, job.args), {
				cwd = job.cwd,
				env = job.env,
				text = true,
			}, function(obj)
				vim.schedule(function()
					state[i].status = obj.code == 0 and 'done' or 'failed'
					local out = ((obj.stdout or '') .. (obj.stderr or '')):gsub('%s+$', '')
					state[i].output = out ~= '' and out or '(no output)'
					render()
				end)
			end)
		end
	end
end

local function bundle_job(name, args)
	return {
		name = name,
		cmd = 'bundle',
		args = args,
		cwd = vim.fn.fnamemodify(global_gemfile, ':h'),
		env = { BUNDLE_GEMFILE = global_gemfile },
	}
end

local function update_all()
	local jobs = {
		{ name = 'plugins update', fn = function() vim.pack.update() end,
		  note = '(see vim.pack confirm window)' },
		{ name = 'npm update', cmd = 'npm', args = { 'update' },
		  cwd = vim.fn.stdpath('config') },
	}
	if has_bundle then table.insert(jobs, bundle_job('bundle update', { 'update' })) end
	run_all('Update all', jobs)
end

local function audit_all()
	local jobs = {
		{ name = 'npm audit', cmd = 'npm', args = { 'audit' },
		  cwd = vim.fn.stdpath('config') },
	}
	if has_bundle then
		if vim.fn.executable('bundle-audit') == 1 then
			table.insert(jobs, bundle_job('bundle-audit check', { 'audit', 'check', '--update' }))
		else
			table.insert(jobs, bundle_job('bundle outdated (install bundler-audit for CVE checks)',
				{ 'outdated' }))
		end
	end
	run_all('Audit all', jobs)
end

local actions = {
	-- combined
	{ label = 'all: Update all',         fn = update_all },
	{ label = 'all: Audit all',          fn = audit_all },

	-- npm
	{ label = 'npm: List installed',     fn = function() npm({ 'ls', '--depth=0' }) end },
	{ label = 'npm: Show outdated',      fn = function() npm({ 'outdated' }) end },
	{ label = 'npm: Update (dry run)',   fn = function() npm({ 'update', '--dry-run' }) end },
	{ label = 'npm: Update all',         fn = function() npm({ 'update' }) end },
	{ label = 'npm: Install…',           fn = function() input_then('Install: ', function(n) npm({ 'install', '--save-dev', n }) end) end },
	{ label = 'npm: Uninstall…',         fn = function() input_then('Uninstall: ', function(n) npm({ 'uninstall', n }) end) end },

	-- plugins (vim.pack)
	{ label = 'plugins: List installed', fn = plugins_list },
	{ label = 'plugins: Update all',     fn = function() vim.pack.update() end },
	{ label = 'plugins: Update one…',    fn = function() plugins_pick('Update: ', function(n) vim.pack.update({ n }) end) end },
	{ label = 'plugins: Delete…',        fn = function() plugins_pick('Delete: ', function(n) vim.pack.del({ n }) end) end },
}

-- bundle (only available when $GLOBAL_GEMFILE is set)
if has_bundle then
	vim.list_extend(actions, {
		{ label = 'bundle: List installed', fn = function() bundle({ 'list' }) end },
		{ label = 'bundle: Show outdated',  fn = function() bundle({ 'outdated' }) end },
		{ label = 'bundle: Update all',     fn = function() bundle({ 'update' }) end },
		{ label = 'bundle: Install',        fn = function() bundle({ 'install' }) end },
	})
end

function M.menu()
	vim.ui.select(actions, {
		prompt = 'Package manager:',
		format_item = function(i) return i.label end,
	}, function(c) if c then c.fn() end end)
end

vim.api.nvim_create_user_command('Pkg', M.menu, { desc = 'Package manager (npm + plugins)' })
vim.keymap.set('n', '<leader>lp', M.menu, { desc = '[L]SP/Pkg [P]ackage manager' })

return M
