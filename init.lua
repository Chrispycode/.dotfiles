local vim = vim
--- Enable Ruler
vim.opt.ru = true
-- Show the line number
vim.opt.number = true
-- Enable Syntax Highlighting
vim.opt_syntax = true
-- Enable using the mouse to click or select some peace of code
vim.opt.mouse = 'a'
-- Set the Tab to 2 spaces
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
-- set number
vim.opt.relativenumber = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.laststatus = 3
vim.opt.wrap = false
vim.g.mapleader = ' '
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeIgnore = { 'node_modules', '.git' }
vim.g.rails_syntax_enabled = 1
vim.g.closetag_filenames = '*.html,*.erb'
vim.g.ruby_host_prog = 'mise x -- neovim-ruby-host'
vim.cmd('set runtimepath+="plugins"')
vim.cmd('set runtimepath+="modules"')

vim.api.nvim_set_hl(0, "Normal", { bg = 0 })
vim.api.nvim_set_hl(0, "NonText", { bg = 0 })

local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })
Plug('morhetz/gruvbox', { ['as'] = 'gruvbox' })
Plug('water-sucks/darkrose.nvim', { ['as'] = 'darkrose' })
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'nvim-lualine/lualine.nvim'
-- If you want to have icons in your statusline choose one of these
Plug 'nvim-tree/nvim-web-devicons'
Plug 'williamboman/mason.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'
Plug 'stevearc/conform.nvim'
Plug('VonHeikemen/lsp-zero.nvim', { ['branch'] = 'v3.x' })
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'tpope/vim-rails'
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('mg979/vim-visual-multi', { ['branch'] = 'master' })
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'kristijanhusak/vim-dadbod-completion'

Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/vim-be-good'
Plug('nvim-telescope/telescope.nvim', { ['branch'] = '0.1.x' })
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' })
Plug 'kevinhwang91/nvim-bqf'
Plug('ThePrimeagen/harpoon', { ['branch'] = 'harpoon2' })
Plug 'brenoprata10/nvim-highlight-colors'
Plug 'kdheepak/lazygit.nvim'
Plug 'f-person/git-blame.nvim'
Plug 'alvan/vim-closetag'
Plug 'j-hui/fidget.nvim'
Plug 'folke/trouble.nvim'
vim.call('plug#end')

require("catppuccin").setup({ transparent_background = true })
require("darkrose").setup({ colors = { bg = 'none' }, overrides = function(c) return { QuickFixLine = { fg = c.fg_dark } } end })
vim.cmd.colorscheme("darkrose")

require('gitblame').setup({ enabled = false })
require('nvim-highlight-colors').setup({})
require('fidget').setup({})
require('lualine').setup({ options = { theme = require('darkrose_line') }, sections = { lualine_c = { { 'filename', path = 1 } } } })
require('trouble').setup({})

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set("n", "<leader>k", vim.cmd.NERDTreeToggle, {})
vim.keymap.set("n", "<leader>o", vim.cmd.NERDTreeFind, {})
vim.keymap.set("n", "<leader>lg", vim.cmd.LazyGitCurrentFile, {})

require('bqf').setup({ auto_enable = true, auto_resize_height = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':copen<cr>', { noremap = true, desc = 'open quickfix' })
vim.api.nvim_set_keymap('n', '<leader>Q', ':cclose<cr>', { noremap = true, desc = 'close quickfix' })
local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = 'add to harpoon' })
vim.keymap.set("n", "<leader>ee", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'harpoon list' })

local telescope = require("telescope")
telescope.load_extension('fzf')
telescope.load_extension("ui-select")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sv', builtin.vim_options, { desc = 'Search vim options' })
vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = 'search comands' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>si', ":Telescope live_grep search_dirs=",	{ noremap = true, desc = 'Search in specific diretcory' })
vim.keymap.set('n', '<leader>ip', ":Telescope live_grep search_dirs=plugins,modules<CR>",	{ noremap = true, desc = 'search in plugins and modules' })
vim.keymap.set("n", "<leader>sp", ":Telescope find_files search_dirs=plugins,modules<CR>",	{ noremap = true, desc = 'search plugins' })
vim.keymap.set("n", "<leader>st", ":Telescope find_files search_dirs=test<CR>", { noremap = true, desc = 'search tests' })

local tcv = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end

	require("telescope.pickers").new({}, {
		prompt_title = "Harpoon",
		finder = require("telescope.finders").new_table({
			results = file_paths,
		}),
		previewer = tcv.file_previewer({}),
		sorter = tcv.generic_sorter({}),
	}):find()
end

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })

telescope.setup({
	extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } },
	defaults = {
		file_ignore_patterns = {
			"node_modules", "tmp", ".idea", ".loadpath", ".powrc", ".rvmc", ".ruby-version", "db/*.db", "db/*.sqlite3*",
			"vendor/cache", "files", "_cacache", ".cache", "*.o", "*.a", "*.out", "*.class", "*.pdf", "*.mkv", "*.mp4", "*.zip"
		},
		vimgrep_arguments = {
			"rg", "--follow", "--no-heading", "--color=never", "--with-filename", "--line-number", "--column", "--smart-case",
			"--no-ignore", "--glob=!**/.git*/*", "--glob=!**/modules_*/*", "--glob=!**/plugins_*/*",
			"--glob=!**/public/plugin_assets/*", "--glob=!**/test/*",
		},
	},
	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob=!**/.git*/*", "--glob=!**/modules_*/*",
				"--glob=!**/plugins_*/*", "--glob=!**/public/plugin_assets/*",
			},
		},
	},
})

-- LSP
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({})
local conform = require('conform')
conform.setup({
	formatters_by_ft = {
		javascript = { "prettier", stop_after_first = true },
		html = { "htmlbeautifier", "prettier", stop_after_first = true },
		eruby = { "htmlbeautifier" },
		ruby = { "rufo" }
	}
})
vim.keymap.set({ "n", "v" }, "<leader>l",
	function() conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 }) end, {})

require('mason-tool-installer').setup {
	ensure_installed = { "bash-language-server", "css-lsp", "eslint-lsp", "htmlbeautifier",
		"lua-language-server", "prettier", "ruby-lsp", "rufo", "solargraph"},
}

require('mason-lspconfig').setup({
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
	},
})

local lspconfig = require('lspconfig')
lspconfig.solargraph.setup({
	settings = {
		solargraph = {
			cmd = "solargraph",
			diagnostics = true,
			completion = true
		}
	},
})

-- Treesitter
require('nvim-treesitter.configs').setup({
	ensure_installed = { "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "ruby", "html", "yaml", "css", "bash", "javascript" },
	highlight = { enable = true },
	endwise = { enable = true },
})

