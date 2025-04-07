local has_redrawn = false
local file_ignore_patterns = { 'node_modules', 'tmp', 'log', '.git', '.bundle', 'public/plugin_assets',
  '.idea', '.loadpath', '.powrc', '.rvmc', '.ruby-version', 'db/*.db', 'db/*.sqlite3*',
  'vendor/cache', 'files', '_cacache', '.cache', '*.o', '*.a', '*.min.*', '*.min-*.*',
  '*.out', '*.class', '*.pdf', '*.mkv', '*.mp4', '*.zip', 'plugins_*', 'modules_*', '*.db',
  '*.sqlite3', '*.sqlite', '*.sql', '*.pyc', '*.pyo', '*.lock', '*cache', '*.gem', '*.jar', '*.war' }

return {
  'folke/which-key.nvim',
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      image = {},
      bigfile = {},
      notifier = {},
      zen = {},
      explorer = {},
      git = {},
      indent = {},
      scope = {},
      lazygit = {},
      picker = {
        include = { "plugins/*", "modules/*" },
        sources = {
          files = { ignored = true, hidden = true, exclude = file_ignore_patterns },
          explorer = { ignored = true, hidden = true },
          grep = { ignored = true, hidden = true, exclude = file_ignore_patterns },
          grep_word = { ignored = true, hidden = true, exclude = file_ignore_patterns },
          grep_buffers = { ignored = true, hidden = true, exclude = file_ignore_patterns },
        },
        formatters = {
          file = {
            truncate = 200
          }
        }
      },
      dashboard = {
        preset = {
          keys = {
            { icon = "", key = "n", desc = "New file", action = "<cmd>ene<CR>" },
            { icon = "", key = "lg", desc = "Git", action = function() Snacks.lazygit() end },
            { icon = "󰏔", key = "lm", desc = "Mason", action = "<cmd>Mason<CR>" },
            { icon = "", key = "lc", desc = "Code", action = "<cmd>CodeCompanionActions<CR>" },
            { icon = "", key = "lp", desc = "PLugins", action = "<cmd>Lazy<CR>" },
            { icon = "󰅚", key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
          },
          header = [[
  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒
 ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░
▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██
 ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
 ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
 ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░
    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░
          ░    ░  ░    ░ ░        ░   ░         ░
                                 ░                  ]],

        },
        sections = {
          { section = "header",  padding = 1 },
          { section = "startup", padding = 1 },
          function()
            local version = vim.version()
            return {
              align = 'center',
              text = "   v" .. version.major .. "." .. version.minor .. "." .. version.patch,
              padding = 1,
            }
          end,
          { section = "keys", padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", cwd = true, indent = 2, padding = 1 },
          function()
            if not has_redrawn then
              Snacks.explorer.open()
              has_redrawn = true
            end
            return {
              icon = " ",
              title = "Git Status",
              section = "terminal",
              enabled = function()
                return Snacks.git.get_root() ~= nil
              end,
              cmd = "git status --short --branch --renames",
              height = 5,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }
          end,
        },
      }
    },
    keys = {
      { "<leader><space>", function() Snacks.picker.buffers() end,                          desc = "Buffers" },
      { "<leader>,",       function() Snacks.picker.smart() end,                            desc = "Smart Find Files" },
      { "<leader>/",       function() Snacks.picker.grep() end,                             desc = "Grep" },
      { "<leader>:",       function() Snacks.picker.command_history() end,                  desc = "Command History" },
      { "<leader>n",       function() Snacks.picker.notifications() end,                    desc = "Notification History" },
      -- find
      { "<leader>sf",      function() Snacks.picker.files() end,                            desc = "Find Files" },
      { "<leader>pf",      function() Snacks.picker.files({ cwd = 'plugins' }) end,         desc = "Find Files" },
      { "<leader>fg",      function() Snacks.picker.git_files() end,                        desc = "Find Git Files" },
      { "<leader>fr",      function() Snacks.picker.recent() end,                           desc = "Recent" },
      -- git
      { "<leader>gB",      function() Snacks.picker.git_branches() end,                     desc = "Git Branches" },
      { "<leader>gl",      function() Snacks.picker.git_log() end,                          desc = "Git Log" },
      { "<leader>gL",      function() Snacks.picker.git_log_line() end,                     desc = "Git Log Line" },
      { "<leader>gs",      function() Snacks.picker.git_status() end,                       desc = "Git Status" },
      { "<leader>gS",      function() Snacks.picker.git_stash() end,                        desc = "Git Stash" },
      { "<leader>gd",      function() Snacks.picker.git_diff() end,                         desc = "Git Diff (Hunks)" },
      { "<leader>gf",      function() Snacks.picker.git_log_file() end,                     desc = "Git Log File" },
      { "<leader>gb",      function() Snacks.git.blame_line() end,                          desc = "Git Blame Line" },
      { '<leader>lg',      function() Snacks.lazygit({ cwd = vim.fn.expand('%:p:h') }) end, desc = 'LazyGit' },
      -- Grep
      { "<leader>sB",      function() Snacks.picker.grep_buffers() end,                     desc = "Grep Open Buffers" },
      { "<leader>sg",      function() Snacks.picker.grep() end,                             desc = "Grep" },
      { "<leader>pg",      function() Snacks.picker.grep({ cwd = 'plugins' }) end,          desc = "Grep" },
      { "<leader>sw",      function() Snacks.picker.grep_word() end,                        desc = "Visual selection or word", mode = { "n", "x" } },
      -- search
      {
        "<leader>si",
        function()
          local find_cmd = "find . -type d -not -path '*/\\.*'"
          local dirs = {}
          local handle = io.popen(find_cmd)
          if handle then
            for dir in handle:lines() do
              -- Remove the ./ prefix if present
              dir = dir:gsub("^%./", "")
              if dir ~= "" then
                table.insert(dirs, dir)
              end
            end
            handle:close()
          end
          vim.ui.select(dirs, {
            prompt = "Select directory to search:",
            format_item = function(item)
              return item
            end,
          }, function(choice)
            if choice then
              local dir = vim.fn.fnamemodify(choice, ":p")
              if vim.fn.isdirectory(dir) == 1 then
                Snacks.picker.grep({ cwd = dir })
              else
                vim.notify("Invalid directory: " .. dir, vim.log.levels.ERROR)
              end
            end
          end)
        end,
        desc = "Search in Directory"
      },
      { '<leader>s"', function() Snacks.picker.registers() end,                                   desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end,                              desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end,                                    desc = "Autocmds" },
      { "<leader>sl", function() Snacks.picker.lines() end,                                       desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end,                             desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end,                                    desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end,                                 desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end,                          desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end,                                        desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end,                                  desc = "Highlights" },
      { "<leader>sj", function() Snacks.picker.jumps() end,                                       desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end,                                     desc = "Keymaps" },
      { "<leader>sm", function() Snacks.picker.marks() end,                                       desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end,                                         desc = "Man Pages" },
      { "<leader>sq", function() Snacks.picker.qflist() end,                                      desc = "Quickfix List" },
      { "<leader>so", function() Snacks.picker.resume() end,                                      desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end,                                        desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end,                                desc = "Colorschemes" },
      -- LSP
      { "gd",         function() Snacks.picker.lsp_definitions() end,                             desc = "Goto Definition" },
      { "gD",         function() Snacks.picker.lsp_declarations() end,                            desc = "Goto Declaration" },
      { "gr",         function() Snacks.picker.lsp_references() end,                              nowait = true,                           desc = "References" },
      { "gI",         function() Snacks.picker.lsp_implementations() end,                         desc = "Goto Implementation" },
      { "gy",         function() Snacks.picker.lsp_type_definitions() end,                        desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end,                                 desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end,                       desc = "LSP Workspace Symbols" },
      -- Custom
      { "<leader>k",  function() Snacks.explorer() end,                                           desc = "File Explorer" },
      { '<leader>lb', function() Snacks.dashboard.open() end,                                     desc = 'Dash[b]oard' },
      { '<leader>lz', function() Snacks.zen() end,                                                desc = 'ZenMode' },
      { '<leader>tn', '<cmd>tabnew<cr>',                                                          desc = 'new Tab' },
      { '<leader>lp', ':Lazy<cr>',                                                                desc = 'Lazy' },
      { '<leader>ls', ':LspStart<cr>',                                                            desc = 'LSP Start' },
      { '<leader>lk', ':LspStop<cr>',                                                             desc = 'LSP stop' },
      { '<leader>lm', ':Mason<cr>',                                                               desc = 'Mason' },
      { '<leader>lc', ':CodeCompanionActions<cr>',                                                desc = 'CodeCompanion' },
      { '<leader>lw', ':set wrap<cr>',                                                            desc = 'Toggle Wrap' },
      { '<Esc>',      '<cmd>nohlsearch<CR>',                                                      desc = 'cancel search' },
      { '<leader>q',  function() vim.diagnostic.setloclist() end,                                 desc = 'Open diagnostic [Q]uickfix list' },
      { '<C-h>',      '<C-w><C-h>',                                                               desc = 'Move focus to the left window' },
      { '<C-l>',      '<C-w><C-l>',                                                               desc = 'Move focus to the right window' },
      { '<C-j>',      '<C-w><C-j>',                                                               desc = 'Move focus to the lower window' },
      { '<C-k>',      '<C-w><C-k>',                                                               desc = 'Move focus to the upper window' },
      { '<leader>S',  function() require("spectre").toggle() end,                                 desc = 'Toggle Spectre' },
      { '<leader>sr', function() require("spectre").open_visual({ select_word = true }) end,      desc = 'Search current word' },
      { '<leader>sr', '<esc><cmd>lua require("spectre").open_visual()<CR>',                       desc = 'Search current word',            mode = "v" },
      { '<leader>sp', function() require("spectre").open_file_search({ select_word = true }) end, desc = 'Search on current file' },
    },
  },
}
