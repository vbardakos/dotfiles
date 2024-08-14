vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

vim.g.autoformat = true

local opt = vim.opt
opt.formatexpr = "v:lua.require'lazyvim.utils.options'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- TODO: remove write from make cmd
opt.autowrite = true
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions

opt.number = true
opt.relativenumber = true

opt.mouse = "a"
opt.showmode = false

opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup

-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neo>= 0.10.0
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true
opt.undolevels = 10000

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
opt.ignorecase = true
opt.smartcase = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Decrease update time
opt.updatetime = 200

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
opt.timeoutlen = 300

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sets how neowill display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
-- changed on lazy edit
opt.inccommand = "nosplit"

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.smoothscroll = true

-- fold opts (requires n>= 0.10)
opt.foldexpr = "v:lua.require'main.utils.options'.foldexpr()"
opt.foldmethod = "expr"
opt.foldtext = ""

opt.laststatus = 3 -- global statusline
opt.statuscolumn = [[%!v:lua.require'main.utils.options'.statuscolumn()]]

opt.hlsearch = true

opt.tabstop = 2
opt.shiftwidth = 2

opt.termguicolors = true -- True color support

opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.jumpoptions = "view"
opt.linebreak = true -- Wrap lines at convenient points

opt.sessionoptions =
  { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shortmess:append { W = true, I = true, c = true, C = true }
opt.smartindent = true -- Insert indents automatically
opt.splitkeep = "screen"

opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
