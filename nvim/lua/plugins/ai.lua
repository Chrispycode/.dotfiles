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
							return ctx.default_system_prompt ..
									"\nDo not create documentation or add comments to code unless the user explicitly requests you to do so." ..
									"\n# `AGENTS.md` auto-context\n  \n            This file (plus the legacy `AGENT.md` variant) is always added to\n            the assistant’s context. It documents:\n  \n            -  common commands (typecheck, lint, build, test)\n  \n            -  code-style and naming preferences\n  \n            -  overall project structure\n  \n  \n            If you need new recurring commands or conventions, ask the user\n            whether to append them to `AGENTS.md` for future runs."
						end,
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
