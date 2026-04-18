return {
	"theme-watcher",
	dir = ".",
	priority = 999,
	config = function()
		local theme_file = vim.fn.stdpath("config") .. "/theme-colors.lua"

		local function apply_theme()
			local ok, palette = pcall(dofile, theme_file)
			if not ok or type(palette) ~= "table" then return false end

			local has_base16, base16 = pcall(require, "mini.base16")
			if not has_base16 then return false end

			base16.setup({ palette = palette, use_cterm = true })
			vim.g.colors_name = "shell-theme"
			vim.api.nvim_set_hl(0, "Normal", { fg = palette.base05, bg = "NONE" })
			vim.api.nvim_set_hl(0, "NormalFloat", { fg = palette.base05, bg = "NONE" })
			return true
		end

		-- Try applying on startup; fall through to bloody.lua if no file yet
		if vim.uv.fs_stat(theme_file) then
			apply_theme()
		end

		-- Watch for live theme changes
		local handle = vim.uv.new_fs_event()
		if handle then
			handle:start(theme_file, {}, vim.schedule_wrap(function(err)
				if err then return end
				apply_theme()
			end))
		end
	end,
}
