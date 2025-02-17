local file_ignore_patterns = { 'node_modules', 'tmp', 'log', '.git', '.bundle', 'public/plugin_assets',
  '.idea', '.loadpath', '.powrc', '.rvmc', '.ruby-version', 'db/*.db', 'db/*.sqlite3*',
  'vendor/cache', 'files', '_cacache', '.cache', '*.o', '*.a', '%.min.*', '%.min-%.*',
  '*.out', '*.class', '*.pdf', '*.mkv', '*.mp4', '*.zip', 'plugins_*', 'modules_*', '*.db',
  '*.sqlite3', '*.sqlite', '*.sql', '*.pyc', '*.pyo', '*.lock', '*cache', '*.gem', '*.jar', '*.war' }

local rg_ignore_opts = ''
for _, pattern in ipairs(file_ignore_patterns) do
  rg_ignore_opts = rg_ignore_opts .. ' -g "!' .. pattern .. '"'
end

local img_previewer ---@type string[]?
for _, v in ipairs({
  { cmd = "ueberzug", args = {} },
  { cmd = "chafa",    args = { "{file}", "--format=symbols" } },
  { cmd = "viu",      args = { "-b" } },
}) do
  if vim.fn.executable(v.cmd) == 1 then
    img_previewer = vim.list_extend({ v.cmd }, v.args)
    break
  end
end

return {
  {
    'ibhagwan/fzf-lua',
    opts = {
      fzf_colors = true,
      previewers = {
        builtin = {
          extensions = {
            ["png"] = img_previewer,
            ["jpg"] = img_previewer,
            ["jpeg"] = img_previewer,
            ["gif"] = img_previewer,
            ["webp"] = img_previewer,
            ["svg"] = img_previewer,
          },
          ueberzug_scaler = "fit_contain",
        },
        bat = {
          theme = 'ansi',
        },
      },
      files = {
        rg_opts = [[ --color=always --files --hidden --no-ignore --follow]] .. rg_ignore_opts,
      },
      grep = {
        rg_opts = [[ --color=always --column --hidden --no-ignore --follow]] .. rg_ignore_opts,
      },
    },
    keys = function()
      local fzf_lua = require 'fzf-lua'
      local config = fzf_lua.config
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "preview-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-u>"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-d>"] = "preview-page-down"
      config.defaults.keymap.builtin["<m-p>"] = "toggle-preview"
      vim.keymap.set('n', '<leader>sh', fzf_lua.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', fzf_lua.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', fzf_lua.files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', fzf_lua.builtin, { desc = '[S]earch [S]elect' })
      vim.keymap.set('n', '<leader>sw', fzf_lua.grep_cword, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', fzf_lua.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', fzf_lua.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>so', fzf_lua.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', fzf_lua.oldfiles, { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader><leader>', fzf_lua.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sc', fzf_lua.commands, { desc = 'search commands' })
      vim.keymap.set('n', '<leader>si', function()
        fzf_lua.fzf_exec('find . -type d', {
          prompt = 'Select Directory> ',
          actions = {
            ['default'] = function(selected)
              fzf_lua.live_grep { cwd = selected[1] }
            end
          }
        })
      end, { noremap = true, desc = 'Search in specific diretcory' })
      vim.keymap.set('n', '<leader>pg', function()
        fzf_lua.live_grep { cwd = 'plugins' }
      end, { noremap = true, desc = 'search in plugins and modules' })
      vim.keymap.set('n', '<leader>pf', function()
        fzf_lua.files { cwd = 'plugins' }
      end, { noremap = true, desc = 'search plugins' })
      vim.keymap.set('n', '<leader>s/', function()
        fzf_lua.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
      end, { desc = '[S]earch [/] in Open Files' })
      vim.keymap.set('n', '<leader>sn', function()
        fzf_lua.files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
}
