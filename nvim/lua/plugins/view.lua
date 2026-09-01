-- markview.nvim is loaded only on markdown filetype

vim.pack.add({
	{ src = 'https://github.com/OXY2DEV/markview.nvim' },
}, { load = false })

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'markdown', 'quarto', 'rmd' },
	once = true,
	group = vim.api.nvim_create_augroup('user-markview-load', {
		clear =
				true
	}),
	callback = function()
		vim.cmd('packadd markview.nvim')
		require('markview').setup({
			preview = {
				filetypes = { 'markdown', 'quarto', 'rmd' },
				ignore_buftypes = {},
				hybrid_modes = { 'n' },
			},
		})
	end,
})

-- Sublime Text / VS Code style multiple cursors (Ctrl-D-like) on top of
-- Neovim's built-in multicursor feature (:help mcursor, needs 0.13+ nightly).
--
-- Mappings:
--   <C-n>   select word under cursor, press again to add the next occurrence
--           (in Visual mode: use the selection as the search pattern)
--   g<C-n>  select ALL occurrences at once (like Ctrl-Shift-L in VS Code)
--   <C-l>   clear all cursors and end the session
--   <Esc>   also ends an active session (normal mode)
--
-- While a session is active, follow-mode (q=) is enabled, so motions and
-- Visual-mode sequences replay at every cursor. Useful built-ins:
--   ciw / daw / yiw ...   operators replay at every cursor
--   gn then c             select each occurrence, then change all
--   Q / <C-LeftMouse>     toggle a cursor manually / by clicking
--   ]C / [C               jump between cursors
--   g CTRL-A              insert ascending numbers at the cursors
--   gQ                    restore previously cleared cursors
-- Undo is atomic: one `u` reverts the edits of all cursors at once.

local ns = vim.api.nvim_create_namespace 'nvim.multicursor'

-- The default hl-MCursor -> Cursor link is invisible on Search-highlighted
-- matches with low-contrast palettes. Reverse swaps each cell's own colors,
-- so cursors render as solid blocks with any colorscheme. mini.lua re-applies
-- this on every palette reload; this is the fallback for plain :colorscheme.
local function set_mcursor_hl()
  vim.api.nvim_set_hl(0, 'MCursor', { reverse = true, bold = true })
end
set_mcursor_hl()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('user-multicursor-hl', { clear = true }),
  callback = set_mcursor_hl,
})

local state = {
  buf = nil, -- buffer the session is active in
  pattern = nil, -- search pattern used for the occurrences
  text = nil, -- plain text of the occurrence (to recognize the Visual selection)
  covered = {}, -- match starts { lnum, byteidx } that already have a cursor
  last = nil, -- match start of the most recently added occurrence
  pending = false, -- primary's occurrence is selected; next <C-n> adds instead of re-selecting
}

local function reset()
  state.buf = nil
  state.pattern = nil
  state.text = nil
  state.covered = {}
  state.last = nil
  state.pending = false
end

local function extra_cursors()
  return vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
end

local function session_active()
  return state.buf == vim.api.nvim_get_current_buf() and state.pattern ~= nil
end

local function feed(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
end

local function follow_mode(on)
  feed(on and '1q=' or '2q=')
end

local function exit_visual()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
end

-- Returns the selected text (single-line only) and its start { lnum, byteidx }.
local function visual_selection()
  local s = vim.fn.getpos 'v'
  local e = vim.fn.getpos '.'
  local lines = vim.fn.getregion(s, e, { type = vim.fn.mode() })
  if #lines ~= 1 then
    return nil
  end
  local sl, sc, el, ec = s[2], s[3], e[2], e[3]
  if sl > el or (sl == el and sc > ec) then
    sl, sc = el, ec
  end
  return lines[1], { sl, sc - 1 }
end

local function covered_has(lnum, byteidx)
  for _, p in ipairs(state.covered) do
    if p[1] == lnum and p[2] == byteidx then
      return true
    end
  end
  return false
end

local function start_session(pattern, text, pos, select_match)
  reset()
  state.buf = vim.api.nvim_get_current_buf()
  state.pattern = pattern
  state.text = text
  state.covered = { { pos[1], pos[2] } }
  state.last = { pos[1], pos[2] }
  vim.fn.setreg('/', pattern)
  vim.o.hlsearch = true
  follow_mode(true)
  if select_match then
    -- Select the occurrence for feedback. Note `gn` (and any word selection)
    -- leaves the primary cursor at the word END, while cursors added via
    -- nvim_mcursor() sit at the word START. Pressing <C-n> again adds the
    -- next occurrence and collapses the selection, after which all cursors
    -- are normal-mode cursors at match starts.
    feed 'gn'
    state.pending = true
  end
end

-- Place a cursor on the next occurrence without moving the primary cursor
-- (moving the primary with `n` would replay at every cursor in follow-mode).
local function add_next()
  local save = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_win_set_cursor(0, { state.last[1], state.last[2] })
  local pos = vim.fn.searchpos(state.pattern, 'nw') -- wraps around
  vim.api.nvim_win_set_cursor(0, save)
  local lnum, byteidx = pos[1], pos[2] - 1
  if lnum == 0 or covered_has(lnum, byteidx) then
    vim.notify('multicursor: no more occurrences', vim.log.levels.WARN)
    return
  end
  vim.api.nvim_mcursor(0, { lnum, byteidx })
  table.insert(state.covered, { lnum, byteidx })
  state.last = { lnum, byteidx }
  vim.api.nvim_echo({ { ('multicursor: %d cursors'):format(#state.covered) } }, false, {})
end

local function word_under_cursor()
  local word = vim.fn.expand '<cword>'
  if word == '' then
    return nil
  end
  local pattern = '\\V\\C\\<' .. vim.fn.escape(word, '\\') .. '\\>'
  local pos = vim.fn.searchpos(pattern, 'bcn') -- start of the match under the cursor
  if pos[1] == 0 then
    return nil
  end
  return word, pattern, { pos[1], pos[2] - 1 }
end

local function ctrl_n()
  if vim.fn.mode():match '^[vV\22]' then
    local text, pos = visual_selection()
    if not text then
      vim.notify('multicursor: multi-line selections are not supported', vim.log.levels.WARN)
      return
    end
    if session_active() and text == state.text then
      if state.pending then
        -- This selection is the primary's own occurrence, not a request to
        -- add it again: collapse to the match start, then add the next one.
        state.pending = false
        exit_visual()
        vim.api.nvim_win_set_cursor(0, state.last)
      else
        exit_visual()
      end
      add_next()
    else
      -- Different selection than the active session's text: start over.
      if session_active() then
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
        follow_mode(false)
      end
      exit_visual()
      start_session('\\V\\C' .. vim.fn.escape(text, '\\'), text, pos, true)
    end
  else
    if session_active() then
      -- The primary's occurrence is left selected (see start_session), so an
      -- add arrives in Visual mode; the branch above handles that. This path
      -- only runs after the user explicitly left Visual mode.
      add_next()
    else
      local word, pattern, pos = word_under_cursor()
      if not word then
        vim.notify('multicursor: no word under cursor', vim.log.levels.WARN)
        return
      end
      vim.api.nvim_win_set_cursor(0, pos)
      start_session(pattern, word, pos, true)
    end
  end
end

local function ctrl_n_all()
  local pattern, text, pos
  if vim.fn.mode():match '^[vV\22]' then
    local sel
    text, pos = visual_selection()
    if not text then
      vim.notify('multicursor: multi-line selections are not supported', vim.log.levels.WARN)
      return
    end
    sel = text
    exit_visual()
    pattern = '\\V\\C' .. vim.fn.escape(sel, '\\')
  else
    local word
    word, pattern, pos = word_under_cursor()
    if not word then
      vim.notify('multicursor: no word under cursor', vim.log.levels.WARN)
      return
    end
    text = word
    vim.api.nvim_win_set_cursor(0, pos)
  end
  start_session(pattern, text, pos, false)
  for _, m in ipairs(vim.fn.matchbufline('%', pattern, 1, '$')) do
    if not covered_has(m.lnum, m.byteidx) then
      vim.api.nvim_mcursor(0, { m.lnum, m.byteidx })
      table.insert(state.covered, { m.lnum, m.byteidx })
    end
  end
  state.last = state.covered[#state.covered]
  vim.api.nvim_echo({ { ('multicursor: %d cursors'):format(#state.covered) } }, false, {})
end

local function clear()
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  if session_active() then
    follow_mode(false)
  end
  reset()
  vim.cmd 'nohlsearch'
  vim.cmd 'redraw'
end

vim.keymap.set({ 'n', 'x' }, '<C-n>', ctrl_n, { desc = 'Multicursor: select word / add next occurrence' })
vim.keymap.set({ 'n', 'x' }, 'g<C-n>', ctrl_n_all, { desc = 'Multicursor: select all occurrences' })
vim.keymap.set('n', '<C-l>', clear, { desc = 'Clear multicursors' })
vim.keymap.set('n', '<Esc>', function()
  if session_active() or #extra_cursors() > 0 then
    clear()
  else
    feed '<Esc>'
  end
end, { desc = 'Clear multicursors' })
