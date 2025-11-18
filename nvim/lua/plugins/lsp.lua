return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'mason-org/mason.nvim',          config = true },
			{ 'mason-org/mason-lspconfig.nvim' },
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
					map('<leader>ld', vim.diagnostic.open_float, '[l]ine [D]iagnostic')

					local function client_supports_method(client, method, bufnr)
						if vim.fn.has 'nvim-0.11' == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
					if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
						map('<leader>th', function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
						end, '[T]oggle Inlay [H]ints')
					end
				end,
			})
			local servers = {
				ruby_lsp = {
					cmd_env = { BUNDLE_GEMFILE = vim.fn.getenv 'GLOBAL_GEMFILE' },
					reuse_client = function(client, config)
						return client.name == 'ruby_lsp'
					end,
				},
				herb_ls = {},
				qmlls = {
					cmd = { "qmlls", "-E" }
				},
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
				cssls = {},
				ts_ls = {},
				bashls = {},
				emmet_language_server = {},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				'stylua',
				'markdownlint',
				'rufo',
				'prettier'
			})
			require('mason').setup()
			require('mason-tool-installer').setup { ensure_installed = ensure_installed }
			require('mason-lspconfig').setup {
				automatic_installation = true,
				automatic_enable = false,
				ensure_installed = vim.tbl_keys(servers)
			}
			for server_name, server_config in pairs(servers) do
				local capabilities = require('blink.cmp').get_lsp_capabilities()
				server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
				vim.lsp.enable(server_name)
				vim.lsp.config(server_name, server_config)
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
				ruby = { 'rufo', stop_after_first = true },
				json = { 'prettier', stop_after_first = true },
				jsonc = { 'prettier', stop_after_first = true },
			},
		},
	},
}
