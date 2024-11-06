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
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.relativenumber = true
vim.opt.laststatus = 3
vim.opt.wrap = false
vim.opt.spell = true
vim.opt.spelllang = { 'en', 'de' }
vim.cmd 'set runtimepath+="plugins"'
vim.cmd 'set runtimepath+="modules"'
vim.g.loaded_netrin = 1
--- enable if spellfiles are missing
vim.g.loaded_netrw = 0
vim.g.NERDTreeMinimalUI = 1
vim.api.nvim_set_hl(0, 'Normal', { bg = 0 })
vim.api.nvim_set_hl(0, 'NonText', { bg = 0 })
vim.filetype.add { pattern = { ['.*%.api%.rsb'] = 'ruby' } }
vim.filetype.add { pattern = { ['.*%.yml%.j2'] = 'yaml' } }

require 'lazy_init'
require('lazy').setup {
  {
    'water-sucks/darkrose.nvim',
    opts = {
      colors = { bg = 'none' },
      overrides = function(c)
        return { QuickFixLine = { fg = c.fg_dark } }
      end,
    },
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'darkrose'
    end,
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'echasnovski/mini.icons' },
    config = function()
      require('alpha').setup(require('styles.alpha_startup').config)
    end,
  },
  { 'nvim-lualine/lualine.nvim', opts = { options = { theme = require 'styles.darkrose_line' }, sections = { lualine_c = { { 'filename', path = 1 } } } } },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = { indent = { char = '▏' } } },
  'tpope/vim-sleuth',
  'slim-template/vim-slim',
  'alvan/vim-closetag',
  'mg979/vim-visual-multi',
  'nvim-pack/nvim-spectre',
  { import = 'plugins' },
}
