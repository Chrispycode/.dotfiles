-- mini.nvim — eager-load only what's needed before first render/keypress;
-- defer everything else to UIEnter.
vim.pack.add({
	{ src = 'https://github.com/echasnovski/mini.nvim' },
})

-- ============================================================================
-- EAGER: required before first render, statusline, or keypress
-- ============================================================================

vim.o.termguicolors = false

-- Same base-slot -> ANSI-color mapping the generator template encodes,
-- expressed as cterm indices (0-15) instead of hex.
local cterm = {
	base00 = 0, base01 = 0, base02 = 8, base03 = 8,
	base04 = 7, base05 = 7, base06 = 15, base07 = 15,
	base08 = 1, base09 = 11, base0A = 3, base0B = 2,
	base0C = 6, base0D = 4, base0E = 5, base0F = 13,
}

-- A gui palette is mandatory but unused while 'termguicolors' is off; use a
-- standard base16 scheme so nothing breaks if truecolor is toggled on.
local gui = {
	base00 = "#181818", base01 = "#282828", base02 = "#383838", base03 = "#585858",
	base04 = "#b8b8b8", base05 = "#d8d8d8", base06 = "#e8e8e8", base07 = "#f8f8f8",
	base08 = "#ab4642", base09 = "#dc9656", base0A = "#f7ca88", base0B = "#a1b56c",
	base0C = "#86c1b9", base0D = "#7cafc2", base0E = "#ba8baf", base0F = "#a16946",
}

-- mini.base16 styles everything (incl. StatusLine and all MiniStatusline*
-- groups) straight from the palette, so no manual highlight wiring is needed.
require('mini.base16').setup({ palette = gui, use_cterm = cterm })

-- Keep the editor area transparent so the terminal background shows through,
-- while leaving mini.base16's statusline colors intact.
for _, group in ipairs({
	"Normal", "NormalNC", "NormalFloat", "SignColumn", "LineNr", "LineNrAbove",
	"LineNrBelow", "CursorLineNr", "FoldColumn", "NonText", "Whitespace",
}) do
	local hl = vim.api.nvim_get_hl(0, { name = group })
	hl.bg = nil
	hl.ctermbg = nil
	vim.api.nvim_set_hl(0, group, hl)
end

-- Keep selected text readable with the 16-color terminal palette. Snacks picker
-- maps its focused item to CursorLine/Visual, which can otherwise become a
-- light bar with light text depending on the terminal ANSI colors.
vim.api.nvim_set_hl(0, 'Visual', { fg = gui.base07, bg = gui.base0D, ctermfg = cterm.base07, ctermbg = cterm.base0D })
vim.api.nvim_set_hl(0, 'PmenuSel', { fg = gui.base07, bg = gui.base0D, ctermfg = cterm.base07, ctermbg = cterm.base0D })
vim.api.nvim_set_hl(0, 'SnacksPickerListCursorLine', { fg = gui.base07, bg = gui.base0D, ctermfg = cterm.base07, ctermbg = cterm.base0D })

-- Icons (consumed by completion, snacks, statusline)
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
MiniIcons.tweak_lsp_kind()

-- Key-hint popup (must capture first keypress)
local miniclue = require('mini.clue')
miniclue.setup({
	triggers = {
		{ mode = 'n', keys = '<Leader>' }, { mode = 'x', keys = '<Leader>' },
		{ mode = 'n', keys = 'g' },        { mode = 'x', keys = 'g' },
		{ mode = 'n', keys = "'" },        { mode = 'n', keys = '`' },
		{ mode = 'x', keys = "'" },        { mode = 'x', keys = '`' },
		{ mode = 'n', keys = '"' },        { mode = 'x', keys = '"' },
		{ mode = 'i', keys = '<C-r>' },    { mode = 'c', keys = '<C-r>' },
		{ mode = 'n', keys = '<C-w>' },
		{ mode = 'n', keys = 'z' },        { mode = 'x', keys = 'z' },
		{ mode = 'n', keys = '[' },        { mode = 'n', keys = ']' },
	},
	clues = {
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
		{ mode = 'n', keys = '<Leader>l', desc = '+LSP' },
		{ mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
		{ mode = 'n', keys = '<Leader>f', desc = 'Format buffer' },
		{ mode = 'n', keys = '<Leader>o', desc = 'MiniFiles' },
	},
	window = { delay = 300, config = { border = 'rounded' } },
})

-- Snacks dashboard is unlisted; mini.clue skips unlisted buffers.
vim.api.nvim_create_autocmd('User', {
	pattern = { 'SnacksDashboardOpened', 'SnacksDashboardUpdatePost' },
	group = vim.api.nvim_create_augroup('user-miniclue-dashboard', { clear = true }),
	callback = function()
		require('mini.clue').ensure_buf_triggers(vim.api.nvim_get_current_buf())
	end,
})

-- Statusline (renders immediately)
local statusline = require('mini.statusline')
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end

local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1
local processing = false

local function section_codecompanion()
	if not processing then return '' end
	spinner_index = (spinner_index % #spinner_symbols) + 1
	return '  ' .. spinner_symbols[spinner_index]
end

vim.api.nvim_create_autocmd('User', {
	pattern = 'CodeCompanionRequest*',
	group = vim.api.nvim_create_augroup('CodeCompanionHooks', {}),
	callback = function(request)
		if request.match == 'CodeCompanionRequestStarted' then processing = true
		elseif request.match == 'CodeCompanionRequestFinished' then processing = false; io.write('\x07') end
		vim.cmd('redrawstatus')
	end,
})

local function unsaved_buffer()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_get_option_value('modified', { buf = buf }) then return '🚨' end
	end
	return ''
end

statusline.setup({
	content = {
		active = function()
			local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
			local git         = statusline.section_git({ trunc_width = 40 })
			local diff        = statusline.section_diff({ trunc_width = 75 })
			local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
			local filename    = statusline.section_filename({ trunc_width = 140 })
			local lsp         = statusline.section_lsp({ trunc_width = 75 })
			local fileinfo    = statusline.section_fileinfo({ trunc_width = 120 })
			local location    = statusline.section_location({ trunc_width = 75 })
			local search      = statusline.section_searchcount({ trunc_width = 75 })
			return statusline.combine_groups({
				{ hl = mode_hl,                  strings = { mode } },
				{ hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics } },
				'%<',
				{ hl = 'MiniStatuslineFilename', strings = { filename, unsaved_buffer() } },
				'%=',
				{ hl = 'MiniStatuslineFilename', strings = { section_codecompanion(), lsp } },
				{ hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
				{ hl = mode_hl,                  strings = { search, location } },
			})
		end,
		inactive = function()
			return statusline.combine_groups({
				{ hl = 'MiniStatuslineInactive', strings = { '%f%m' } },
			})
		end,
	},
	use_icons = vim.g.have_nerd_font,
})

-- Keymap stubs that lazily require the module on first use
vim.keymap.set('n', '<leader>o', function()
	require('mini.files').open(vim.api.nvim_buf_get_name(0))
end, { desc = 'MiniFiles' })

vim.keymap.set('n', '<leader>lh', function()
	require('mini.hipatterns').toggle()
end, { desc = 'Toggle HighlightColors' })

-- ============================================================================
-- DEFERRED: setup after UI is up
-- ============================================================================

vim.api.nvim_create_autocmd('UIEnter', {
	once = true,
	group = vim.api.nvim_create_augroup('user-mini-deferred', { clear = true }),
	callback = function()
		vim.schedule(function()
			require('mini.diff').setup()
			require('mini.sessions').setup({
				autoread = false,
				autowrite = true,
			})
			require('mini.pairs').setup()
			require('mini.cursorword').setup()
			require('mini.git').setup()
			require('mini.ai').setup({ n_lines = 500 })
			require('mini.surround').setup()

			local hipatterns = require('mini.hipatterns')
			hipatterns.setup({
				highlighters = { hex_color = hipatterns.gen_highlighter.hex_color() },
			})

			require('mini.completion').setup({
				delay = { completion = 100, info = 100, signature = 50 },
				window = {
					info = { height = 25, width = 80, border = 'rounded' },
					signature = { height = 25, width = 80, border = 'rounded' },
				},
				lsp_completion = { source_func = 'completefunc', auto_setup = true },
				fallback_action = '<C-x><C-n>',
			})

			require('mini.notify').setup({
				window = {
					config = function()
						local has_statusline = vim.o.laststatus > 0
						local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
						return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
					end,
				},
			})
		end)
	end,
})
