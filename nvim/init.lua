local vim = vim
--- Enable Ruler
vim.opt.ru = true
-- Show the line number
vim.opt.number = true
-- Enable Syntax Highlighting
vim.opt_syntax = true
-- Enable using the mouse to click or select some peace of code
vim.opt.mouse = 'a'
-- Set the Tab to 2 spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- set number
vim.opt.relativenumber = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.laststatus = 3
vim.opt.wrap = false
vim.g.mapleader = ' '
vim.g.rails_syntax_enabled = 1
vim.g.loaded_netrin = 1
vim.g.loaded_netrw = 0
vim.g.NERDTreeMinimalUI=1
vim.cmd 'set runtimepath+="plugins"'
vim.cmd 'set runtimepath+="modules"'
vim.api.nvim_set_hl(0, 'Normal', { bg = 0 })
vim.api.nvim_set_hl(0, 'NonText', { bg = 0 })
vim.filetype.add({ pattern = { ['.*%.api%.rsb'] = 'ruby', } })
vim.filetype.add({ pattern = { ['.*%.yml%.j2'] = 'yaml', } })

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
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        html = { 'htmlbeautifier', stop_after_first = true },
        eruby = { 'htmlbeautifier' },
        ruby = { 'rufo' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },
  { 'nvim-lualine/lualine.nvim', opts = { options = { theme = require 'styles.darkrose_line' }, sections = { lualine_c = { { 'filename', path = 1 } } } } },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = { indent = { char = '▏' } } },
  'tpope/vim-sleuth',
  'tpope/vim-rails',
  'slim-template/vim-slim',
  'brenoprata10/nvim-highlight-colors',
  'kdheepak/lazygit.nvim',
  'alvan/vim-closetag',
  'j-hui/fidget.nvim',
  'folke/trouble.nvim',
  'robitx/gp.nvim',
  'folke/which-key.nvim',
  'mg979/vim-visual-multi',
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-ui',
  'kristijanhusak/vim-dadbod-completion',
  { import = 'plugins' },
}

vim.keymap.set('n', '<leader>n', vim.cmd.tabnext, { desc = 'next Tab' })
vim.keymap.set('n', '<leader>tn', vim.cmd.tabnew, { desc = 'new Tab' })
vim.keymap.set('n', '<leader>p', vim.cmd.tabprevious, { desc = 'previous Tab' })
vim.keymap.set('n', '<leader>lg', vim.cmd.LazyGitCurrentFile, { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>lp', ':Lazy<cr>', { desc = 'Lazy' })
vim.keymap.set('n', '<leader>ls', ':LspStart<cr>', { desc = 'LSP Start' })
vim.keymap.set('n', '<leader>lk', ':LspStop<cr>', { desc = 'LSP stop' })
vim.keymap.set('n', '<leader>lm', ':Mason<cr>', { desc = 'Mason' })
vim.keymap.set('n', '<leader>aa', ':Alpha<cr>', { desc = 'Alpha' })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'cancel search' })
