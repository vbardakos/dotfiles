-- leader keymap
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- line no
vim.opt.nu = true
vim.opt.relativenumber = true

-- indenting
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- line wrapping
vim.opt.wrap = true

-- prevents default backups
-- increases undotree history 
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

-- searching options
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- coloring
vim.opt.termguicolors = true

-- cursor
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')
vim.opt.updatetime = 50
vim.opt.colorcolumn = '80'

