return {
	"bloody",
	dir = ".",
	config = function()
		-- Bloody Neovim Color Scheme
		-- Dark moody palette with deep reds and browns
		vim.opt.termguicolors = true
		vim.opt.background = "dark"
		if vim.fn.exists("syntax_on") then
			vim.cmd("syntax reset")
		end
		vim.g.colors_name = "bloody"

		local c = vim.api.nvim_set_hl

		-- Color palette
		local colors = {
			bg = "none",
			bg_solid = "#000000",
			bg_light = "#3d2a2a",
			gray_dark = "#4a3838",
			gray_med = "#6b5555",
			gray_light = "#9a7f7f",
			red_dark = "#660011",
			red_med = "#9E4244",
			red_muted = "#914a4a",
			red_light = "#B76E79",
			pink = "#F6ACA7",
			brown = "#ba8586",
			orange = "#d4926a",
			white = "#ffffff",
			red_bright = "#ff4444",
		}

		-- Editor background and foreground
		c(0, "Normal", { fg = colors.white, bg = colors.bg })
		c(0, "NonText", { fg = colors.white, bg = colors.bg })
		c(0, "NormalFloat", { fg = colors.white, bg = colors.bg })
		c(0, "NormalNC", { fg = colors.white, bg = colors.bg })

		-- UI elements
		c(0, "Title", { fg = colors.red_med, bg = colors.bg })
		c(0, "LineNr", { fg = colors.bg_light, bg = colors.bg })
		c(0, "CursorLineNr", { fg = colors.red_light, bg = colors.bg })
		c(0, "CursorLine", { fg = colors.bg_solid, bg = colors.red_dark })
		c(0, "CursorColumn", { fg = colors.bg_solid, bg = colors.red_dark })
		c(0, "SignColumn", { fg = colors.red_light, bg = colors.bg })
		c(0, "Folded", { fg = colors.red_light, bg = colors.bg_light })
		c(0, "FoldColumn", { fg = colors.red_light, bg = colors.bg })
		c(0, "QuickFixLine", { fg = colors.red_light, bg = colors.bg })
		c(0, "qfLineNr", { fg = colors.red_med, bg = colors.bg })
		c(0, "qfFileName", { fg = colors.red_light, bg = colors.bg })
		c(0, "SnacksIndent", { fg = colors.red_light, bg = colors.bg })
		c(0, "Question", { fg = colors.red_light, bg = colors.bg })
		c(0, "Directory", { fg = colors.red_light, bg = colors.bg })

		-- Statusline
		c(0, "StatusLine", { fg = colors.white, bg = colors.bg })
		c(0, "StatusLineNC", { fg = colors.bg_light, bg = colors.bg })
		c(0, "StatusLineTerm", { fg = colors.white, bg = colors.bg_light })
		c(0, "StatusLineTermNC", { fg = colors.bg_light, bg = colors.bg })

		-- Search and highlighting
		c(0, "Search", { fg = colors.bg_solid, bg = colors.red_light })
		c(0, "CurSearch", { fg = colors.bg_solid, bg = colors.red_med })
		c(0, "IncSearch", { fg = colors.bg_solid, bg = colors.red_bright })
		c(0, "Substitute", { fg = colors.bg_solid, bg = colors.pink })

		-- Visual mode
		c(0, "Visual", { bg = colors.red_muted })
		c(0, "VisualNOS", { bg = colors.red_muted })

		-- Cursor and selection
		c(0, "Cursor", { fg = colors.bg, bg = colors.white })
		c(0, "lCursor", { fg = colors.bg, bg = colors.white })
		c(0, "vCursor", { fg = colors.bg, bg = colors.white })

		-- Messages and status
		c(0, "ErrorMsg", { fg = colors.red_bright, bg = colors.bg })
		c(0, "WarningMsg", { fg = colors.red_light, bg = colors.bg })
		c(0, "ModeMsg", { fg = colors.pink, bg = colors.bg })
		c(0, "MoreMsg", { fg = colors.red_light, bg = colors.bg })

		-- Diff
		c(0, "DiffAdd", { fg = colors.bg, bg = colors.red_dark })
		c(0, "DiffDelete", { fg = colors.red_dark, bg = colors.bg })
		c(0, "DiffChange", { fg = colors.white, bg = colors.red_muted })
		c(0, "DiffText", { fg = colors.bg, bg = colors.red_light })

		-- Completion menu
		c(0, "Pmenu", { fg = colors.white, bg = colors.bg_light })
		c(0, "PmenuSel", { fg = colors.bg, bg = colors.red_light })
		c(0, "PmenuSbar", { bg = colors.bg_light })
		c(0, "PmenuThumb", { bg = colors.red_med })

		-- Syntax highlighting
		c(0, "Comment", { fg = colors.bg_light, italic = true })
		c(0, "Constant", { fg = colors.pink })
		c(0, "String", { fg = colors.pink })
		c(0, "Character", { fg = colors.pink })
		c(0, "Number", { fg = colors.red_light })
		c(0, "Float", { fg = colors.red_light })
		c(0, "Boolean", { fg = colors.red_med })

		c(0, "Identifier", { fg = colors.brown })
		c(0, "Function", { fg = colors.red_light })

		c(0, "Statement", { fg = colors.red_med })
		c(0, "Conditional", { fg = colors.red_med })
		c(0, "Repeat", { fg = colors.red_med })
		c(0, "Label", { fg = colors.red_light })
		c(0, "Operator", { fg = colors.red_med })
		c(0, "Keyword", { fg = colors.red_med })
		c(0, "Exception", { fg = colors.red_bright })

		c(0, "PreProc", { fg = colors.brown })
		c(0, "Include", { fg = colors.red_light })
		c(0, "Define", { fg = colors.red_light })
		c(0, "Macro", { fg = colors.red_light })
		c(0, "PreCondit", { fg = colors.brown })

		c(0, "Type", { fg = colors.red_light })
		c(0, "StorageClass", { fg = colors.red_med })
		c(0, "Structure", { fg = colors.red_light })
		c(0, "Typedef", { fg = colors.red_light })

		c(0, "Special", { fg = colors.brown })
		c(0, "SpecialChar", { fg = colors.red_bright })
		c(0, "Tag", { fg = colors.red_light })
		c(0, "Delimiter", { fg = colors.red_med })
		c(0, "SpecialComment", { fg = colors.red_light })
		c(0, "Debug", { fg = colors.red_bright })

		c(0, "Underlined", { underline = true, fg = colors.red_light })
		c(0, "Ignore", { fg = colors.bg_light })
		c(0, "Error", { fg = colors.red_bright, bg = colors.bg })
		c(0, "Todo", { fg = colors.bg, bg = colors.red_light })

		-- Treesitter
		c(0, "@comment", { fg = colors.bg_light, italic = true })
		c(0, "@string", { fg = colors.pink })
		c(0, "@number", { fg = colors.red_light })
		c(0, "@constant", { fg = colors.red_light })
		c(0, "@function", { fg = colors.red_light })
		c(0, "@function.call", { fg = colors.red_light })
		c(0, "@keyword", { fg = colors.red_med })
		c(0, "@type", { fg = colors.brown })
		c(0, "@variable", { fg = colors.white })
		c(0, "@property", { fg = colors.brown })
		c(0, "@punctuation", { fg = colors.red_med })
		c(0, "@operator", { fg = colors.red_med })

		-- LSP
		c(0, "DiagnosticError", { fg = colors.red_bright })
		c(0, "DiagnosticWarn", { fg = colors.red_light })
		c(0, "DiagnosticInfo", { fg = colors.red_med })
		c(0, "DiagnosticHint", { fg = colors.brown })
		c(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.red_bright })
		c(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.red_light })
		c(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.red_med })
		c(0, "DiagnosticUnderlineHint", { undercurl = true, sp = colors.brown })
	end
}
