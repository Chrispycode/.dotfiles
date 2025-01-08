package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"

return {
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    '3rd/image.nvim',
    build = false,
    opt = {},
    config = function()
      require('image').setup {
        hijack_file_patterns = { '*.png', '*.PNG', '*.jpg', '*.JPG', '*.jpeg', '*.gif', '*.webp', '*.WEBP', '*.avif' },
        tmux_show_only_in_active_window = true,
        window_overlap_clear_enabled = true,
        only_render_image_at_cursor = true,
        processor = "magick_cli"
      }
    end
  },
  {
    "folke/zen-mode.nvim",
    opts = {
    }
  }
}
