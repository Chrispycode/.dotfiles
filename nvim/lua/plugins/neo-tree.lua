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
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require('bufferline').setup {
        options = {
          offsets = {
            {
              filetype = 'neo-tree',
              text = function()
                return vim.fn.getcwd()
              end,
              highlight = 'Directory',
              separator = true, -- use a "true" to enable the default, or set your own character
            },
          },
        },
      }
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = 'Buffer: ' .. desc })
      end
      map('<leader>1', ':BufferLineGoToBuffer 1<cr>','1')
      map('<leader>2', ':BufferLineGoToBuffer 2<cr>','2')
      map('<leader>3', ':BufferLineGoToBuffer 3<cr>','3')
      map('<leader>4', ':BufferLineGoToBuffer 4<cr>','4')
      map('<leader>5', ':BufferLineGoToBuffer 5<cr>','5')
      map('<leader>6', ':BufferLineGoToBuffer 6<cr>','6')
      map('<leader>7', ':BufferLineGoToBuffer 7<cr>','7')
      map('<leader>8', ':BufferLineGoToBuffer 8<cr>','8')
      map('<leader>9', ':BufferLineGoToBuffer 9<cr>','9')
      map('<leader>$', ':BufferLineGoToBuffer -1<cr>','-1')
      map('<leader>n', ':BufferLineCycleNext<cr>','next')
      map('<leader>p', ':BufferLineCyclePrev<cr>','previous')
    end,
  },
}
