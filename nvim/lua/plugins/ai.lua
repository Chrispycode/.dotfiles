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
		version = '*',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		keys = {
			{ '<leader>la', ':CodeCompanionActions<cr>', desc = 'CodeCompanion' },
			{ '<leader>lo', ':CodeCompanionChat adapter=opencode<cr>', desc = 'OpenCode Chat' }
		},
		opts = {
			memory = {
				opts = {
					chat = {
						enabled = true,
					},
				},
			},
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
					},
					opts = {
						system_prompt = function(ctx)
							local prompt = ctx.default_system_prompt
							local f = io.open(vim.fn.expand("~/.dotfiles/nvim/system-prompt-overrides.md"), "r")
							if f then
								prompt = prompt .. "\n" .. f:read("*a")
								f:close()
							end
							return prompt
						end,
					}
				},
				inline = {
					adapter = os.getenv 'LLM' or 'ollama',
				},
			},
			adapters = {
				acp = {
					opencode = function()
						return require("codecompanion.adapters").extend("opencode", {})
					end,
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
