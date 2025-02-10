return {
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_and_accept', 'fallback' },
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
    signature = { enable = true },
  },
}
