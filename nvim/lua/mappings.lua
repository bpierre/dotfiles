require("utils")
require("fns")

-- leader key
vim.g.mapleader = ","

keymap("v", "<Leader>c", ":'<,'>!~/dotfiles/nvim/js/css-literal-to-object.js<CR>", { noremap = true })

-- remap increment as C-g (C-a is used by tmux)
keymap("n", "<C-g>", "<C-a>", {})

-- insert a new line (Ctrl+J)
keymap("n", "<NL>", "i<CR><ESC>")

-- no ex mode (see :help Q)
keymap("n", "Q", "<nop>")

-- map sentences () to paragraphs [] (more useful)
keymap("n", "(", "[", { noremap = true })
keymap("n", "[", "(", { noremap = true })
keymap("n", ")", "]", { noremap = true })
keymap("n", "]", ")", { noremap = true })

-- bépo layout
-- map è to ` and é to ; in command/visual modes
keymap("n", "è", "`", { noremap = true })
keymap("n", "é", ";", { noremap = true })
-- more accessible C-]
keymap("n", "<Leader>c", "<C-]>", { noremap = true })

-- switch between tabs
keymap("n", "<C-l>", ":tabnext<cr>")
keymap("n", "<C-h>", ":tabprev<cr>")
-- keymap("n", "<C-l>", ":BufferNext<CR>")
-- keymap("n", "<C-h>", ":BufferPrevious<CR>")

-- cycle between the windows (panes)
keymap("n", "<C-c>", "<C-w><C-w>")

-- close window (delete buffer)
keymap("n", "<Leader>w", ":bdelete<cr>")
-- keymap("n", "<Leader>w", ":BufferClose<CR>")

-- new tab
keymap("n", "<C-n>", ":tabnew<cr>")

-- save
keymap("n", "<Leader>s", ":write<CR>")

-- sudo write
keymap("c", "w!!", "w !sudo tee > /dev/null %")

-- clipboard copy
keymap("v", "<Leader>cp", '"+y :echo "copied"<CR>')

-- vertical split
keymap("n", "<Leader>v", ":vs<CR>")

-- follow links in help
keymap_buf("n", "<Enter>", "<C-]>")

-- follow the help topic in a new split
keymap_buf("n", "<C-Enter>", "<C-w><C-]><C-w>T")

-- no F1
keymap("n", "<F1>", "<Nop>")

-- turn off highlight search
keymap("n", "<Leader>n", ":set hlsearch!<CR>", { silent = true })

-- toggle paste mode
keymap("n", "<Leader>p", ":set invpaste<CR>:set paste?<CR>", { silent = true })

-- local cd to the directory containing the file in the buffer
keymap("n", "<Leader>cd", ":lcd %:h<CR>:pwd<CR>", { silent = true })

-- local cd to the parent git directory (if exists)
keymap("n", "<Leader>cr", ":lcd <c-r>=FindGitDirOrCurrent()<CR><CR>:pwd<CR>", { silent = true })

-- create the directories to the current file
keymap("n", "<Leader>md", ":lua create_dirs_to_current_file()<CR>", { silent = true })

-- toggle between last open buffers
keymap("n", "<backspace>", "<c-^>")

-- restart lsp clients
keymap("n", "<Leader>l", ":LspRestart<CR>")

-- show LSP signature help
-- keymap("n", "<Space>", ":lua vim.lsp.buf.hover()<CR>")
keymap("n", "<Space>", ":Lspsaga hover_doc<CR>")
keymap("n", "<c-Space>", ":Lspsaga peek_definition<CR>")

-- auto complete imports on enter
-- function coc_complete_auto_imports()
--   if (vim.fn.pumvisible() ~= 0) then
--     return '<C-y>'
--   else
--     return '<C-g>u<CR>'
--   end
-- end
-- keymap('n', '<expr> <cr>', ':lua coc_complete_auto_imports()<CR>')

-- telescope
local telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<c-t>", telescope_builtin.find_files, {})

-- tmux: prompt for a command to run in a tmux pane
keymap("n", "<Leader>tc", ':wa<CR>:lua open_vimux_prompt("v", "15")<CR>')
keymap("n", "<Leader>tvc", ':wa<CR>:lua open_vimux_prompt("h", "40")<CR>')

-- tmux: run last command executed by RunVimTmuxCommand
keymap("n", "<Leader>tr", ":wa<CR>:VimuxRunLastCommand<CR>")

-- tmux: inspect runner pane
keymap("n", "<Leader>ti", ":VimuxInspectRunner<CR>")

-- tmux: close all other tmux panes in current window
keymap("n", "<Leader>tx", ":VimuxCloseRunner<CR>")

-- mundo plugin
keymap("n", "<leader>u", ":MundoToggle<CR>")

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
