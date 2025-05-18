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
				preview_callbacks = {
					on_detach = function(_, wins)
						for _, win in ipairs(wins) do
							vim.wo[win].conceallevel = 0;
						end
					end,
				}
			}
		}
	},
	{
		'brenoprata10/nvim-highlight-colors',
		config = function()
			local hlc = require('nvim-highlight-colors')
			vim.keymap.set('n', '<leader>lh', hlc.toggle, { desc = 'Toggle HighlightColors' })
		end
	},
}
