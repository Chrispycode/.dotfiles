return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.api.nvim_set_keymap('n', '<leader>db', ':DBUI<CR>', { noremap = true, silent = true, desc = "DBUI" })
    end,
  },
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = function()
      require('toggleterm').setup {
        direction = 'float',
        float_opts = {
          border = 'double',
        },
      }
      local Terminal = require('toggleterm.terminal').Terminal
      local lazydocker = Terminal:new { cmd = 'lazydocker', hidden = true }

      function _lazydocker_toggle()
        lazydocker:toggle()
      end
      vim.api.nvim_set_keymap('n', '<leader>lt', ':ToggleTerm<CR>', { noremap = true, silent = true, desc = "popup terminal" })
      vim.api.nvim_set_keymap('n', '<leader>ld', '<cmd>lua _lazydocker_toggle()<CR>', { noremap = true, silent = true, desc = "lazydocker" })
    end,
  },
}
