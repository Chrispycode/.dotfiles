return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      'kdheepak/lazygit.nvim',
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      { 'kevinhwang91/nvim-bqf', ft = 'qf' },
    },
    config = function()
      local focus_preview = function(prompt_bufnr)
        local action_state = require 'telescope.actions.state'
        local picker = action_state.get_current_picker(prompt_bufnr)
        local prompt_win = picker.prompt_win
        local previewer = picker.previewer
        local winid = previewer.state.winid
        local bufnr = previewer.state.bufnr
        vim.keymap.set('n', '<Tab>', function()
          vim.cmd(string.format('noautocmd lua vim.api.nvim_set_current_win(%s)', prompt_win))
        end, { buffer = bufnr })
        vim.cmd(string.format('noautocmd lua vim.api.nvim_set_current_win(%s)', winid))
      end

      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        defaults = {
          mappings = {
            n = {
              ['<Tab>'] = focus_preview,
            },
            i = {
              ['<Tab>'] = focus_preview,
            },
          },
          layout_config = {
            horizontal = { width = 0.95 },
          },
          file_ignore_patterns = {
            'node_modules',
            'tmp',
            '.idea',
            '.loadpath',
            '.powrc',
            '.rvmc',
            '.ruby-version',
            'db/*.db',
            'db/*.sqlite3*',
            'vendor/cache',
            'files',
            '_cacache',
            '.cache',
            '*.o',
            '*.a',
            '*.out',
            '*.class',
            '*.pdf',
            '*.mkv',
            '*.mp4',
            '*.zip',
          },
          vimgrep_arguments = {
            'rg',
            '--follow',
            '--no-heading',
            '--color=never',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--no-ignore',
            '--glob=!**/.git*/*',
            '--glob=!**/modules_*/*',
            '--glob=!**/plugins_*/*',
            '--glob=!**/public/plugin_assets/*',
            '--glob=!**/test/*',
          },
        },
        pickers = {
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = {
              'rg',
              '--files',
              '--hidden',
              '--no-ignore',
              '--glob=!**/.git*/*',
              '--glob=!**/modules_*/*',
              '--glob=!**/plugins_*/*',
              '--glob=!**/public/plugin_assets/*',
            },
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'lazygit')
      vim.cmd "autocmd BufEnter * :lua require('lazygit.utils').project_root_dir()"
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sv', builtin.vim_options, { desc = 'Search vim options' })
      vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = 'search comands' })
      vim.keymap.set('n', '<leader>si', ':Telescope live_grep search_dirs=', { noremap = true, desc = 'Search in specific diretcory' })
      vim.keymap.set('n', '<leader>ip', ':Telescope live_grep search_dirs=plugins,modules<CR>', { noremap = true, desc = 'search in plugins and modules' })
      vim.keymap.set('n', '<leader>sp', ':Telescope find_files search_dirs=plugins,modules<CR>', { noremap = true, desc = 'search plugins' })
      vim.keymap.set('n', '<leader>st', ':Telescope find_files search_dirs=test<CR>', { noremap = true, desc = 'search tests' })
      vim.keymap.set('n', '<leader>sl', ":lua require('telescope').extensions.lazygit.lazygit()<CR>", { noremap = true, desc = 'search tests' })
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    lazy = false,
    config = function()
      local h = require 'harpoon'
      h.setup {}
      local tcv = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = tcv.file_previewer {},
            sorter = tcv.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<C-e>', function()
        toggle_telescope(h:list())
      end, { desc = 'Open harpoon window' })
      vim.keymap.set('n', '<leader>a', function()
        h:list():add()
      end, { desc = 'add to harpoon' })
      vim.keymap.set('n', '<leader>ee', function()
        h.ui:toggle_quick_menu(h:list())
      end, { desc = 'harpoon list' })
    end,
  },
}
