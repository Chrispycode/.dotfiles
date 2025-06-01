return {
	{
		'nvim-lualine/lualine.nvim',
		config = function()
			local colors = {
				black = '#20111a',
				white = '#eeeeee',
				red = '#960000',
				green = '#583636',
				blue = '#5f4a4a',
				yellow = '#914a4a',
				gray = '#D48E85',
				darkgray = '#20111a',
				lightgray = '#000000',
				inactivegray = '#7c6f64',
			}

			local darkrose_bubble = {
				normal = {
					a = { bg = colors.gray, fg = colors.black, gui = 'bold' },
					b = { bg = colors.lightgray, fg = colors.white },
					c = { bg = colors.darkgray, fg = colors.gray },
				},
				insert = {
					a = { bg = colors.blue, fg = colors.black, gui = 'bold' },
					b = { bg = colors.lightgray, fg = colors.white },
					c = { bg = colors.lightgray, fg = colors.white },
				},
				visual = {
					a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
					b = { bg = colors.lightgray, fg = colors.white },
					c = { bg = colors.inactivegray, fg = colors.black },
				},
				replace = {
					a = { bg = colors.red, fg = colors.black, gui = 'bold' },
					b = { bg = colors.lightgray, fg = colors.white },
					c = { bg = colors.black, fg = colors.white },
				},
				command = {
					a = { bg = colors.green, fg = colors.black, gui = 'bold' },
					b = { bg = colors.lightgray, fg = colors.white },
					c = { bg = colors.inactivegray, fg = colors.black },
				},
				inactive = {
					a = { bg = colors.darkgray, fg = colors.gray, gui = 'bold' },
					b = { bg = colors.darkgray, fg = colors.gray },
					c = { bg = colors.darkgray, fg = colors.gray },
				},
			}
			local CC = require("lualine.component"):extend()

			CC.processing = false
			CC.spinner_index = 1

			local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏", }
			local spinner_symbols_len = 10

			-- Initializer
			function CC:init(options)
				CC.super.init(self, options)

				local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

				vim.api.nvim_create_autocmd({ "User" }, {
					pattern = "CodeCompanionRequest*",
					group = group,
					callback = function(request)
						if request.match == "CodeCompanionRequestStarted" then
							self.processing = true
						elseif request.match == "CodeCompanionRequestFinished" then
							self.processing = false
						end
					end,
				})
			end

			-- Function that runs every time statusline is updated
			function CC:update_status()
				if self.processing then
					self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
					return spinner_symbols[self.spinner_index]
				else
					return nil
				end
			end

			local unsaved_buffer = function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_get_option_value("modified", { buf = buf }) then
						return 'Unsaved buffers 🚨' -- any message or icon
					end
				end
				return ''
			end

			require('lualine').setup {
				options = { theme = darkrose_bubble, component_separators = '', section_separators = { left = '', right = '' } },
				sections = {
					lualine_a = { { 'mode', right_padding = 2 } },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = {
						{ 'filename', path = 1 },
						'%=',
					},
					lualine_x = { CC, unsaved_buffer, 'lsp_status' },
					lualine_y = { 'filetype', 'progress' },
					lualine_z = {
						{ 'location', left_padding = 2 },
					},
				},
				inactive_sections = {
					lualine_a = { 'filename' },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { 'location' },
				},
				tabline = {},
				extensions = {},
			}
		end,
	},
}
