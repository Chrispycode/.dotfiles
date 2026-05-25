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
vim.opt.spelloptions = camel
vim.opt.breakindent = true
vim.opt.formatoptions:remove({ 't' })
vim.opt.wrap = false
vim.opt.wrapmargin = 10
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 1
-- Paste mode handling
vim.opt.paste = false -- Don't use paste mode (it breaks mappings)
-- vim.opt.pastetoggle = '<F2>'  -- Optional: quick toggle if needed

-- Better handling for large pastes
vim.opt.maxfuncdepth = 1000
vim.opt.lazyredraw = true
vim.filetype.add { pattern = { ['.*%.api%.rsb'] = 'ruby' } }
vim.filetype.add { pattern = { ['.*%.yml%.j2'] = 'yaml' } }
require('vim._core.ui2').enable{}
require('autocmds')

-- Plugins are managed by vim.pack (Neovim 0.12+). Each file calls
-- vim.pack.add() and configures its plugins. Order matters: snacks before
-- theme (priority), mini before theme (provides base16).
require('plugins.snacks')
require('plugins.mini')
require('plugins.theme')
require('plugins.treesitter')
require('plugins.view')
require('plugins.extra')
require('plugins.lsp')
require('plugins.cmp')

require('pkg')
