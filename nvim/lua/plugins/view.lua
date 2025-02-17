return {
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    ft = { "markdown", "codecompanion" },
    opts = {
      preview = {
        filetypes = { "markdown", "quarto", "rmd", "codecompanion" },
        ignore_buftypes = {},
      }
    }
  },
  {
    "folke/snacks.nvim",
    dependencies = {
      'folke/which-key.nvim',
      opts = {
        layout = {
          spacing = 2
        }
      }
    },
    priority = 1000,
    lazy = false,
    opts = {
      image = { enabled = true },
      bigfile = { enabled = true },
      notifier = { enabled = true },
      zen = { enabled = true },
    },
    keys = {
      { '<leader>tn', '<cmd>tabnew<cr>',                                                      desc = 'new Tab' },
      { '<leader>lg', ':LazyGitCurrentFile<cr>',                                              desc = 'LazyGit' },
      { '<leader>lp', ':Lazy<cr>',                                                            desc = 'Lazy' },
      { '<leader>ls', ':LspStart<cr>',                                                        desc = 'LSP Start' },
      { '<leader>lk', ':LspStop<cr>',                                                         desc = 'LSP stop' },
      { '<leader>lm', ':Mason<cr>',                                                           desc = 'Mason' },
      { '<leader>lc', ':CodeCompanionActions<cr>',                                            desc = 'CodeCompanion' },
      { '<leader>lz', '<cmd>lua Snacks.zen()<cr>',                                            desc = 'ZenMode' },
      { '<leader>lo', ':Oil<cr>',                                                             desc = 'Oil' },
      { '<leader>aa', ':Alpha<cr>',                                                           desc = 'Alpha' },
      { '<Esc>',      '<cmd>nohlsearch<CR>',                                                  desc = 'cancel search' },
      { '<leader>q',  '<cmd>lua vim.diagnostic.setloclist()<CR>',                             desc = 'Open diagnostic [Q]uickfix list' },
      { '<C-h>',      '<C-w><C-h>',                                                           desc = 'Move focus to the left window' },
      { '<C-l>',      '<C-w><C-l>',                                                           desc = 'Move focus to the right window' },
      { '<C-j>',      '<C-w><C-j>',                                                           desc = 'Move focus to the lower window' },
      { '<C-k>',      '<C-w><C-k>',                                                           desc = 'Move focus to the upper window' },
      { '<leader>S',  '<cmd>lua require("spectre").toggle()<CR>',                             desc = 'Toggle Spectre' },
      { '<leader>sr', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',      desc = 'Search current word' },
      { '<leader>sr', '<esc><cmd>lua require("spectre").open_visual()<CR>',                   desc = 'Search current word',            mode = "v" },
      { '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', desc = 'Search on current file' },
    },
  },
  {
    'brenoprata10/nvim-highlight-colors',
    config = function()
      local hlc = require('nvim-highlight-colors')
      vim.keymap.set('n', '<leader>lh', hlc.toggle, { desc = 'Toggle HighlightColors' })
    end
  },
}
