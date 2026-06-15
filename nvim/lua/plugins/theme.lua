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

-- mini.base16 styles everything (incl. StatusLine and all MiniStatusline*
-- groups) straight from the palette, so no manual highlight wiring is needed.
require('mini.base16').setup({ palette = gui, use_cterm = cterm })

-- Keep the editor area transparent so the terminal background shows through,
-- while leaving mini.base16's statusline colors intact.
for _, group in ipairs({
	"Normal", "NormalFloat", "SignColumn", "LineNr", "LineNrAbove",
	"LineNrBelow", "CursorLineNr", "FoldColumn", "NonText", "Whitespace",
}) do
	local hl = vim.api.nvim_get_hl(0, { name = group })
	hl.bg = nil
	hl.ctermbg = nil
	vim.api.nvim_set_hl(0, group, hl)
end
