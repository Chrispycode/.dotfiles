return {
	"theme-watcher",
	dir = ".",
	priority = 999,
	config = function()
		local theme_file = vim.fn.stdpath("config") .. "/theme-colors.lua"

		-- No theme file = standalone/server setup, let bloody.lua handle it
		if not vim.uv.fs_stat(theme_file) then return end

		local function apply_theme()
			local ok, palette = pcall(dofile, theme_file)
			if not ok or type(palette) ~= "table" then return end

			local has_base16, base16 = pcall(require, "mini.base16")
			if not has_base16 then return end

			base16.setup({ palette = palette, use_cterm = true })
			vim.g.colors_name = "shell-theme"
			vim.api.nvim_set_hl(0, "Normal", { fg = palette.base05, bg = "NONE" })
			vim.api.nvim_set_hl(0, "NormalFloat", { fg = palette.base05, bg = "NONE" })
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
