return {
	{
		'zbirenbaum/copilot.lua',
		cmd = 'Copilot',
		config = function()
			vim.keymap.del('i', '<S-Tab>')
			require('copilot').setup({ suggestion = { keymap = { accept = "<S-Tab>"}}})
		end,
		keys = {
			{
				'<leader>lc',
				function()
					local clients = vim.lsp.get_clients({ name = "copilot" })
					if #clients > 0 then
						vim.cmd('Copilot disable')
						vim.cmd('Copilot status')
						print("Copilot stopped")
					else
						vim.cmd('Copilot enable')
						vim.cmd('Copilot suggestion')
						vim.cmd('Copilot status')
						print("Copilot started")
					end
				end,
				desc = 'Toggle Copilot'
			},
		}
	},
	{
		'olimorris/codecompanion.nvim',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			{ "nvim-lua/plenary.nvim",  branch = "master" },
			{ 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
		},
		opts = {
			display = {
				action_palette = {
					provider = "default"
				},
			},
			strategies = {
				chat = {
					adapter = os.getenv 'LLM',
					slash_commands = {
						["buffer"] = {
							opts = {
								provider = "snacks"
							}
						}
					}
				},
				inline = {
					adapter = os.getenv 'LLM',
				},
			},
			adapters = {
				ollama = function()
					return require('codecompanion.adapters').extend('ollama', {
						env = {
							url = os.getenv 'LLM_URL',
							api_key = os.getenv 'LLM_API_KEY',
						},
						schema = {
							num_ctx = {
								default = 64000,
							},
							model = {
								-- default = 'llama3.1:latest',
								-- default = 'deepseek-r1:14b',
								-- default = 'deepseek-r1:8b',
								default = os.getenv('LLM_MODEL') or 'qwen2.5-coder:14b',
							},
							-- temperature = { default = 0.6 },
						},
					})
				end,
				copilot = function()
					return require('codecompanion.adapters').extend('copilot', {
						schema = {
							model = {
								-- default = 'claude-sonnet-4',
								default = os.getenv('LLM_MODEL') or 'claude-3.5-sonnet',
								-- default = 'gpt-4.1',
							},
							-- temperature = { default = 0.6 },
						},
					})
				end,
			},
		}
	},
}
