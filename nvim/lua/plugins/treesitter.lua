return {
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = { 'OXY2DEV/markview.nvim' },
		run = ':TSUpdate',
		main = 'nvim-treesitter.configs',
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
				'slim',
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
		}
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		opts = {
			multiwindow = true,
		}
	}
}
