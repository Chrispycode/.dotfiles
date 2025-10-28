return {
	{
		'echasnovski/mini.nvim',
		version = "*",
		keys = {
			{ "<leader>o", function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, desc = "MiniFiles" },
		},
		config = function()
			require('mini.diff').setup()
			require('mini.pairs').setup()
			require('mini.cursorword').setup()
			require('mini.files').setup()
			require('mini.tabline').setup()
			require('mini.git').setup()
			-- Better Around/Inside textobjects
			--
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
			--  - ci'  - [C]hange [I]nside [']quote
			require('mini.ai').setup { n_lines = 500 }

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			--
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require('mini.surround').setup()

			local statusline = require 'mini.statusline'
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return '%2l:%-2v'
			end

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

			local function set_hlgroups()
				vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { fg = colors.black, bg = colors.gray, bold = true })
				vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { fg = colors.black, bg = colors.blue, bold = true })
				vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { fg = colors.black, bg = colors.yellow, bold = true })
				vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { fg = colors.black, bg = colors.red, bold = true })
				vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { fg = colors.black, bg = colors.green, bold = true })
				vim.api.nvim_set_hl(0, 'MiniStatuslineDevinfo', { fg = colors.white, bg = colors.lightgray })
				vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = colors.gray, bg = colors.darkgray })
				vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { fg = colors.white, bg = colors.lightgray })
				vim.api.nvim_set_hl(0, 'MiniStatuslineInactive', { fg = colors.gray, bg = colors.darkgray })
			end

			local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
			local spinner_index = 1
			local processing = false

			local function section_codecompanion()
				if not processing then return '' end
				spinner_index = (spinner_index % #spinner_symbols) + 1
				return '  ' .. spinner_symbols[spinner_index]
			end

			local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "CodeCompanionRequest*",
				group = group,
				callback = function(request)
					if request.match == "CodeCompanionRequestStarted" then
						processing = true
					elseif request.match == "CodeCompanionRequestFinished" then
						processing = false
					end
					vim.cmd('redrawstatus')
				end,
			})

			local unsaved_buffer = function()
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_get_option_value("modified", { buf = buf }) then
						return '🚨' -- any message or icon
					end
				end
				return ''
			end

			local function custom_content()
				local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
				local git           = statusline.section_git({ trunc_width = 40 })
				local diff          = statusline.section_diff({ trunc_width = 75 })
				local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
				local filename      = statusline.section_filename({ trunc_width = 140 })
				local lsp           = statusline.section_lsp({ trunc_width = 75 })
				local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
				local location      = statusline.section_location({ trunc_width = 75 })
				local search        = statusline.section_searchcount({ trunc_width = 75 })

				return statusline.combine_groups({
					{ hl = mode_hl,                 strings = { mode } },
					{ hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
					'%<',
					{ hl = 'MiniStatuslineFilename', strings = { filename, unsaved_buffer() } },
					'%=',
					{ hl = 'MiniStatuslineFilename', strings = { section_codecompanion(), lsp } },
					{ hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
					{ hl = mode_hl,                  strings = { search, location } },
				})
			end

			set_hlgroups()

			statusline.setup({
				content = {
					active = custom_content,
					inactive = function()
						return statusline.combine_groups({
							{ hl = 'MiniStatuslineInactive', strings = { '%f%m' } }
						})
					end
				},
				use_icons = vim.g.have_nerd_font
			})

			local win_config = function()
				local has_statusline = vim.o.laststatus > 0
				local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
				return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
			end
			require('mini.notify').setup({ window = { config = win_config } })
		end,
	}
}
