local has_redrawn = false
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

  'folke/which-key.nvim',
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      image = { enabled = true },
      bigfile = { enabled = true },
      notifier = { enabled = true },
      zen = { enabled = true },
      explorer = { enabled = true },
      picker = { include = { "plugins/*", "modules/*", "plugins*", "modules*" } },
      dashboard = {
        preset = {
          keys = {
            { icon = "", key = "n", desc = "New file", action = "<cmd>ene<CR>" },
            { icon = "󰈞", key = "f", desc = "Find file", action = "<cmd>FzfLua files<CR>" },
            { icon = "󰊄", key = "g", desc = "Live grep", action = "<cmd>FzfLua live_grep<CR>" },
            { icon = "", key = "lg", desc = "Git", action = "<cmd>LazyGit<CR>" },
            { icon = "󰏔", key = "lm", desc = "Mason", action = "<cmd>Mason<CR>" },
            { icon = "", key = "lc", desc = "Code", action = "<cmd>CodeCompanionActions<CR>" },
            { icon = "", key = "lp", desc = "PLugins", action = "<cmd>Lazy<CR>" },
            { icon = "󰅚", key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
          },
          header = [[
  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒
 ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░
▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██
 ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
 ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
 ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░
    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░
          ░    ░  ░    ░ ░        ░   ░         ░
                                 ░                  ]],

        },
        sections = {
          { section = "header",  padding = 1 },
          { section = "startup", padding = 1 },
          function()
            local version = vim.version()
            return {
              align = 'center',
              text = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch,
              padding = 1,
            }
          end,
          { section = "keys", padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", cwd = true, indent = 2, padding = 1 },
          function()
            if not has_redrawn then
              Snacks.explorer.open()
              has_redrawn = true
            end
            return {
              icon = " ",
              title = "Git Status",
              section = "terminal",
              enabled = function()
                return Snacks.git.get_root() ~= nil
              end,
              cmd = "git status --short --branch --renames",
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }
          end,
        },
      }
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
      { '<leader>lf', '<cmd>lua Snacks.picker.files()<cr>',                                   desc = 'Files' },
      { '<leader>lw', ':set wrap<cr>',                                                        desc = 'Toggle Wrap' },
      { '<leader>lo', ':Oil<cr>',                                                             desc = 'Oil' },
      { '<leader>lb', '<cmd>lua Snacks.dashboard.open()<cr>',                                 desc = 'Dash[b]oard' },
      { '<leader>k',  '<cmd>lua Snacks.explorer.open()<cr>',                                  desc = 'Filestree' },
      { '<leader>o',  '<cmd>lua Snacks.explorer.reveal()<cr>',                                desc = 'Filestree' },
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
