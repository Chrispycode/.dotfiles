local theme_file = vim.fn.stdpath("config") .. "/theme-colors.lua"

return {
	"theme-watcher",
	dir = ".",
	priority = 999,
	config = function()
		if not vim.uv.fs_stat(theme_file) then
			vim.o.termguicolors = false
			return
		end

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

		local function apply_theme()
			local ok, palette = pcall(dofile, theme_file)
			if not ok or type(palette) ~= "table" then return end

			local has_base16, base16 = pcall(require, "mini.base16")
			if not has_base16 then return end

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

		apply_theme()

		local handle = vim.uv.new_fs_event()
		if handle then
			handle:start(theme_file, {}, vim.schedule_wrap(function(err)
				if err then return end
				apply_theme()
			end))
		end
	end,
}
