" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" The nice status bar
Bundle 'bling/vim-airline'

" vinegar is a file explorer (press -)
Bundle 'tpope/vim-vinegar'

" Minimalist start screen
Bundle 'mhinz/vim-startify'

" Rename the current file in the vim buffer + retain relative path.
Bundle 'danro/rename.vim'

" Textmate-like Ctrl+T
Bundle 'kien/ctrlp.vim'

" Undo tree
Bundle "sjl/gundo.vim"

" git in Vim
Bundle 'tpope/vim-fugitive'

" ack in Vim
Bundle 'mileszs/ack.vim'

" Zoom in/out of a window
Bundle 'vim-scripts/ZoomWin'

" Variable select (around variable: av, inner variable: iv)
Bundle 'robmiller/vim-movar'

" Surround
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'

" Comments
Bundle 'tomtom/tcomment_vim'

" Languages-related plugins
Bundle 'wavded/vim-stylus'
Bundle 'pangloss/vim-javascript'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'vim-scripts/jshint.vim'
Bundle 'git://github.com/urso/haskell_syntax.vim.git'
Bundle 'vim-scripts/HTML-AutoCloseTag'
Bundle "mattn/emmet-vim"

" JS-stringify text
Bundle '29decibel/vim-stringify'

" Themes
Bundle 'chriskempson/base16-vim'

filetype on
filetype plugin on
filetype indent on

" Coloration
set background=dark
colorscheme base16-default

set nocompatible
syntax enable
set encoding=utf-8
set showcmd
set number
set relativenumber
set laststatus=2
set scrolloff=3 " Show 3 lines below / above the cursor

let mapleader = ","

" Set to auto read when a file is changed from the outside
set autoread

" Invisible characters, à la TextMate
set listchars=nbsp:·,tab:▸\ ,eol:¬
set list

" Ignore some files
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*

" No auto folding
set nofoldenable

" 80 column
set colorcolumn=80

" Autojump to the last edited position when a file is reopened
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                     \ exe "normal g'\"" | endif

" Map è to ` and é to ; in command/visual modes
noremap è `
noremap é ;

" Map sentences () to paragraphs [] (more useful)
noremap ( [
noremap [ (
noremap ) ]
noremap ] )

" Switch between tabs
nmap <C-l> gt
nmap <C-h> gT
" New tab
nmap <C-n> :tabnew<cr>

" sudo write
cmap w!! w !sudo tee > /dev/null %

" CtrlP Plugin
let g:ctrlp_map = '<c-t>'  " Remap CtrP plugin on Ctrl+T
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git' " Ignore some files

" Emmet
" imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
" let g:user_emmet_leader_key='<Tab>'

" Whitespace
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set wrap
set backspace=indent,eol,start
set autoindent
set smartindent

" Language-specific spaces
au FileType python set noexpandtab

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction
function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

" filetypes
au BufRead,BufNewFile *.md setfiletype markdown

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Turn off highlight search
nmap <silent> <Leader>n :set hlsearch!<CR>

" Toggle paste mode
nmap <silent> <Leader>p :set invpaste<CR>:set paste?<CR>

" local cd to the directory containing the file in the buffer
nmap <silent> <Leader>cd :lcd %:h<CR>:pwd<CR>

" local cd to the parent git directory (if exists)
nmap <silent> <Leader>cr :lcd <c-r>=FindGitDirOrCurrent()<CR><CR>:pwd<CR>

" create the directories to the current file
nmap <silent> <Leader>md :call CreateDirectoriesToFile()<CR>

" JSHint
" nmap <silent> <Leader>l :JSHint<CR>

" JS-Stringify strings
map <leader>g :call Stringify()<CR>

" create the directories to the current file
function! CreateDirectoriesToFile()
  let curdir = expand('%:p:h')
  call system('mkdir -p "'.curdir.'"')
  echo 'created '.curdir
endfunction

" returns the parent git directories, or '.'
function! FindGitDirOrCurrent()
  let curdir = expand('%:p:h')
  let gitdir = finddir('.git', curdir . ';')
  if gitdir != ''
    return substitute(gitdir, '\/\.git$', '', '')
  else
    return '.'
  endif
endfunction

" Follow links in help
" Follow the link
nmap <buffer> <Enter> <C-]>
" Follow the help topic in a new split (often useful)
nmap <buffer> <C-Enter> <C-w><C-]><C-w>T

if has("gui_running")
  set guifont=SourceCodePro-Regular:h14
endif
