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
	{
		'water-sucks/darkrose.nvim',
		priority = 1000,
		init = function ()
			vim.cmd.colorscheme('darkrose')
		end,
		opts = function()
			require('darkrose').setup({
				colors = { bg = 'none' },
				overrides = function(c)
					return { QuickFixLine = { fg = c.fg_dark }, CursorColumn = { bg = '#20111a' }, NormalFloat = { bg = c.bg } }
				end,
			})
		end
	},
	{ 'mg979/vim-visual-multi' },
}
