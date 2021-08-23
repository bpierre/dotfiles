lua require('plugins')

syntax on
filetype on
filetype plugin on
filetype indent on

set cursorline
set nomodeline

set mouse=a

set re=1

" live search / replace
set inccommand=nosplit

set termguicolors " 24 bits colors
set background=dark

colorscheme gruvbox-flat

set showcmd
set number
set relativenumber
set laststatus=2
set scrolloff=3 " Show 3 lines below / above the cursor

" Leader key
let mapleader = ","

" Remap increment as C-g (C-a is used by tmux)
nnoremap <C-g> <C-a>

" Insert a new line (Ctrl+J)
nnoremap <NL> i<CR><ESC>

" Set to auto read when a file is changed from the outside
set autoread

" Ensure file watchers are notified when a file has been written.
set backupcopy=yes
set nobackup
set nowritebackup
set hidden
set cmdheight=1
set shortmess+=c
set signcolumn=yes

" Required by nvim-compe
set completeopt=menuone,noselect

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Invisible characters, à la TextMate
set listchars=nbsp:·,tab:▸\ ,eol:¬
set list

" Ignore some files
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*.png,*.jpg,*.gif,*.psd

" No auto folding
set nofoldenable

" No Ex mode (see :help Q)
nnoremap Q <nop>

" Disable column
set colorcolumn=

" Autojump to the last edited position when a file is reopened
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                     \ exe "normal g'\"" | endif

" Update gitgutter on save
autocmd BufWritePost * GitGutter

" tabs style
highlight TabLineFill ctermfg=LightGreen ctermbg=DarkGreen
highlight TabLine ctermfg=Blue ctermbg=Yellow
highlight TabLineSel ctermfg=Red ctermbg=Yellow

" vim-commentary
" autocmd FileType lua setlocal commentstring=--\ %s
" autocmd FileType pico8 setlocal commentstring=--\ %s

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
nnoremap <C-l> :tabnext<cr>
nnoremap <C-h> :tabprev<cr>

" Cycle between the windows (panes)
nnoremap <C-c> <C-w><C-w>

" Close window
" nnoremap <Leader>w :tabclose<cr>
" nnoremap <Leader>w <C-w>c
" nnoremap <Leader>w :q<cr>
" nnoremap <Leader>w :BufferClose<cr>
nnoremap <Leader>w :bdelete<cr>

" New tab
nnoremap <C-n> :tabnew<cr>

" sudo write
cmap w!! w !sudo tee > /dev/null %

" Vimux
let VimuxUseNearestPane = 1
let g:VimuxOrientation = "v"
let g:VimuxHeight = "15"

" UltiSnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

" Markdown composer
let g:markdown_composer_autostart = 0

" Telescope
nnoremap <c-t> <cmd>Telescope find_files<cr>

nnoremap <silent> <leader>r :FormatWrite<CR>
autocmd FileType rust nmap<Leader>r :RustFmt<CR>

" Prompt for a command to run in a tmux pane
nmap <Leader>tc :wa<CR>:call OpenVimuxPrompt('v', '15')<CR>
nmap <Leader>tvc :wa<CR>:call OpenVimuxPrompt('h', '40')<CR>
function! OpenVimuxPrompt(orientation, size)
  let g:VimuxOrientation=a:orientation
  let g:VimuxHeight=a:size
  execute 'VimuxPromptCommand("make ")'
endfunction

" Run last command executed by RunVimTmuxCommand
nmap <Leader>tr :wa<CR>:VimuxRunLastCommand<CR>

" Inspect runner pane
nmap <Leader>ti :VimuxInspectRunner<CR>

" Close all other tmux panes in current window
nmap <Leader>tx :VimuxCloseRunner<CR>

" Save
nmap <Leader>s :write<CR>

" file explorer
nnoremap <Leader>l :CocCommand explorer<CR>

" Clipboard copy
vnoremap <Leader>cp "+y :echo "copied"<CR>

" Vertical split
nmap <Leader>v :vs<CR>

" Follow links in help
" Follow the link
nmap <buffer> <Enter> <C-]>
" Follow the help topic in a new split (often useful)
nmap <buffer> <C-Enter> <C-w><C-]><C-w>T

" Whitespace
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set wrap
set backspace=indent,eol,start
set autoindent
set smartindent

" Always show tabs
set showtabline=2

" Language-specific spaces
autocmd FileType python setlocal noexpandtab
autocmd FileType html setlocal autoindent
autocmd FileType php setlocal autoindent
autocmd FileType qml setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4

" JSX for JS files too
let g:jsx_ext_required = 0

" QML: Watch a property, myVar => onMyVarChanged: console.log(myVar)
" autocmd FileType qml nmap <buffer> <Leader>w yyp"tyt:ion<Esc>lgUlt:aChanged<Esc>lwCconsole.log()<Esc>b"tp^
" autocmd FileType qml nmap <buffer> <Leader>w yyp:s/^\( \+\)property .+ /\1/<CR>^"tyt:ion<Esc>lgUlt:aChanged<Esc>lwCconsole.log()<Esc>b"tp^

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
autocmd BufRead,BufNewFile .eslintrc setfiletype json
autocmd BufRead,BufNewFile .babelrc setfiletype json
autocmd BufRead,BufNewFile .swcrc setfiletype json
autocmd BufRead,BufNewFile *.cocoascript setfiletype javascript
autocmd BufRead,BufNewFile *.sketchscript setfiletype javascript

" Searching
set nohlsearch
set incsearch
set ignorecase
set smartcase

" Persistent undo across vim sessions
set undofile
set undodir=~/.vim/undo

" No matching paren highlight
let loaded_matchparen = 1
" highlight MatchParen cterm=bold ctermbg=none ctermfg=red

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
" noremap <leader><leader> <c-^>
noremap <backspace> <c-^>

" Mundo plugin
noremap <leader>u :MundoToggle<CR>
let g:mundo_preview_bottom = 1

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

" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
