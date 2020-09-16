" Plugins

call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'morhetz/gruvbox'

Plug 'evanleck/vim-svelte',{ 'branch': 'main' }

" vim-signature: preview and navigate marks
Plug 'kshenoy/vim-signature'

" Plug 'HerringtonDarkholme/yats.vim'
" Plug 'quramy/tsuquyomi'
Plug 'leafgarland/typescript-vim'

Plug 'norcalli/nvim-colorizer.lua'

" Plug 'mcchrish/nnn.vim'

Plug 'chrisbra/unicode.vim'

Plug 'gioele/vim-autoswap'

" The nice status bar
Plug 'bling/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

Plug 'liuchengxu/vim-clap'

" https://github.com/kristijanhusak/vim-js-file-import
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'kristijanhusak/vim-js-file-import', {'do': 'npm install'}

" TO TRY:
" https://github.com/itchyny/lightline.vim/
" https://github.com/machakann/vim-sandwich
" https://github.com/machakann/vim-highlightedyank

" Minimalist start screen
" Plug 'mhinz/vim-startify'

" Rename the current file in the vim buffer + retain relative path.
Plug 'danro/rename.vim'

" Textmate-like Ctrl+T
Plug '/usr/bin/fzf' | Plug 'junegunn/fzf.vim'

" Better than matchit (matchit is included by default on neovim)
Plug 'andymass/vim-matchup'

" Scratchpad
Plug 'metakirby5/codi.vim'

" " Undo tree (Mundo is a fork of Gundo with Neovim support and other things)
" Plug 'simnalamburt/vim-mundo'

" " git in Vim
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" " Variable select (around variable: av, inner variable: iv)
" Plug 'robmiller/vim-movar'

" Surround
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" " sneak.vim (jumps to any location specified by two characters)
" Plug 'justinmk/vim-sneak'

" " Comments
Plug 'tpope/vim-commentary'

Plug 'mrtazz/simplenote.vim'

" " Languages-related plugins
Plug 'pangloss/vim-javascript'
Plug 'heavenshell/vim-jsdoc'
Plug 'mxw/vim-jsx'
" Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'jxnblk/vim-mdx-js'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'reasonml-editor/vim-reason-plus'
Plug 'jparise/vim-graphql'
Plug 'vim-scripts/nginx.vim'
Plug 'moll/vim-node'
Plug 'tomlion/vim-solidity'
Plug 'rust-lang/rust.vim'
Plug 'justinj/vim-pico8-syntax'
Plug 'posva/vim-vue'

" " JS-stringify text
" Plug '29decibel/vim-stringify'

" " tmux interaction
Plug 'benmills/vimux'

" " UltiSnips
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" " Automatically adjusts 'shiftwidth' and 'expandtab' heuristically
Plug 'tpope/vim-sleuth'

" " Tabular alignment
" Plug 'godlygeek/tabular'

" Plug 'stefandtw/quickfix-reflector.vim'

" " Vim Markdown (requires godlygeek/tabular)
" Plug 'plasticboy/vim-markdown'

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release --locked
    else
      !cargo build --release --locked --no-default-features --features json-rpc
    endif
  endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

" Update gitgutter on save
autocmd BufWritePost * GitGutter

" " Org Mode
" Plug 'jceb/vim-orgmode'

" " ctags viewer
" Plug 'majutsushi/tagbar'

" " Calculate vim selections
" Plug 'sk1418/HowMuch'

" " Notes
" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-notes'

Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'ruanyl/vim-sort-imports'

" Themes
Plug 'chriskempson/base16-vim'

call plug#end()

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

" Coloration
" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif

" gruvbox
let g:gruvbox_termcolors = 256
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_invert_tabline = 0

set termguicolors " 24 bits colors in the terminal
set background=dark
" colorscheme base16-snazzy
colorscheme gruvbox

if !has('nvim')
  set encoding=utf-8
endif
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

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-t> coc#refresh()

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Highlight colors (hex etc.)
" lua require'colorizer'.setup()

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
set colorcolumn=
" set colorcolumn=80
" highlight ColorColumn ctermbg=9

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

"""""""""""""""""" ncm2 completion

" enable ncm2 for all buffers
" autocmd BufEnter * call ncm2#enable_for_buffer()

" important: :help Ncm2PopupOpen for more information
" set completeopt=noinsert,menuone,noselect

"""""""""""""""""" /ncm2 completion

" vim-commentary
autocmd FileType lua setlocal commentstring=--\ %s
autocmd FileType pico8 setlocal commentstring=--\ %s

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
nnoremap <Leader>w :q<cr>

" New tab
nnoremap <C-n> :tabnew<cr>

" sudo write
cmap w!! w !sudo tee > /dev/null %

" TernJS
nnoremap td :TernDef<cr>

" vim-markdown
let g:vim_markdown_fenced_languages = ['jsx=javascript', 'ts=typescript', 'tsx=typescript']

" fzf plugin
" let FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'

nmap <c-t> :Files<cr>
nnoremap <silent> <Leader><Enter> :Buffers<CR>

" autocmd VimEnter * command! -bang -nargs=* Ag
"   \ call fzf#vim#ag(<q-args>, '--skip-vcs-ignores', <bang>0)

" Files command with preview window
command! -bang -nargs=? -complete=dir Files
\ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:60%'), <bang>0)

" Ripgrep search
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
nnoremap <C-s> :Rg<cr>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" nnn
let g:nnn#layout = { 'left': '~20%' }
let g:nnn#set_default_mappings = 0
nnoremap <leader><leader> :NnnPicker '%:p:h'<CR>

" fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" fzf window (NeoVim only)
let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" fzf colors
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" Simplenote
" source ~/.simplenoterc
" let g:SimplenoteSingleWindow = 1

" Vimux
let VimuxUseNearestPane = 1
let g:VimuxOrientation = "v"
let g:VimuxHeight = "15"

" JavaScript (vim-javascript)
let g:javascript_conceal_function   = "ƒ"
" let g:javascript_conceal_null       = "ø"
" let g:javascript_conceal_this       = "@"
let g:javascript_conceal_return     = "⇚"
" let g:javascript_conceal_undefined  = "¿"
" let g:javascript_conceal_NaN        = "ℕ"
" let g:javascript_conceal_prototype  = "¶"
let g:javascript_plugin_flow = 1

" JSDoc generation
let g:jsdoc_default_mapping = 0
noremap <Leader>j :JsDoc<cr>

" UltiSnips
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"

" javascript-libraries-syntax
let g:used_javascript_libs = 'underscore,react'

" vim-flow options
let g:flow#autoclose = 1

" prettier and other prettiers
" function! Prettier()
"   let l:currentLine = line('.')
"   silent execute '%!prettier --trailing-comma es5 --no-semi --single-quote --stdin-filepath %'
"   " silent execute '%!prettier --stdin-filepath %'
"   execute 'normal! '. l:currentLine .'Gzz'
"   echom 'prettier done.'
" endfunction
function! LuaFmt()
  let l:currentLine = line('.')
  silent execute '%!luafmt --stdin %'
  execute 'normal! '. l:currentLine .'G'
  echom 'luafmt done.'
endfunction
function! Refmt()
  let l:currentLine = line('.')
  silent execute '%!bsrefmt -w 80'
  execute 'normal! '. l:currentLine .'G'
  echom 'refmt done.'
endfunction
" nmap <Leader>r :call Prettier()<CR>

let g:prettier#config#single_quote = 'true'
let g:prettier#config#semi = 'false'
let g:prettier#config#trailing_comma = 'es5'
let g:prettier#config#arrow_parens = 'always'

nmap <Leader>r <Plug>(Prettier)
autocmd FileType pico8 nmap<Leader>r :call LuaFmt()<CR>
autocmd FileType reason nmap<Leader>r :call Refmt()<CR>
" :RustFmt is defined by rust.vim
autocmd FileType rust nmap<Leader>r :RustFmt<CR>

" Vue.js
" autocmd FileType vue noremap <buffer> <Leader>r :%!prettier --parser parse5 --stdin-filepath<CR>
" autocmd FileType vue noremap <buffer> <Leader>r :%!/Users/pierre/.nodenv/versions/8.4.0/bin/vue-formatter<CR>
" autocmd FileType vue noremap <buffer> <Leader>r :%!/Users/pierre/dev/vue-formatter/src/cli.js<CR>
" autocmd FileType vue noremap <buffer> <Leader>r :%!/Users/pierre/dev/sublime-vue-formatter/scripts/vue/vue-formatter<CR>
" autocmd FileType vue syntax sync fromstart
" let g:vue_disable_pre_processors=1

" Rust
" let g:rustfmt_autosave = 1

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

" Clipboard copy
vnoremap <Leader>cp "+y :echo "copied"<CR>

" Vertical split
nmap <Leader>v :vs<CR>

nmap <Leader>l :m +1<CR>
nmap <Leader>h :m -2<CR>

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
" autocmd FileType javascript set formatprg=prettier\ --single-quote\ --trailing-comma\ all\ --stdin

" HTML: no indentation inside <script> and <style>
let g:html_indent_script1 = "zero"
let g:html_indent_style1 = "zero"

" JSX for JS files too
let g:jsx_ext_required = 0

" QML: Watch a property, myVar => onMyVarChanged: console.log(myVar)
autocmd FileType qml nmap <buffer> <Leader>w yyp"tyt:ion<Esc>lgUlt:aChanged<Esc>lwCconsole.log()<Esc>b"tp^
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
" autocmd BufRead,BufNewFile *.p8 setfiletype lua

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

" Zoom / Unzoom the current window
" nnoremap <silent> <C-w>o :ZoomToggle<CR>

" JSHint
" nmap <silent> <Leader>l :JSHint<CR>

" JS-Stringify strings
map <leader>g :call Stringify()<CR>

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

" Follow links in help
" Follow the link
nmap <buffer> <Enter> <C-]>
" Follow the help topic in a new split (often useful)
nmap <buffer> <C-Enter> <C-w><C-]><C-w>T

" osascript -e 'tell application "PICO-8" to activate' -e 'tell application "System Events" \n key code 53 \n "load $file_name" \n key code 36 \n delay .1 \n key code 15 using control down \n end tell' -e 'tell application "Sublime Text" to activate'
