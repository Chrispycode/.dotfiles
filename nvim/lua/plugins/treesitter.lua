return {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',
  opts = {
    ensure_installed = {
      'lua',
      'vim',
      'vimdoc',
      'query',
      'markdown',
      'markdown_inline',
      'embedded_template',
      'ruby',
      'html',
      'yaml',
      'css',
      'bash',
      'javascript',
      'json',
      'xml',
      'csv'
    },
    endwise = { enable = true },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
}
