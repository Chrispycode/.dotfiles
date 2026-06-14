-- Theme: autogenerate a mini.base16 palette from the terminal's live colors.
-- Query the terminal over OSC for fg/bg and its ANSI palette, build base00-07
-- with mini_palette, and take base08-0F from the terminal's ANSI accents.

-- Accent base16 slot -> terminal ANSI color index.
local accent = {
	base08 = 1, base09 = 11, base0A = 3, base0B = 2,
	base0C = 6, base0D = 4, base0E = 5, base0F = 13,
}

local term = {}

local function osc_hex(rgb)
	local r, g, b = rgb:match("rgb:(%x+)/(%x+)/(%x+)")
	local function to8(c) return math.floor(tonumber(c, 16) / (16 ^ #c - 1) * 255 + 0.5) end
	return string.format("#%02x%02x%02x", to8(r), to8(g), to8(b))
end

local function query()
	vim.api.nvim_ui_send("\027]10;?\027\\")
	vim.api.nvim_ui_send("\027]11;?\027\\")
	for _, i in pairs(accent) do
		vim.api.nvim_ui_send(string.format("\027]4;%d;?\027\\", i))
	end
end

vim.api.nvim_create_autocmd("TermResponse", {
	callback = function(ev)
		local seq = ev.data.sequence
		local idx, rgb = seq:match("\027%]4;(%d+);(rgb:%x+/%x+/%x+)")
		if idx then
			term[tonumber(idx)] = osc_hex(rgb)
		else
			local f = seq:match("\027%]10;(rgb:%x+/%x+/%x+)")
			local b = seq:match("\027%]11;(rgb:%x+/%x+/%x+)")
			if f then term.fg = osc_hex(f) end
			if b then term.bg = osc_hex(b) end
		end

		if not (term.fg and term.bg) then return end
		local palette = require("mini.base16").mini_palette(term.bg, term.fg)
		for slot, i in pairs(accent) do
			if term[i] then palette[slot] = term[i] end
		end
		vim.o.termguicolors = true
		require("mini.base16").setup({ palette = palette, use_cterm = true })

		-- Transparent background.
		vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
	end,
})

-- Re-query on startup and whenever Nvim detects a terminal theme change.
vim.api.nvim_create_autocmd("OptionSet", { pattern = "background", callback = query })
query()
