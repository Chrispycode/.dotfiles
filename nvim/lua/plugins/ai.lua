return {
	{
		'zbirenbaum/copilot.lua',
		cmd = 'Copilot',
		config = function()
			pcall(vim.keymap.del, 'i', '<S-Tab>')
			require('copilot').setup({ suggestion = { keymap = { accept = "<S-Tab>" } } })
		end,
	},
	{
		'olimorris/codecompanion.nvim',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		opts = {
			display = {
				action_palette = {
					provider = "default"
				},
			},
			strategies = {
				chat = {
					adapter = os.getenv 'LLM' or 'ollama',
					slash_commands = {
						["buffer"] = {
							opts = {
								provider = "snacks"
							}
						},
						["file"] = {
							opts = {
								provider = "snacks"
							}
						},
						["help"] = {
							opts = {
								provider = "snacks"
							}
						},
						["symbols"] = {
							opts = {
								provider = "snacks"
							}
						},
					}
				},
				inline = {
					adapter = os.getenv 'LLM' or 'ollama',
				},
			},
			adapters = {
				acp = {
					claude_code = function()
						return require("codecompanion.adapters").extend("claude_code", {
							env = {
								CLAUDE_CODE_OAUTH_TOKEN = os.getenv("CLAUDE_CODE_OAUTH_TOKEN"),
							},
						})
					end,
				},
				http = {
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
									default = os.getenv('LLM_MODEL') or 'qwen3-coder',
								},
							},
						})
					end,
					copilot = function()
						return require('codecompanion.adapters').extend('copilot', {
							schema = {
								model = {
									default = os.getenv('LLM_MODEL') or 'gpt-5-mini',
								},
							},
						})
					end,
				},
			},
		}
	},
}
