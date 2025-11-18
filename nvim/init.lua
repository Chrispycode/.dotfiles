vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)
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
vim.opt.laststatus = 2
vim.opt.spell = true
vim.opt.spelllang = { 'en', 'de' }
vim.opt.spelloptions=camel
vim.opt.breakindent = true
vim.opt.formatoptions:remove({ 't' })
vim.opt.wrap = false
vim.opt.wrapmargin = 10
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 1
vim.opt.termguicolors = false
-- Paste mode handling
vim.opt.paste = false  -- Don't use paste mode (it breaks mappings)
-- vim.opt.pastetoggle = '<F2>'  -- Optional: quick toggle if needed

-- Better handling for large pastes
vim.opt.maxfuncdepth = 1000
vim.opt.lazyredraw = true
vim.filetype.add { pattern = { ['.*%.api%.rsb'] = 'ruby' } }
vim.filetype.add { pattern = { ['.*%.yml%.j2'] = 'yaml' } }
vim.api.nvim_set_hl(0, 'Normal', { bg = 0 })
vim.api.nvim_set_hl(0, 'NonText', { bg = 0 })
require('api')

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
	{ import = 'plugins' },
}
