-- Completion UX: mini.completion (configured in plugins/mini.lua) + blink-like
-- keymaps and pmenu styling. No blink.cmp, no snippets, no nvim-cmp.

vim.o.completeopt = 'menuone,noselect,noinsert,popup'
vim.o.pumborder = 'rounded'
vim.o.pummaxwidth = 60
vim.o.pumheight = 12
vim.o.shortmess = vim.o.shortmess .. 'c' -- silence "match X of Y" messages

-- ----------------------------------------------------------------------------
-- Blink-style insert-mode keymaps for the native completion popup
-- ----------------------------------------------------------------------------

-- <Tab>: if popup open, select first item (if none selected) and accept;
--        otherwise fall through to a regular <Tab>.
vim.keymap.set('i', '<Tab>', function()
	if vim.fn.pumvisible() == 1 then
		local selected = vim.fn.complete_info({ 'selected' }).selected
		return selected == -1 and '<C-n><C-y>' or '<C-y>'
	end
	return '<Tab>'
end, { expr = true, replace_keycodes = true, desc = 'Completion: accept / Tab' })

-- <C-j> / <C-k>: navigate items when popup open, fallback otherwise
vim.keymap.set('i', '<C-j>', function()
	return vim.fn.pumvisible() == 1 and '<C-n>' or '<C-j>'
end, { expr = true, replace_keycodes = true, desc = 'Completion: select next' })

vim.keymap.set('i', '<C-k>', function()
	if vim.fn.pumvisible() == 1 then return '<C-p>' end
	-- No popup: trigger signature help (like blink's <C-k>)
	vim.lsp.buf.signature_help()
	return ''
end, { expr = true, replace_keycodes = true, desc = 'Completion: select prev / signature' })

-- <CR>: confirm selection if one is selected, otherwise insert newline
vim.keymap.set('i', '<CR>', function()
	if vim.fn.pumvisible() == 1 and vim.fn.complete_info({ 'selected' }).selected ~= -1 then
		return '<C-y>'
	end
	return '<CR>'
end, { expr = true, replace_keycodes = true, desc = 'Completion: confirm / newline' })

-- <C-e>: cancel popup (blink default)
vim.keymap.set('i', '<C-e>', function()
	return vim.fn.pumvisible() == 1 and '<C-e>' or '<C-e>'
end, { expr = true, replace_keycodes = true, desc = 'Completion: cancel' })

return {}
