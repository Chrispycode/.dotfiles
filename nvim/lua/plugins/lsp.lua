return {
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim APIs
		'folke/lazydev.nvim',
		ft = 'lua',
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
			},
		},
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'williamboman/mason.nvim', config = true },
			{ 'williamboman/mason-lspconfig.nvim' },
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			'saghen/blink.cmp',
		},
		config = function()
			vim.diagnostic.config { virtual_text = false }
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set('n', keys, func, { desc = 'LSP: ' .. desc })
					end
					map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
					map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
					map('<leader>ld', vim.diagnostic.open_float, '[l]ine [D]iagnostic')

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
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
							group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
							end,
						})
					end

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map('<leader>th', function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
						end, '[T]oggle Inlay [H]ints')
					end
				end,
			})
			local servers = {
				ruby_lsp = {
					cmd_env = { BUNDLE_GEMFILE = vim.fn.getenv 'GLOBAL_GEMFILE' },
					root_dir = function()
						return vim.loop.cwd()
					end,
				},
				emmet_language_server = {},
				html = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = 'Replace',
							},
							diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
						},
					},
				},
			}

			require('mason').setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				'stylua',
				'css-lsp',
				'ts_ls',
				'bashls',
				'htmlbeautifier',
				'markdownlint',
				'rufo',
				'prettier'
			})

			require('mason-tool-installer').setup { ensure_installed = ensure_installed }
			require('mason-lspconfig').setup {
				automatic_installation = true,
			}

			for server_name, server_config in pairs(servers) do
				local capabilities = require('blink.cmp').get_lsp_capabilities()
				server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
				require('lspconfig')[server_name].setup(server_config)
			end
		end,
	},
	{
		'stevearc/conform.nvim',
		event = { 'BufWritePre' },
		cmd = { 'ConformInfo' },
		keys = {
			{
				'<leader>f',
				function()
					require('conform').format { async = true, lsp_fallback = true }
				end,
				mode = '',
				desc = '[F]ormat buffer',
			},
		},
		opts = {
			notify_on_error = false,
			formatters_by_ft = {
				html = { 'htmlbeautifier', stop_after_first = true },
				eruby = { 'htmlbeautifier', stop_after_first = true },
				ruby = { 'rufo', stop_after_first = true },
				json = { 'prettier', stop_after_first = true },
				jsonc = { 'prettier', stop_after_first = true },
			},
		},
	},
}
