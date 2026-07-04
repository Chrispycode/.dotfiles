-- nvim-treesitter is only used as a parser installer. Highlighting and folds
-- are handled by Neovim's native Tree-sitter APIs.
vim.pack.add({
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
})

vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('user-treesitter-start', { clear = true }),
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- Defer treesitter-context (only matters once you're scrolling code)
vim.schedule(function()
	require('treesitter-context').setup({ multiwindow = true })
end)
