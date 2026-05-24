-- vim-visual-multi (multi-cursor) loads eagerly (small + always-available keys)
-- markview.nvim is loaded only on markdown filetype
vim.pack.add({
	{ src = 'https://github.com/mg979/vim-visual-multi' },
}, {})

vim.pack.add({
	{ src = 'https://github.com/OXY2DEV/markview.nvim' },
}, { load = false })

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'markdown', 'quarto', 'rmd' },
	once = true,
	group = vim.api.nvim_create_augroup('user-markview-load', { clear = true }),
	callback = function()
		vim.cmd('packadd markview.nvim')
		require('markview').setup({
			preview = {
				filetypes = { 'markdown', 'quarto', 'rmd' },
				ignore_buftypes = {},
				hybrid_modes = { 'n' },
			},
		})
	end,
})
