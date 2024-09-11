local o = vim.o

o.background = "dark"
o.showmode = false
o.wrap = false
o.breakindent = false
o.inccommand = "split"
o.incsearch = true
o.termguicolors = true -- Correct terminal colors

-- Default: "!,'100,<50,s10,h"
o.shada = "!,'250,<50,s50,h"
o.history = 10000

o.swapfile = false
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true -- Sets undo to file

o.scrolloff = 8
o.signcolumn = "yes"
o.timeoutlen = 500 -- Trigger which-key
o.splitbelow = false
o.splitright = true
o.updatetime = 1000
o.wildmode = "list,full"
o.wildignorecase = true
o.pumheight = 12 -- Number of completions
o.ignorecase = true
o.smartcase = true

o.number = true
o.relativenumber = true
o.cursorlineopt = "number"

o.autoindent = true
o.expandtab = true
o.smarttab = true
o.smartindent = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 8

o.list = true
o.listchars = "tab:» ,trail:·,nbsp:␣"

-- Remove mouse pop-up text
vim.cmd([[ aunmenu PopUp.How-to\ disable\ mouse ]])
vim.cmd([[ aunmenu PopUp.-1- ]])

-- Use Oil.nvim instead of netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd([[ nnoremap \ :Oil <cr> ]])

-- Windows to close with "q"
vim.cmd([[ autocmd FileType vim,help,qf,lspinfo nnoremap <buffer><silent> q :close<CR> ]])
vim.cmd([[ autocmd FileType man nnoremap <buffer><silent> q :quit<CR> ]])

