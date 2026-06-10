-- Theme watcher: applies a mini.base16 palette read from theme-colors.lua and
-- live-reloads on file change. Not a plugin — pure side-effect module.
-- Loaded after mini.nvim (so mini.base16 is available).

local theme_file = vim.fn.stdpath("config") .. "/theme-colors.lua"

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

local function apply_palette(palette)
	if type(palette) ~= "table" then return end

	local has_base16, base16 = pcall(require, "mini.base16")
	if not has_base16 then return end

	vim.o.termguicolors = true
	base16.setup({ palette = palette, use_cterm = true })
	vim.g.colors_name = "shell-theme"

	-- Derived colors guaranteed to contrast with base00, independent of palette.
	local fg = palette.base05
	local bar_bg = mix(palette.base00, fg, 0.18)
	local file_bg = mix(palette.base00, fg, 0.32)
	local bar_dim = mix(palette.base00, fg, 0.55)
	local linenr_fg = mix(palette.base00, fg, 0.45)

	local function mode_hl(bg)
		return {
			fg = best_fg(bg, palette.base00, palette.base07),
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
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = palette.base0A, bg = "NONE", bold = true })
	vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
	vim.api.nvim_set_hl(0, "FoldColumn", { fg = linenr_fg, bg = "NONE" })
	vim.api.nvim_set_hl(0, "NonText", { fg = bar_dim, bg = "NONE" })
	vim.api.nvim_set_hl(0, "Whitespace", { fg = bar_dim, bg = "NONE" })

	-- Statusline gets its own solid bar so it always separates from the wallpaper.
	vim.api.nvim_set_hl(0, "StatusLine", { fg = fg, bg = bar_bg })
	vim.api.nvim_set_hl(0, "StatusLineNC", { fg = bar_dim, bg = bar_bg })

	vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", mode_hl(palette.base0B))
	vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", mode_hl(palette.base0D))
	vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", mode_hl(palette.base0E))
	vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", mode_hl(palette.base08))
	vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", mode_hl(palette.base0A))
	vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", mode_hl(palette.base0C))

	vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { fg = fg, bg = bar_bg })
	vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { fg = fg, bg = file_bg, bold = true })
	vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { fg = bar_dim, bg = bar_bg })
	vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = bar_dim, bg = bar_bg })
end

-- Source 1: palette file written by theme-apply.sh (local machine).
local function apply_from_file()
	local ok, palette = pcall(dofile, theme_file)
	if ok then apply_palette(palette) end
end

-- Source 2: no palette file (e.g. over SSH). Drive mini.base16 from the
-- terminal's own 16 ANSI colors via cterm indices with truecolor off. This
-- needs no OSC round-trip (works through tmux/ssh unconditionally) and tracks
-- terminal theme switches for free, since the terminal repaints its palette.
local function apply_cterm_fallback()
	local has_base16, base16 = pcall(require, "mini.base16")
	if not has_base16 then
		vim.o.termguicolors = false
		return
	end

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

	base16.setup({ palette = gui, use_cterm = cterm })
	vim.g.colors_name = "shell-theme"

	-- Keep the editor transparent so the terminal background shows through.
	local fg = vim.api.nvim_get_hl(0, { name = "Normal" }).ctermfg
	vim.api.nvim_set_hl(0, "Normal", { ctermfg = fg })
	vim.api.nvim_set_hl(0, "NormalFloat", { ctermfg = fg })
	vim.api.nvim_set_hl(0, "SignColumn", {})
end

if vim.uv.fs_stat(theme_file) then
	apply_from_file()

	local handle = vim.uv.new_fs_event()
	if handle then
		handle:start(theme_file, {}, vim.schedule_wrap(function(err)
			if err then return end
			apply_from_file()
		end))
	end
else
	apply_cterm_fallback()
end
