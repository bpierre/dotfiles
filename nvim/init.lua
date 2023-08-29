require('plugins')
require('settings')
require('mappings')

-- syntaxic coloration
vim.cmd('syntax on')

-- detect filetypes and load corresponding plugins
vim.cmd('filetype plugin on')

-- detect filetypes and load corresponding indent files
vim.cmd('filetype indent on')

-- theme (see settings.lua for opt.termguicolors and opt.background)
vim.cmd('colorscheme gruvbox')

-- tabs style
vim.cmd('highlight TabLineFill ctermfg=LightGreen ctermbg=DarkGreen')
vim.cmd('highlight TabLine ctermfg=Blue ctermbg=Yellow')
vim.cmd('highlight TabLineSel ctermfg=Red ctermbg=Yellow')

-- filetypes
declare_filetype('.prettierrc', 'json')
declare_filetype('.eslintrc', 'json')
declare_filetype('.babelrc', 'json')
declare_filetype('.swcrc', 'json')

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
