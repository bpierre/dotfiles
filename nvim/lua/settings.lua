require("utils")

local opt = vim.opt
local cmd = vim.cmd
local home = os.getenv("HOME")

opt.cursorline = true
opt.modeline = false
opt.mouse = "a"

-- live search / replace
opt.inccommand = "nosplit"

-- 24 bits colors
opt.termguicolors = true
opt.background = "dark"

opt.showcmd = true
opt.number = true
opt.relativenumber = true
opt.laststatus = 2

-- show 3 lines below / above the cursor
opt.scrolloff = 3

-- set to auto read when a file is changed from the outside
opt.autoread = true

-- ensure file watchers are notified when a file has been written.
opt.backupcopy = "yes"
opt.backup = false
opt.writebackup = false
opt.hidden = true
opt.cmdheight = 1
opt.signcolumn = "yes"
opt.shortmess:append("c")

-- required by nvim-compe
opt.completeopt = { "menuone", "noselect" }

-- invisible characters, à la TextMate
opt.list = true
opt.listchars = { nbsp = "·", tab = "▸\\", eol = "¬" }

-- ignore some files
opt.wildignore:append("*/.git/*,*/.hg/*,*/.svn/*,*.png,*.jpg,*.gif")

-- no auto folding
opt.foldenable = false

-- disable column
opt.colorcolumn = ""

-- split to the right / below
opt.splitright = true
opt.splitbelow = true

-- whitespace
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.wrap = true
opt.backspace = { "indent", "eol", "start" }
opt.autoindent = true
opt.smartindent = true

-- language-specific space settings
cmd("autocmd FileType python setlocal noexpandtab")

-- always show tabs
opt.showtabline = 2

-- search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- persistent undo across vim sessions
opt.undodir = home .. "/.config/nvim-undo"
opt.undofile = true
