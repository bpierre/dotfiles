require('plugins')
require('settings')
require('mappings')

vim.cmd([[
  " syntax coloration
  syntax on
  " detect filetypes and load corresponding plugins
  filetype plugin on
  " detect filetypes and load corresponding indent files
  filetype indent on

  " theme (see settings.lua for opt.termguicolors and opt.background)
  colorscheme gruvbox

  " tabs style
  highlight TabLineFill ctermfg=LightGreen ctermbg=DarkGreen
  highlight TabLine ctermfg=Blue ctermbg=Yellow
  highlight TabLineSel ctermfg=Red ctermbg=Yellow
]])

-- filetypes
vim.filetype.add({
  filename = {
    ['.prettierrc'] = 'json',
    ['.eslintrc'] = 'json',
    ['.babelrc'] = 'json',
    ['.swcrc'] = 'json'
  }
})

-- autojump to the last edited position when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    local last_line = vim.fn.getpos('$')[2]
    local last_edit = vim.api.nvim_buf_get_mark(0, '"')
    if last_edit[1] > 0 and last_edit[1] <= last_line then
      vim.api.nvim_win_set_cursor(0, last_edit)
    end
  end
})

-- refresh gitgutter on save
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*',
  callback = function() vim.cmd('GitGutter') end
})
