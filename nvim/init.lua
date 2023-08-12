require('plugins')
require('settings')
require('mappings')

local cmd = vim.cmd

-- syntaxic coloration
cmd([[ syntax on ]])

-- detect filetypes and load corresponding plugins
cmd([[ filetype plugin on ]])

-- detect filetypes and load corresponding indent files
cmd([[ filetype indent on ]])

-- theme (see settings.lua for opt.termguicolors and opt.background)
cmd([[colorscheme gruvbox]])

-- tabs style
cmd([[ highlight TabLineFill ctermfg=LightGreen ctermbg=DarkGreen ]])
cmd([[ highlight TabLine ctermfg=Blue ctermbg=Yellow ]])
cmd([[ highlight TabLineSel ctermfg=Red ctermbg=Yellow ]])

-- filetypes
declare_filetype('.prettierrc', 'json')
declare_filetype('.eslintrc', 'json')
declare_filetype('.babelrc', 'json')
declare_filetype('.swcrc', 'json')

-- autojump to the last edited position when a file is reopened
cmd(
    [[autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif]])

-- update gitgutter on save
cmd([[ autocmd BufWritePost * GitGutter ]])
