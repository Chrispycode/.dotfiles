vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 10
vim.opt.ru = true
vim.opt_syntax = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.relativenumber = true
vim.opt.laststatus = 3
vim.opt.wrap = false
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.spell = true
vim.opt.spelllang = { 'en', 'de' }
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 1
vim.api.nvim_set_hl(0, 'Normal', { bg = 0 })
vim.api.nvim_set_hl(0, 'NonText', { bg = 0 })
vim.filetype.add { pattern = { ['.*%.api%.rsb'] = 'ruby' } }
vim.filetype.add { pattern = { ['.*%.yml%.j2'] = 'yaml' } }
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, { pattern = { "*.slim*" }, command = "set ft=slim" })

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end ---@diagnostic disable-next-line: undefined-field

vim.opt.rtp:prepend(lazypath)
require('lazy').setup {
	{
		'water-sucks/darkrose.nvim',
		opts = {
			colors = { bg = 'none' },
			overrides = function(c)
				return { QuickFixLine = { fg = c.fg_dark }, CursorColumn = { bg = '#20111a' }, NormalFloat = { bg = c.bg } }
			end,
		},
		priority = 1000,
		init = function()
			vim.cmd.colorscheme 'darkrose'
		end,
	},
	'mg979/vim-visual-multi',
	-- search and replace multifile use gc isntead of g for autoconfirm
	-- :cfdo %s/stringOne/stringTwo/g | update | bd`
	{ import = 'plugins' },
}
