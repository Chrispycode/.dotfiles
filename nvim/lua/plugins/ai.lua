return {
  { 'github/copilot.vim' },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
      'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
      { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = function()
      require('codecompanion').setup {
        adapters = {
          ollama = function()
            return require('codecompanion.adapters').extend('ollama', {
              parameters = {
                sync = true,
              },
              schema = {
                num_ctx = {
                  default = 8384,
                },
              },
            })
          end,
        },
      }
    end,
  },
}
