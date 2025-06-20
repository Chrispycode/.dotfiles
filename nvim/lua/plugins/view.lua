return {
	{
		'OXY2DEV/markview.nvim',
		lazy = false,
		ft = { "markdown", "codecompanion" },
		opts = {
			preview = {
				filetypes = { "markdown", "quarto", "rmd", "codecompanion" },
				ignore_buftypes = {},
				hybrid_modes = { "n" },
			}
		}
	},
}
