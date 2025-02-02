return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '<leader>k', ':Neotree toggle<CR>', desc = 'NeoTree reveal' },
      { '<leader>o', ':Neotree reveal<CR>', desc = 'NeoTree reveal' },
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        window = {
          mappings = {
            ['\\'] = 'close_window',
            ['c'] = {
              'copy',
              config = {
                show_path = 'relative',
              },
            },
            ['a'] = {
              'add',
              config = {
                show_path = 'relative',
              },
            },
            ['m'] = {
              'move',
              config = {
                show_path = 'relative',
              },
            },
            ['r'] = {
              'rename',
              config = {
                show_path = 'relative',
              },
            },
          },
        },
      },
    },
  },
  -- {
  --   'echasnovski/mini.files',
  --   version = '*',
  --   opts = {
  --     mappings = {}
  --   }
  -- },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },
}
