vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.slim*" }, command = "set ft=slim" })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" },
	{ pattern = { "*_patch.rb", "*_hook.rb" }, command = "setlocal foldlevel=4" })

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
vim.api.nvim_create_autocmd('TermOpen', {
	group = vim.api.nvim_create_augroup('terminal_config', { clear = true }),
	callback = function()
		vim.opt_local.spell = false
	end,
})
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
		-- Start in insert mode
		vim.cmd('startinsert')
	end,
})
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
