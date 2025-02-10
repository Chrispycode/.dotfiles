-- package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
-- package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"

return {
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    ft = { "markdown", "codecompanion" },
    opts = {
      preview = {
        filetypes = { "markdown", "quarto", "rmd", "codecompanion" },
        ignore_buftypes = {},
      }
    }
  },
  -- {
  --   '3rd/image.nvim',
  --   build = false,
  --   opt = {},
  --   config = function()
  --     require('image').setup {
  --       hijack_file_patterns = { '*.png', '*.PNG', '*.jpg', '*.JPG', '*.jpeg', '*.gif', '*.webp', '*.WEBP', '*.avif' },
  --       tmux_show_only_in_active_window = true,
  --       window_overlap_clear_enabled = true,
  --       only_render_image_at_cursor = true,
  --       processor = "magick_cli"
  --     }
  --   end
  -- },
  {
    "folke/zen-mode.nvim",
    opts = {}
  },
  {
    'brenoprata10/nvim-highlight-colors',
    config = function()
      local hlc = require('nvim-highlight-colors')
      vim.keymap.set('n', '<leader>lh', hlc.toggle, { desc = 'Toggle HighlightColors' })
    end
  },
}
