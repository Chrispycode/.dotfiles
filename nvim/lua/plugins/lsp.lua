-- Native LSP setup (Neovim 0.12+). No nvim-lspconfig, no mason, no conform.
-- npm-based servers are defined in nvim/package.json and installed locally.
-- Run `npm install` (or `npm ci`) in the nvim/ directory. Versions are pinned
-- in package-lock.json. Other servers (ruby-lsp via Gemfile, lua-language-server,
-- qmlls) must still be installed via system package manager / gem.

local npm_bin = function(name)
	return vim.fs.joinpath(vim.fn.stdpath('config'), 'node_modules', '.bin', name)
end

vim.diagnostic.config { virtual_text = false }

-- LspAttach: keymaps, highlights, document colors, inlay hints, format
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
		end
		map('<leader>ld', vim.diagnostic.open_float, '[l]ine [D]iagnostic')
		map('<leader>f', function()
			vim.lsp.buf.format { async = true }
		end, '[F]ormat buffer')

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then return end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
			local highlight_augroup = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = false })
			vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})
			vim.api.nvim_create_autocmd('LspDetach', {
				group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds { group = 'user-lsp-highlight', buffer = event2.buf }
				end,
			})
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentColor, event.buf) then
			vim.lsp.document_color.enable(true, { bufnr = event.buf })
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
			map('<leader>th', function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
			end, '[T]oggle Inlay [H]ints')
		end
	end,
})

-- ============================================================================
-- Server configurations
-- ============================================================================

local global_gemfile = vim.fn.getenv('GLOBAL_GEMFILE')
if global_gemfile == vim.NIL then global_gemfile = '' end

-- ruby-lsp: https://github.com/Shopify/ruby-lsp
-- Install: gem install ruby-lsp
vim.lsp.config('ruby_lsp', {
	cmd = function(dispatchers, config)
		local cmd = { 'ruby-lsp' }
		if config and config.cmd_env and config.cmd_env.BUNDLE_GEMFILE then
			cmd = { 'bundle', 'exec', 'ruby-lsp' }
		end
		return vim.lsp.rpc.start(cmd, dispatchers, {
			cwd = config and config.root_dir and (config.cmd_cwd or config.root_dir) or nil,
			env = config and config.cmd_env or nil,
		})
	end,
	filetypes = { 'ruby', 'eruby' },
	root_markers = { 'Gemfile.lock', '*.gemspec', 'Gemfile', '.git' },
	cmd_env = (global_gemfile ~= '') and { BUNDLE_GEMFILE = global_gemfile } or nil,
	init_options = { formatter = 'auto' },
	on_new_config = function(new_config, _root_dir)
		if global_gemfile ~= '' then
			new_config.cmd_env = vim.tbl_extend('force', new_config.cmd_env or {},
				{ BUNDLE_GEMFILE = global_gemfile })
		end
	end,
	reuse_client = function(client, config)
		config.cmd_cwd = config.root_dir
		return client.name == config.name and client.config.cmd_cwd == config.cmd_cwd
	end,
})

-- herb-language-server: https://github.com/marcoroth/herb
-- Install: npm install (see nvim/package.json)
vim.lsp.config('herb_ls', {
	cmd = { npm_bin('herb-language-server'), '--stdio' },
	filetypes = { 'html', 'eruby' },
	root_markers = { 'Gemfile', '.git' },
	settings = {
		languageServerHerb = {
			linter = {
				excludedRules = {
					'erb-require-trailing-newline',
					'erb-no-extra-newline',
					'html-no-block-inside-inline',
				},
			},
			formatter = {
				maxLineLength = 160,
				enabled = true,
			},
		},
	},
})

-- qmlls: https://doc.qt.io/qt-6/qtqml-tooling-qmlls.html
-- Install: pacman -S qt6-declarative  (ships with Qt)
vim.lsp.config('qmlls', {
	cmd = { 'qmlls6', '-E' },
	filetypes = { 'qml', 'qmljs' },
	root_markers = { '.git' },
})

-- lua-language-server: https://github.com/luals/lua-language-server
-- Install mise use aqua:LuaLS/lua-language-server
vim.lsp.config('lua_ls', {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = {
		{ '.luarc.json', '.luarc.jsonc', '.emmyrc.json' },
		{ '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
		{ '.git' },
	},
	settings = {
		Lua = {
			completion = { callSnippet = 'Replace' },
			diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
		},
	},
})

-- vscode-css-language-server: https://github.com/hrsh7th/vscode-langservers-extracted
vim.lsp.config('cssls', {
	cmd = { npm_bin('vscode-css-language-server'), '--stdio' },
	filetypes = { 'css', 'scss', 'less' },
	init_options = { provideFormatter = true },
	root_markers = { 'package.json', '.git' },
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
})

-- typescript-language-server: https://github.com/typescript-language-server/typescript-language-server
vim.lsp.config('ts_ls', {
	cmd = { npm_bin('typescript-language-server'), '--stdio' },
	filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
	init_options = { hostInfo = 'neovim' },
	root_markers = {
		{ 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' },
		{ '.git' },
	},
})

-- pyright: https://github.com/microsoft/pyright
vim.lsp.config('pyright', {
	cmd = { npm_bin('pyright-langserver'), '--stdio' },
	filetypes = { 'python' },
	root_markers = {
		'pyrightconfig.json', 'pyproject.toml', 'setup.py',
		'setup.cfg', 'requirements.txt', 'Pipfile', '.git',
	},
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = 'openFilesOnly',
			},
		},
	},
})

vim.lsp.enable {
	'ruby_lsp',
	'herb_ls',
	'qmlls',
	'lua_ls',
	'cssls',
	'ts_ls',
	'pyright',
}

return {}
