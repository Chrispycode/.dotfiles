return {
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_and_accept' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
      },
      sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer', 'codecompanion' },
        providers = {
          lsp = {
            score_offset = 0, -- Boost/penalize the score of the items
          },
          path = {},
          snippets = {},
          buffer = {},
          codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
            enabled = true,
          }
        },
      },
      completion = {
        documentation = {
          auto_show = true,
        }
      }
    },
    opts_extend = { 'sources.default' },
    -- signature = { enable = true },
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  }
}
