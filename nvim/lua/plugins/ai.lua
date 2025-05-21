return {
	{
		'github/copilot.vim',
		config = function()
			vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false
			})
			vim.g.copilot_no_tab_map = true
		end
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
								default = 'qwen2.5-coder:14b',
							},
							temperature = { default = 0.6 },
						},
					})
				end,
				copilot = function()
					return require('codecompanion.adapters').extend('copilot', {
						schema = {
							model = {
								default = 'claude-3.5-sonnet',
								-- default = 'gpt-4.1',
							},
							temperature = { default = 0.6 },
						},
					})
				end,
			},
		}
	},
}
