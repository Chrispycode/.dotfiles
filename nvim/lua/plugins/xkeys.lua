return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  { vim.keymap.set('n', '<leader>tn', vim.cmd.tabnew, { desc = 'new Tab' }) },
  { vim.keymap.set('n', '<leader>lg', vim.cmd.LazyGitCurrentFile, { desc = 'LazyGit' }) },
  { vim.keymap.set('n', '<leader>lp', ':Lazy<cr>', { desc = 'Lazy' }) },
  { vim.keymap.set('n', '<leader>ls', ':LspStart<cr>', { desc = 'LSP Start' }) },
  { vim.keymap.set('n', '<leader>lk', ':LspStop<cr>', { desc = 'LSP stop' }) },
  { vim.keymap.set('n', '<leader>lm', ':Mason<cr>', { desc = 'Mason' }) },
  { vim.keymap.set('n', '<leader>lc', ':CodeCompanionActions<cr>', { desc = 'CodeCompanion' }) },
  {
    'brenoprata10/nvim-highlight-colors',
    config = function()
      local hlc = require('nvim-highlight-colors')
      vim.keymap.set('n', '<leader>lh', hlc.toggle, { desc = 'Toggle HighlightColors' })
    end
  },
  { vim.keymap.set('n', '<leader>aa', ':Alpha<cr>', { desc = 'Alpha' }) },
  { vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'cancel search' }) },
  { vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' }) },
  { vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' }) },
  { vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' }) },
  { vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' }) },
  { vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' }) },
  { vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = 'Toggle Spectre' }) },
  { vim.keymap.set('n', '<leader>sr', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = 'Search current word' }) },
  { vim.keymap.set('v', '<leader>sr', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = 'Search current word' }) },
  { vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = 'Search on current file' }) },
}
