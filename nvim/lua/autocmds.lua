-- Autocommands, filetype tweaks, terminal config, and small startup shims.

-- Filetypes ------------------------------------------------------------------
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
	pattern = { '*.slim*' },
	command = 'set ft=slim',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
	pattern = { '*_patch.rb', '*_hook.rb' },
	command = 'setlocal foldlevel=4',
})

-- Highlight on yank ----------------------------------------------------------
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function() vim.hl.on_yank() end,
})

-- Terminal -------------------------------------------------------------------
vim.api.nvim_create_autocmd('TermOpen', {
	desc = 'Configure terminal buffers like tmux panes',
	group = vim.api.nvim_create_augroup('terminal-tmux-like', { clear = true }),
	callback = function()
		vim.opt_local.spell = false
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = 'no'
		vim.opt_local.cursorline = false
		vim.opt_local.cursorcolumn = false
		vim.cmd('startinsert')
	end,
})
vim.keymap.set('t', '<C-e>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Startup-time shim for snacks dashboard ------------------------------------
-- Snacks's built-in `startup` section calls `require("lazy.stats").stats()`.
-- We don't use lazy.nvim, so we shim that module to expose vim.pack data and
-- a frozen startup time captured at VimEnter.
local startup_hr = vim.uv.hrtime()
local startup_ms = 0
vim.api.nvim_create_autocmd('VimEnter', {
	once = true,
	callback = function()
		startup_ms = (vim.uv.hrtime() - startup_hr) / 1e6
	end,
})
package.preload['lazy.stats'] = function()
	return {
		stats = function()
			local plugins = vim.pack.get()
			return { startuptime = startup_ms, loaded = #plugins, count = #plugins }
		end,
	}
end
