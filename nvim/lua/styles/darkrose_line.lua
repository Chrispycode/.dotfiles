local colors = {
  black        = '#20111a',
  white        = '#eeeeee',
  red          = '#960000',
  green        = '#583636',
  blue         = '#5f4a4a',
  yellow       = '#914a4a',
  gray         = '#D48E85',
  darkgray     = '#20111a',
  lightgray    = '#000000',
  inactivegray = '#7c6f64',
}
return {
  normal = {
    a = {bg = colors.gray, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.darkgray, fg = colors.gray}
  },
  insert = {
    a = {bg = colors.blue, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.lightgray, fg = colors.white}
  },
  visual = {
    a = {bg = colors.yellow, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.inactivegray, fg = colors.black}
  },
  replace = {
    a = {bg = colors.red, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.black, fg = colors.white}
  },
  command = {
    a = {bg = colors.green, fg = colors.black, gui = 'bold'},
    b = {bg = colors.lightgray, fg = colors.white},
    c = {bg = colors.inactivegray, fg = colors.black}
  },
  inactive = {
    a = {bg = colors.darkgray, fg = colors.gray, gui = 'bold'},
    b = {bg = colors.darkgray, fg = colors.gray},
    c = {bg = colors.darkgray, fg = colors.gray}
  }
}
