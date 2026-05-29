-- snacks.nvim
vim.pack.add({
	{ src = 'https://github.com/folke/snacks.nvim' },
})

local file_ignore_patterns = {
	'node_modules', 'tmp', 'log', '.git', '.bundle', 'public/plugin_assets',
	'.idea', '.loadpath', '.powrc', '.rvmc', '.ruby-version', 'db/*.db', 'db/*.sqlite3*',
	'vendor/cache', 'files', '_cacache', '.cache', '*.o', '*.a', '*.min.*', '*.min-*.*',
	'*.out', '*.class', '*.pdf', '*.mkv', '*.mp4', '*.zip', 'plugins_*', 'modules_*', '*.db', '*_bu',
	'*.venv', '*.pycache', 'dist',
	'*.sqlite3', '*.sqlite', '*.sql', '*.pyc', '*.pyo', '*.lock', '*cache', '*.gem', '*.jar', '*.war',
}

require('snacks').setup({
	image = {},
	bigfile = {},
	notifier = {},
	zen = {},
	explorer = {},
	git = {},
	indent = {},
	scope = {},
	animate = {},
	lazygit = {},
	quickfile = {},
	scratch = {},
	picker = {
		include = { "plugins/*", "modules/*" },
		sources = {
			files = { ignored = true, hidden = true, exclude = file_ignore_patterns },
			explorer = {
				ignored = true,
				hidden = true,
				auto_close = true,
				actions = {
					toggle_dir = function(picker, item)
						if item.dir then picker:action('confirm') end
					end,
				},
			},
			grep = { ignored = true, hidden = true, exclude = file_ignore_patterns },
			grep_word = { ignored = true, hidden = true, exclude = file_ignore_patterns },
			grep_buffers = { ignored = true, hidden = true, exclude = file_ignore_patterns },
		},
		formatters = {
			file = { truncate = 200 },
		},
	},
	dashboard = {
		preset = {
			keys = {
				{ icon = "", key = "n", desc = "New file", action = "<cmd>ene<CR>" },
				{ icon = "󰅚", key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
			},
			header = [[
  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒
 ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░
▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██
 ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
 ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
 ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░
    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░
          ░    ░  ░    ░ ░        ░   ░         ░
                                 ░                  ]],
		},
		sections = {
			{ section = "header", padding = 1 },
			{ section = "startup", padding = 1 },
			function()
				local version = vim.version()
				return {
					align = 'center',
					text = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch,
					padding = 1,
				}
			end,
			{ section = "keys", padding = 1 },
			{ icon = " ", title = "Recent Files", section = "recent_files", cwd = true, indent = 2, padding = 1 },
		},
	},
})

local map = function(lhs, rhs, desc, opts)
	opts = opts or {}
	local mode = opts.mode or 'n'
	opts.mode = nil
	opts.desc = desc
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- Pickers / general
map('<leader><space>', function() Snacks.picker.buffers() end, 'Buffers')
map('<leader>,',       function() Snacks.picker.smart() end, 'Smart Find Files')
map('<leader>/',       function() Snacks.picker.grep() end, 'Grep')
map('<leader>:',       function() Snacks.picker.command_history() end, 'Command History')
map('<leader>n',       function() Snacks.picker.notifications() end, 'Notification History')

-- find
map('<leader>sf', function() Snacks.picker.files() end, 'Find Files')
map('<leader>pf', function() Snacks.picker.files({ cwd = 'plugins' }) end, 'Find Files (plugins)')
map('<leader>fg', function() Snacks.picker.git_files() end, 'Find Git Files')
map('<leader>fr', function() Snacks.picker.recent() end, 'Recent')

-- git
map('<leader>gB', function() Snacks.picker.git_branches({ cwd = vim.fn.expand('%:p:h') }) end, 'Git Branches')
map('<leader>gl', function() Snacks.picker.git_log({ cwd = vim.fn.expand('%:p:h') }) end, 'Git Log')
map('<leader>gL', function() Snacks.picker.git_log_line({ cwd = vim.fn.expand('%:p:h') }) end, 'Git Log Line')
map('<leader>gs', function() Snacks.picker.git_status({ cwd = vim.fn.expand('%:p:h') }) end, 'Git Status')
map('<leader>gS', function() Snacks.picker.git_stash({ cwd = vim.fn.expand('%:p:h') }) end, 'Git Stash')
map('<leader>gd', function() Snacks.picker.git_diff({ cwd = vim.fn.expand('%:p:h') }) end, 'Git Diff (Hunks)')
map('<leader>gf', function() Snacks.picker.git_log_file({ cwd = vim.fn.expand('%:p:h') }) end, 'Git Log File')
map('<leader>gb', function() Snacks.git.blame_line({ cwd = vim.fn.expand('%:p:h') }) end, 'Git Blame Line')
map('<leader>lg', function() Snacks.lazygit({ cwd = vim.fn.expand('%:p:h') }) end, 'LazyGit')

-- Grep
map('<leader>sB', function() Snacks.picker.grep_buffers() end, 'Grep Open Buffers')
map('<leader>sg', function() Snacks.picker.grep() end, 'Grep')
map('<leader>pg', function() Snacks.picker.grep({ cwd = 'plugins' }) end, 'Grep (plugins)')
map('<leader>sw', function() Snacks.picker.grep_word() end, 'Visual selection or word', { mode = { 'n', 'x' } })

-- search in arbitrary directory
map('<leader>si', function()
	local find_cmd = "find . -type d -not -path '*/\\.*'"
	local dirs = {}
	local handle = io.popen(find_cmd)
	if handle then
		for entry in handle:lines() do
			local d = entry:gsub("^%./", "")
			if d ~= "" then table.insert(dirs, d) end
		end
		handle:close()
	end
	vim.ui.select(dirs, {
		prompt = "Select directory to search:",
		format_item = function(item) return item end,
	}, function(choice)
		if not choice then return end
		local dir = vim.fn.fnamemodify(choice, ":p")
		if vim.fn.isdirectory(dir) == 1 then
			Snacks.picker.grep({ cwd = dir })
		else
			vim.notify("Invalid directory: " .. dir, vim.log.levels.ERROR)
		end
	end)
end, 'Search in Directory')

map('<leader>ic', function() Snacks.picker.icons() end, 'icons')
map('<leader>s"', function() Snacks.picker.registers() end, 'Registers')
map('<leader>s/', function() Snacks.picker.search_history() end, 'Search History')
map('<leader>sa', function() Snacks.picker.autocmds() end, 'Autocmds')
map('<leader>sl', function() Snacks.picker.lines() end, 'Buffer Lines')
map('<leader>sc', function() Snacks.picker.command_history() end, 'Command History')
map('<leader>sC', function() Snacks.picker.commands() end, 'Commands')
map('<leader>sd', function() Snacks.picker.diagnostics() end, 'Diagnostics')
map('<leader>sD', function() Snacks.picker.diagnostics_buffer() end, 'Buffer Diagnostics')
map('<leader>sh', function() Snacks.picker.help() end, 'Help Pages')
map('<leader>sH', function() Snacks.picker.highlights() end, 'Highlights')
map('<leader>sj', function() Snacks.picker.jumps() end, 'Jumps')
map('<leader>sk', function() Snacks.picker.keymaps() end, 'Keymaps')
map('<leader>sm', function() Snacks.picker.marks() end, 'Marks')
map('<leader>sM', function() Snacks.picker.man() end, 'Man Pages')
map('<leader>sq', function() Snacks.picker.qflist() end, 'Quickfix List')
map('<leader>so', function() Snacks.picker.resume() end, 'Resume')
map('<leader>su', function() Snacks.picker.undo() end, 'Undo History')
map('<leader>uC', function() Snacks.picker.colorschemes() end, 'Colorschemes')

-- LSP pickers
map('gd', function() Snacks.picker.lsp_definitions() end, 'Goto Definition')
map('gD', function() Snacks.picker.lsp_declarations() end, 'Goto Declaration')
map('gr', function() Snacks.picker.lsp_references() end, 'References', { nowait = true })
map('gI', function() Snacks.picker.lsp_implementations() end, 'Goto Implementation')
map('gy', function() Snacks.picker.lsp_type_definitions() end, 'Goto T[y]pe Definition')
map('<leader>ss', function() Snacks.picker.lsp_symbols() end, 'LSP Symbols')
map('<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, 'LSP Workspace Symbols')

-- scratch
map('<leader>.', function() Snacks.scratch() end, 'Toggle Scratch Buffer')
map('<leader>S', function() Snacks.scratch.select() end, 'Select Scratch Buffer')

-- misc
map('<leader>k',  function() Snacks.explorer() end, 'File Explorer')
map('<leader>lb', function() Snacks.dashboard.open() end, 'Dash[b]oard')
map('<leader>lz', function() Snacks.zen() end, 'ZenMode')
map('<leader>ls', function() Snacks.picker.spelling() end, 'Spelling')
map('<leader>tn', '<cmd>tabnew<cr>', 'new Tab')
map('<leader>lw', ':set wrap<cr>', 'Toggle Wrap')
map('<leader>fl', ':setlocal foldlevel=', 'Set specific foldlevel')
map('<Esc>',      '<cmd>nohlsearch<CR>', 'cancel search')
map('<leader>q',  function() vim.diagnostic.setloclist() end, 'Open diagnostic [Q]uickfix list')
map('<C-h>', '<C-w><C-h>', 'Move focus to the left window')
map('<C-l>', '<C-w><C-l>', 'Move focus to the right window')
map('<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
map('<C-k>', '<C-w><C-k>', 'Move focus to the upper window')
