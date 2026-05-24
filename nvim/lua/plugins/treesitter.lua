-- nvim-treesitter + treesitter-context
-- nvim-treesitter master branch keeps the classic configs API; the default
-- (main) branch is the new v1.0 API which doesn't have configs.setup.
vim.pack.add({
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },
	{ src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
})

require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'lua', 'vim', 'vimdoc', 'query',
		'markdown', 'markdown_inline', 'embedded_template',
		'ruby', 'slim', 'html', 'yaml', 'css',
		'bash', 'javascript', 'json', 'xml', 'csv',
	},
	endwise = { enable = true },
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { 'ruby' },
	},
	indent = { enable = true, disable = { 'ruby' } },
})

-- Defer treesitter-context (only matters once you're scrolling code)
vim.schedule(function()
	require('treesitter-context').setup({ multiwindow = true })
end)

-- Auto-run :TSUpdate after vim.pack installs/updates nvim-treesitter
vim.api.nvim_create_autocmd('PackChanged', {
	group = vim.api.nvim_create_augroup('user-treesitter-update', { clear = true }),
	callback = function(args)
		local data = args.data or {}
		if data.spec and data.spec.name == 'nvim-treesitter' and (data.kind == 'install' or data.kind == 'update') then
			vim.schedule(function() vim.cmd('TSUpdate') end)
		end
	end,
})
