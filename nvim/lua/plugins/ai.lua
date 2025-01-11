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
      'nvim-treesitter/nvim-treesitter',
      { "nvim-lua/plenary.nvim",  branch = "master" },
      { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    opts = {
      strategies = {
        chat = {
          adapter = os.getenv 'LLM',
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
              model = {
                default = 'llama3.1:latest',
              },
              temperature = { default = 0.6 },
            },
          })
        end,
        copilot = function()
          return require('codecompanion.adapters').extend('copilot', {
            schema = {
              temperature = { default = 0.6 },
            },
          })
        end,
      },
    }
  },
}
