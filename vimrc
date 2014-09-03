" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
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

" Unicode
" Bundle 'chrisbra/unicode.vim'

" Zoom in/out of a window
" Bundle 'vim-scripts/ZoomWin'

" Variable select (around variable: av, inner variable: iv)
Bundle 'robmiller/vim-movar'

" Surround
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'

" sneak.vim (jumps to any location specified by two characters)
Bundle 'justinmk/vim-sneak'

" Comments
Bundle 'tpope/vim-commentary'

" Match everything with %
Bundle 'edsono/vim-matchit'

" Languages-related plugins
Bundle 'wavded/vim-stylus'
Bundle 'digitaltoad/vim-jade'
Bundle 'pangloss/vim-javascript'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'heavenshell/vim-jsdoc'

Bundle 'rodjek/vim-puppet'
" Bundle 'vim-scripts/jshint.vim'
Bundle 'git://github.com/urso/haskell_syntax.vim.git'
Bundle 'vim-scripts/HTML-AutoCloseTag'
Bundle 'mattn/emmet-vim'
Bundle '2072/PHP-Indenting-for-VIm'
Bundle 'moll/vim-node'

" JS-stringify text
Bundle '29decibel/vim-stringify'

" Themes
Bundle 'chriskempson/base16-vim'

" tmux interaction
Bundle 'benmills/vimux'

" Syntastic
" Bundle 'scrooloose/syntastic'

" UltiSnips
Bundle "SirVer/ultisnips"
Bundle "honza/vim-snippets"

syntax on
filetype on
filetype plugin on
filetype indent on

" Coloration
set background=dark
colorscheme base16-default

set encoding=utf-8
set showcmd
set number
set relativenumber
set laststatus=2
set scrolloff=3 " Show 3 lines below / above the cursor

" Leader key
let mapleader = ","

" Insert a new line (Ctrl+J)
nnoremap <NL> i<CR><ESC>

" Set to auto read when a file is changed from the outside
set autoread

" Invisible characters, à la TextMate
set listchars=nbsp:·,tab:▸\ ,eol:¬
set list

" Ignore some files
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.png,*.jpg,*.gif,*.psd

" No auto folding
set nofoldenable

" No Ex mode (see :help Q)
nnoremap Q <nop>

" 80 column
set colorcolumn=80

" Autojump to the last edited position when a file is reopened
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                     \ exe "normal g'\"" | endif

" sneak.vim
let g:sneak#s_next = 1 " Use 's' again to move to the next match
" let g:sneak#streak = 1 " streak mode (easymotion-like)
hi link SneakPluginTarget IncSearch
hi link SneakPluginScope Visual
hi link SneakStreakTarget IncSearch
hi SneakStreakMask ctermfg=red

" Split to the right / below
set splitright
set splitbelow

" Bépo layout:
" Map è to ` and é to ; in command/visual modes
noremap è `
noremap é ;
" More accessible C-]
noremap <Leader>c <C-]>

" Map sentences () to paragraphs [] (more useful)
noremap ( [
noremap [ (
noremap ) ]
noremap ] )

" Switch between tabs
nnoremap <C-l> gt
nnoremap <C-h> gT
" New tab
nnoremap <C-n> :tabnew<cr>

" sudo write
cmap w!! w !sudo tee > /dev/null %

" CtrlP Plugin
let g:ctrlp_map = '<c-t>'  " Remap CtrP plugin on Ctrl+T
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git' " Ignore some files
" From http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_use_caching = 0

" Vimux
let VimuxUseNearestPane = 1
let g:VimuxOrientation = "v"
let g:VimuxHeight = "15"

" JSDoc generation
noremap <Leader>j :JsDoc<cr>

" UltiSnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

" Prompt for a command to run in a tmux pane
nmap <Leader>tc :wa<CR>:call OpenVimuxPrompt('v', '15')<CR>
nmap <Leader>tvc :wa<CR>:call OpenVimuxPrompt('h', '40')<CR>
function! OpenVimuxPrompt(orientation, size)
  let g:VimuxOrientation=a:orientation
  let g:VimuxHeight=a:size
  execute 'VimuxPromptCommand("make")'
endfunction

" Run last command executed by RunVimTmuxCommand
nmap <Leader>tr :wa<CR>:VimuxRunLastCommand<CR>

" Inspect runner pane
nmap <Leader>ti :VimuxInspectRunner<CR>

" Close all other tmux panes in current window
nmap <Leader>tx :VimuxCloseRunner<CR>

" Save
nmap <Leader>s :write<CR>

" OS X Copy
vnoremap <Leader>cp :!pbcopy<CR>u :echo "copied"<CR>

" Whitespace
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set wrap
set backspace=indent,eol,start
set autoindent
set smartindent

" Language-specific spaces
autocmd FileType python setlocal noexpandtab
autocmd FileType html setlocal autoindent
autocmd FileType php setlocal autoindent

" HTML: no indentation inside <script> and <style>
let g:html_indent_script1 = "zero"
let g:html_indent_style1 = "zero"

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
autocmd BufRead,BufNewFile *.md setfiletype markdown
autocmd BufRead,BufNewFile .eslintrc setfiletype javascript

" Searching
set nohlsearch
set incsearch
set ignorecase
set smartcase

" No F1
noremap <F1> <Nop>

" Turn off highlight search
noremap <silent> <Leader>n :set hlsearch!<CR>

" Toggle paste mode
noremap <silent> <Leader>p :set invpaste<CR>:set paste?<CR>

" local cd to the directory containing the file in the buffer
noremap <silent> <Leader>cd :lcd %:h<CR>:pwd<CR>

" local cd to the parent git directory (if exists)
noremap <silent> <Leader>cr :lcd <c-r>=FindGitDirOrCurrent()<CR><CR>:pwd<CR>

" create the directories to the current file
noremap <silent> <Leader>md :call CreateDirectoriesToFile()<CR>

" toggle between last open buffers
noremap <leader><leader> <c-^>

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
