-- markview.nvim is loaded only on markdown filetype

vim.pack.add({
	{ src = 'https://github.com/OXY2DEV/markview.nvim' },
}, { load = false })

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'markdown', 'quarto', 'rmd' },
	once = true,
	group = vim.api.nvim_create_augroup('user-markview-load', { clear = true }),
	callback = function()
		vim.cmd('packadd markview.nvim')
		require('markview').setup({
			preview = {
				filetypes = { 'markdown', 'quarto', 'rmd' },
				ignore_buftypes = {},
			},
		})
	end,
})

-- Sublime Text / VS Code style multiple cursors (Ctrl-D-like) on top of
-- Neovim's native multicursor feature (:help mcursor, needs 0.13+ nightly).
-- Mappings:
--   <C-n>      Normal: session on <cword>; Visual: on the selection. Every
--              further press pins the current occurrence as a cursor and
--              selects the next one, in buffer order (wrapping). The
--              selection is established via 'gn', which the native engine
--              dry-replays at every cursor, so ALL cursors show their own
--              selection at once (vim-visual-multi look).
--   g<C-n>     add a cursor at every occurrence at once (native 'zqgn')
--   <Tab>      toggle «cursor»/«extend» mode: in extend mode the Visual
--              selection is on at every cursor, in cursor mode commands
--              behave as in Normal mode (the cursors are kept)
--   i/a        in extend mode: insert at the start/end of every selection
--   <Esc>      Normal: end the session (clears all cursors)
-- Native commands, available while a session is active:
--   ciw / daw / yiw ...   operators and mappings replay at every cursor
--   i/a/I/A ...           insert at every cursor (from extend mode too;
--                         i/a insert at each selection start/end)
--   zq{motion}            a cursor at every motion target: "zqw" every word,
--                         "zqgn" every match; "gv" then selects the match at
--                         each cursor ("zq*gvc" changes every match)
--   Q / <C-LeftMouse>     toggle a cursor manually (1Q adds, 2Q removes) /
--                         by clicking
--   ]C / [C               jump between cursors ("]CQ" removes one at a time)
--   g CTRL-A              insert ascending numbers at the cursors
--   gQ                    restore previously cleared cursors
--   CTRL-L                clears multicursors (shadowed if <C-l> is remapped)
--   q=                    toggle follow mode: motions replay at every cursor
-- Undo is atomic: one `u` reverts the edits of all cursors at once.

local ns = vim.api.nvim_create_namespace 'nvim.multicursor'

-- Reverse renders cursors as solid blocks (the default hl-MCursor link is
-- invisible on low-contrast palettes). hl-MCursorVisual has no default at
-- all, so the per-cursor selections would stay invisible. mini.lua re-applies
-- both on every palette reload; this is the fallback for plain :colorscheme.
local function set_mcursor_hl()
	vim.api.nvim_set_hl(0, 'MCursor', { reverse = true, bold = true })
	vim.api.nvim_set_hl(0, 'MCursorVisual', { link = 'Visual' })
end
set_mcursor_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('user-multicursor-hl', { clear = true }),
	callback = set_mcursor_hl,
})

local function cursors()
	return vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
end

-- The primary cursor plus all extra cursors, as { lnum, byteidx }.
local function cursor_list()
	local list = { { vim.fn.line '.', vim.fn.col '.' - 1 } }
	for _, m in ipairs(cursors()) do
		list[#list + 1] = { m[2] + 1, m[3] }
	end
	return list
end

local function pattern()
	return vim.b.mc_pattern or vim.fn.getreg '/'
end

local function session_active()
	return vim.b.mc_session == true
end

local function notify(msg)
	vim.notify('multicursor: ' .. msg, vim.log.levels.WARN)
end

-- Add a cursor at { lnum, col0 } (an extmark in the multicursor namespace).
local function add_cursor(lnum, col)
	vim.api.nvim_buf_set_extmark(0, ns, lnum - 1, col, {})
end

-- Synchronous and without draining the typeahead: feedkeys('x') would run
-- nested and swallow the user's next keystroke. :normal expands special keys
-- only via :execute, hence the raw keycode in the argument.
local function exit_visual()
	vim.fn.execute('normal! ' .. vim.keycode '<Esc>')
end

-- Forward-declared: the Visual-mode i/a mappings set around a session
-- (defined further below, after their dependencies).
local set_insert_maps, restore_insert_maps

local function clear()
	-- Deleting the extmarks ends the session (restores 'q=' off).
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
	vim.b.mc_session = nil
	vim.cmd 'nohlsearch'
	restore_insert_maps()
end

-- The match containing/behind the cursor, with the cursor aligned at the
-- match start. Returns { lnum, col0 }, or nil.
local function align_primary(pat, align)
	if align then
		vim.api.nvim_win_set_cursor(0, align)
		return align
	end
	local pos = vim.fn.searchpos(pat, 'bcn')
	if pos[1] == 0 then
		return nil
	end
	vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] - 1 })
	return { pos[1], pos[2] - 1 }
end

local function start(pat, align, text)
	set_insert_maps()
	vim.b.mc_session = true
	vim.b.mc_pattern = pat
	vim.b.mc_text = text
	vim.fn.setreg('/', pat)
	vim.o.hlsearch = false -- the per-cursor selections are the feedback;
	                       -- hl-Search would cover them
	return align_primary(pat, align)
end

-- Select the match the cursor sits on via 'gn': treated as typed, so the
-- Visual atom accumulates the keys and the native engine dry-replays them at
-- every cursor, giving each cursor its own selection highlight.
local function enter_visual(s)
	vim.api.nvim_win_set_cursor(0, { s[1], s[2] })
	vim.api.nvim_feedkeys(vim.keycode 'gn', 'nt', false)
end

-- Every match of the pattern in buffer order, as { start, last }, each
-- { lnum, col0 }. The cursor is moved for searching but restored exactly.
local function match_list(pat)
	local matches = {}
	local view = vim.fn.winsaveview()
	vim.fn.setpos('.', { 0, 1, 1, 0 })
	local s = vim.fn.searchpos(pat, 'cW')
	while s[1] ~= 0 do
		local e = vim.fn.searchpos(pat, 'ceW') -- end of the same match
		local m = { { s[1], s[2] - 1 }, e[1] ~= 0 and { e[1], e[2] - 1 } or { s[1], s[2] - 1 } }
		matches[#matches + 1] = m
		vim.fn.setpos('.', { 0, m[2][1], m[2][2] + 1, 0 })
		s = vim.fn.searchpos(pat, 'cW')
	end
	vim.fn.winrestview(view)
	return matches
end

-- True if the cursor { lnum, col0 } lies within the match span m (multi-line
-- matches included).
local function covers(m, c)
	return (c[1] > m[1][1] or (c[1] == m[1][1] and c[2] >= m[1][2]))
			and (c[1] < m[2][1] or (c[1] == m[2][1] and c[2] <= m[2][2]))
end

-- Add a cursor at the next uncovered occurrence after the primary one
-- (buffer order, wrapping). Returns the added match start, or nil. The cursor
-- is moved for searching but restored exactly, so the mapping itself never
-- moves the primary (and thus never replays at every cursor).
local function add_next()
	local pat = pattern()
	if pat == '' then
		notify 'no search pattern'
		return
	end
	local primary = { vim.fn.line '.', vim.fn.col '.' - 1 }
	local list = cursor_list()
	local matches = match_list(pat)
	-- Index of the match containing the primary cursor (0 if off-match), so
	-- "next" starts the cyclic scan after it. Off-match: after the last match
	-- before the cursor.
	local k = 0
	for i, m in ipairs(matches) do
		if covers(m, primary) then
			k = i
			break
		end
		k = (m[1][1] < primary[1] or (m[1][1] == primary[1] and m[1][2] <= primary[2]))
				and i or i - 1
	end
	for j = 1, #matches do
		local m = matches[((k + j - 1) % #matches) + 1]
		local covered = false
		for _, c in ipairs(list) do
			if covers(m, c) then
				covered = true
				break
			end
		end
		if not covered then
			add_cursor(m[1][1], m[1][2])
			vim.api.nvim_echo({ { ('multicursor: %d cursors'):format(#list + 1) } }, false, {})
			return m[1]
		end
	end
	notify 'no more occurrences'
end

-- The Visual selection as a literal multi-line pattern, or nil.
local function selection()
	local mode = vim.fn.mode()
	if mode == '\22' then
		notify 'block selections are not supported (use {Visual}Q for column cursors)'
		return nil
	end
	local lines = vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = mode })
	if #lines == 0 then
		return nil
	end
	for i, line in ipairs(lines) do
		lines[i] = vim.fn.escape(line, '\\')
	end
	local text = table.concat(lines, '\\n')
	return text ~= '' and text or nil
end

local function select_word()
	local word = vim.fn.expand '<cword>'
	if word == '' then
		notify 'no word under cursor'
		return nil
	end
	return start('\\V\\C\\<' .. vim.fn.escape(word, '\\') .. '\\>', nil, word)
end

-- Pin the primary's own occurrence as a cursor, so it stays covered when the
-- selection walks away to the next occurrence.
local function add_next_and_walk()
	-- Extending: follow mode off (in extend mode motions extend the
	-- per-cursor selections natively, and a cursor-moving mapping with
	-- follow on replays itself at every cursor).
	vim.cmd 'normal! 2q='
	local pos = vim.fn.searchpos(pattern(), 'bcn')
	if pos[1] ~= 0 then
		add_cursor(pos[1], pos[2] - 1)
	end
	local s = add_next()
	if s then
		enter_visual(s)
	else
		-- Exhausted: re-select the primary's own occurrence, staying in Visual.
		local sp = align_primary(pattern(), nil)
		if sp then
			enter_visual(sp)
		end
	end
end

-- Extend a running session: all = a cursor at every occurrence (native
-- 'zqgn'), else the next one with the selection walking onto it.
local function extend(all)
	if all then
		vim.api.nvim_feedkeys(vim.keycode('zqgn'), 'nt', false)
	else
		add_next_and_walk()
	end
end

-- i/a in extend mode (vim-visual-multi): insert at the start/end of each
-- cursor's own selection. The insert-cascade replays the typed spans at
-- every cursor, but also replays THIS mapping (it moved the cursor): the
-- replay is ignored, the spans apply anyway. For 'a' the cursors are moved
-- to their match ends first (where 'a' appends); they sit at the match
-- starts, where 'i' inserts. Text objects (iw, i(, …) are sacrificed while a
-- session is active, like in vim-visual-multi.
local function insert_from_extend(append)
	if vim.api.nvim__mcursor_cascading() then
		return -- replayed at a cursor by the insert cascade: ignore
	end
	if append then
		local matches = match_list(pattern())
		for _, m in ipairs(cursors()) do
			local pos = { m[2] + 1, m[3] }
			for _, mm in ipairs(matches) do
				if covers(mm, pos) then
					vim.api.nvim_buf_del_extmark(0, ns, m[1])
					add_cursor(mm[2][1], mm[2][2])
					break
				end
			end
		end
		-- the cursor sits on the selection's last char: 'a' appends after it
		vim.api.nvim_feedkeys(vim.keycode '<Esc>a', 'nt', false)
	else
		-- 'o' jumps to the selection anchor (the match start), where 'i'
		-- inserts; 'o<Esc>' terminates the Visual atom with every cursor at
		-- ITS match start, so the insert spans land there
		vim.api.nvim_feedkeys(vim.keycode 'o<Esc>i', 'nt', false)
	end
end

-- i/a in Visual mode are only mapped while a session is active, so the
-- built-in text-object prefixes (iw, i(, …) and plugins mapping them
-- (mini.ai) are unaffected outside a session. Pre-existing mappings are
-- saved before and restored after the session.
local saved_insert_maps = nil

set_insert_maps = function()
	if not saved_insert_maps then
		saved_insert_maps = {}
		for _, k in ipairs { 'i', 'a' } do
			local d = vim.fn.maparg(k, 'x', false, true)
			if not vim.tbl_isempty(d) then
				saved_insert_maps[k] = d
			end
		end
	end
	vim.keymap.set('x', 'i', function()
		insert_from_extend(false)
	end, { desc = 'Multicursor: insert at each selection start' })
	vim.keymap.set('x', 'a', function()
		insert_from_extend(true)
	end, { desc = 'Multicursor: insert at each selection end' })
end

restore_insert_maps = function()
	for _, k in ipairs { 'i', 'a' } do
		pcall(vim.keymap.del, 'x', k)
	end
	for k, d in pairs(saved_insert_maps or {}) do
		vim.keymap.set('x', k, d.callback or d.rhs, {
			noremap = d.noremap == 1,
			silent = d.silent == 1,
			expr = d.expr == 1,
			buffer = d.buffer == 1,
			script = d.script == 1,
			nowait = d.nowait == 1,
			desc = d.desc,
		})
	end
end

-- Plugins mapping 'i'/'a' at UIEnter (mini.ai) would override ours mid-
-- session; re-apply ours afterwards.
vim.api.nvim_create_autocmd('UIEnter', {
	once = true,
	group = vim.api.nvim_create_augroup('user-multicursor-maps', { clear = true }),
	callback = function()
		vim.schedule(function()
			if session_active() then
				set_insert_maps()
			end
		end)
	end,
})

-- <C-n>/g<C-n> from Normal mode: extend the running session, or start one on
-- the word under the cursor.
local function from_word(all)
	if session_active() then
		return extend(all)
	end
	local s = select_word()
	if not s then
		return
	end
	if all then
		return extend(true)
	end
	enter_visual(s)
end

-- <C-n>/g<C-n> from Visual mode: extend the session when the selection
-- matches it, otherwise (re)start on the selection.
local function from_selection(all)
	local text = selection()
	if not text then
		return
	end
	local align = { vim.fn.getpos 'v'[2], vim.fn.getpos 'v'[3] - 1 }
	local new_pattern = '\\V\\C' .. text
	exit_visual()
	if session_active() and (pattern() == new_pattern or vim.b.mc_text == text) then
		return extend(all)
	end
	clear()
	local s = start(new_pattern, align, text)
	if not s then
		return
	end
	if all then
		return extend(true)
	end
	enter_visual(s)
end

vim.keymap.set('n', '<C-n>', function()
	from_word(false)
end, { desc = 'Multicursor: add next occurrence' })

vim.keymap.set('x', '<C-n>', function()
	from_selection(false)
end, { desc = 'Multicursor: start session on the selection' })

vim.keymap.set('n', 'g<C-n>', function()
	from_word(true)
end, { desc = 'Multicursor: add all occurrences' })

vim.keymap.set('x', 'g<C-n>', function()
	from_selection(true)
end, { desc = 'Multicursor: add cursor at every occurrence of the selection' })

-- Toggle «cursor»/«extend» mode (vim-visual-multi). Outside a session the
-- built-in Tab applies.
-- Extending: 'gn' selects the match at/after the cursor (like the per-cursor
-- dry-run does), so no alignment is needed; an alignment could even jump
-- backwards to the previous match when the cursor sits just before one.
local function extend_at_cursor()
	if vim.api.nvim__mcursor_cascading() then
		return -- replayed at a cursor by a cascade: ignore
	end
	-- Extend mode: follow mode off (motions extend the per-cursor
	-- selections), then 'gn' selects the match at/after the cursor. Fed as
	-- typed keys (the per-cursor Visual atom): a synchronous ':normal'
	-- would fail here (expr mappings run under textlock), and the visual
	-- atom's keys must be typed for the per-cursor selection dry-run.
	vim.api.nvim_feedkeys(vim.keycode('2q=gn'), 'nt', false)
end

vim.keymap.set('n', '<Tab>', function()
	if not session_active() then
		return vim.keycode '<Tab>'
	end
	extend_at_cursor()
end, { expr = true, desc = 'Multicursor: switch to extend mode' })

vim.keymap.set('x', '<Tab>', function()
	if vim.api.nvim__mcursor_cascading() then
		return -- replayed at a cursor by an insert cascade: ignore
	end
	exit_visual() -- back to cursor mode, keeping cursors and session
	-- Follow mode on (motions move every cursor), but deferred: set
	-- synchronously it would cascade the still-pending Visual atom at every
	-- cursor at the clock edge.
	vim.api.nvim_feedkeys(vim.keycode('1q='), 'nt', false)
end, { desc = 'Multicursor: switch to cursor mode' })

vim.keymap.set('n', '<Esc>', function()
	-- A session also exists with zero extra cursors (the primary is its
	-- first cursor); native sessions (zq, Q) have no flag, only cursors.
	if session_active() or #cursors() > 0 then
		clear()
	else
		vim.api.nvim_feedkeys(vim.keycode '<Esc>', 'n', false)
	end
end, { desc = 'Multicursor: clear cursors' })
