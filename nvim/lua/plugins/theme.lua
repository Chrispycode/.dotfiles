vim.o.termguicolors = false

-- Same base-slot -> ANSI-color mapping the generator template encodes,
-- expressed as cterm indices (0-15) instead of hex.
local cterm = {
	base00 = 0, base01 = 0, base02 = 8, base03 = 8,
	base04 = 7, base05 = 7, base06 = 15, base07 = 15,
	base08 = 1, base09 = 11, base0A = 3, base0B = 2,
	base0C = 6, base0D = 4, base0E = 5, base0F = 13,
}

-- A gui palette is mandatory but unused while 'termguicolors' is off; use a
-- standard base16 scheme so nothing breaks if truecolor is toggled on.
local gui = {
	base00 = "#181818", base01 = "#282828", base02 = "#383838", base03 = "#585858",
	base04 = "#b8b8b8", base05 = "#d8d8d8", base06 = "#e8e8e8", base07 = "#f8f8f8",
	base08 = "#ab4642", base09 = "#dc9656", base0A = "#f7ca88", base0B = "#a1b56c",
	base0C = "#86c1b9", base0D = "#7cafc2", base0E = "#ba8baf", base0F = "#a16946",
}

require('mini.base16').setup({ palette = gui, use_cterm = cterm })

-- Keep the editor transparent so the terminal background shows through.
local function hex_to_rgb(hex)
hex = hex:gsub("#", "")
return tonumber(hex:sub(1, 2), 16),
	tonumber(hex:sub(3, 4), 16),
	tonumber(hex:sub(5, 6), 16)
end

local function luminance(hex)
local r, g, b = hex_to_rgb(hex)
return (0.299 * r + 0.587 * g + 0.114 * b) / 255
end

-- Linearly mix two hex colors: t=0 -> c1, t=1 -> c2.
local function mix(c1, c2, t)
local r1, g1, b1 = hex_to_rgb(c1)
local r2, g2, b2 = hex_to_rgb(c2)
return string.format("#%02x%02x%02x",
	math.floor(r1 * (1 - t) + r2 * t + 0.5),
	math.floor(g1 * (1 - t) + g2 * t + 0.5),
	math.floor(b1 * (1 - t) + b2 * t + 0.5))
end

-- Pick whichever of `a`/`b` has the highest contrast with `bg`.
local function best_fg(bg, a, b)
local lbg = luminance(bg)
return math.abs(luminance(a) - lbg) >= math.abs(luminance(b) - lbg) and a or b
end

-- Derived colors guaranteed to contrast with base00, independent of palette.
local fg = vim.g.terminal_color_5
local bar_bg = mix(vim.g.terminal_color_0, fg, 0.18)
local file_bg = mix(vim.g.terminal_color_0, fg, 0.32)
local bar_dim = mix(vim.g.terminal_color_0, fg, 0.55)
local linenr_fg = mix(vim.g.terminal_color_0, fg, 0.45)

local function mode_hl(bg)
	return {
		fg = best_fg(bg, vim.g.terminal_color_0, vim.g.terminal_color_7),
		bg = bg,
		bold = true,
	}
end

-- Keep editor area transparent, but lift dim UI text so it stays readable.
vim.api.nvim_set_hl(0, "Normal", { fg = fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "LineNr", { fg = linenr_fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = linenr_fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = linenr_fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = vim.g.terminal_color_3, bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FoldColumn", { fg = linenr_fg, bg = "NONE" })
vim.api.nvim_set_hl(0, "NonText", { fg = bar_dim, bg = "NONE" })
vim.api.nvim_set_hl(0, "Whitespace", { fg = bar_dim, bg = "NONE" })
--
-- -- Statusline gets its own solid bar so it always separates from the wallpaper.
vim.api.nvim_set_hl(0, "StatusLine", { fg = fg, bg = bar_bg })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = bar_dim, bg = bar_bg })

-- vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", mode_hl(vim.g.terminal_color_11))
-- vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", mode_hl(vim.g.terminal_color_13))
-- vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", mode_hl(vim.g.terminal_color_14))
-- vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", mode_hl(vim.g.terminal_color_8))
-- vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", mode_hl(vim.g.terminal_color_3))
-- vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", mode_hl(vim.g.terminal_color_12))
--
-- vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = fg, bg = bar_bg })
-- vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = fg, bg = file_bg, bold = true })
-- vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = bar_dim, bg = bar_bg })
-- vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = bar_dim, bg = bar_bg })
