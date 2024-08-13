return {
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
}
