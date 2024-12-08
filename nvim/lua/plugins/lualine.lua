return {
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      local colors = {
        black = '#20111a',
        white = '#eeeeee',
        red = '#960000',
        green = '#583636',
        blue = '#5f4a4a',
        yellow = '#914a4a',
        gray = '#D48E85',
        darkgray = '#20111a',
        lightgray = '#000000',
        inactivegray = '#7c6f64',
      }

      local darkrose_bubble = {
        normal = {
          a = { bg = colors.gray, fg = colors.black, gui = 'bold' },
          b = { bg = colors.lightgray, fg = colors.white },
          c = { bg = colors.darkgray, fg = colors.gray },
        },
        insert = {
          a = { bg = colors.blue, fg = colors.black, gui = 'bold' },
          b = { bg = colors.lightgray, fg = colors.white },
          c = { bg = colors.lightgray, fg = colors.white },
        },
        visual = {
          a = { bg = colors.yellow, fg = colors.black, gui = 'bold' },
          b = { bg = colors.lightgray, fg = colors.white },
          c = { bg = colors.inactivegray, fg = colors.black },
        },
        replace = {
          a = { bg = colors.red, fg = colors.black, gui = 'bold' },
          b = { bg = colors.lightgray, fg = colors.white },
          c = { bg = colors.black, fg = colors.white },
        },
        command = {
          a = { bg = colors.green, fg = colors.black, gui = 'bold' },
          b = { bg = colors.lightgray, fg = colors.white },
          c = { bg = colors.inactivegray, fg = colors.black },
        },
        inactive = {
          a = { bg = colors.darkgray, fg = colors.gray, gui = 'bold' },
          b = { bg = colors.darkgray, fg = colors.gray },
          c = { bg = colors.darkgray, fg = colors.gray },
        },
      }
      require('lualine').setup {
        options = { theme = darkrose_bubble, component_separators = '', section_separators = { left = '', right = '' } },
        sections = {
          lualine_a = { { 'mode', right_padding = 2 } },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {
            { 'filename', path = 1 },
            '%=',
          },
          lualine_x = {},
          lualine_y = { 'filetype', 'progress' },
          lualine_z = {
            { 'location', left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        tabline = {},
        extensions = {},
      }
    end,
  },
}
