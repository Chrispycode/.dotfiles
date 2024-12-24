return {
  {
    'github/copilot.vim',
    config = function()
      vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true
    end
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = function()
      require('codecompanion').setup {
        strategies = {
          chat = {
            adapter = os.getenv 'LLM',
            keymaps = {
              debug = {
                modes = {
                  n = 'cd',
                },
                index = 14,
                callback = 'keymaps.debug',
                description = 'View debug info',
              },
            },
          },
          inline = {
            adapter = os.getenv 'LLM',
          },
        },
        adapters = {
          ollama = function()
            return require('codecompanion.adapters').extend('ollama', {
              schema = {
                num_ctx = {
                  default = 16384,
                },
                temperature = { default = 0.6 },
              },
            })
          end,
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
              schema = {
                -- model = {
                --   default = 'gpt-4o-2024-05-13',
                -- },
                temperature = { default = 0.6 },
              },
            })
          end,
        },
      }
    end,
  },
}
