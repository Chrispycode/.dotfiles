return {
	{
		'OXY2DEV/markview.nvim',
		lazy = false,
		priority = 49,
		ft = { "markdown" },
		opts = {
			preview = {
				filetypes = { "markdown", "quarto", "rmd" },
				ignore_buftypes = {},
				hybrid_modes = { "n" },
			}
		}
	},
	{ 'mg979/vim-visual-multi' },
}
