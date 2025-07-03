return {
	{
		'OXY2DEV/markview.nvim',
		lazy = false,
    priority = 49,
		ft = { "markdown", "codecompanion" },
		opts = {
			preview = {
				filetypes = { "markdown", "quarto", "rmd", "codecompanion" },
				ignore_buftypes = {},
				hybrid_modes = { "n" },
			}
		}
	},
	{
		'brenoprata10/nvim-highlight-colors',
		keys = {
			{ '<leader>lh', function() require('nvim-highlight-colors').toggle() end, desc = 'Toggle HighlightColors' }
		},
	},
}
