-- Set FAT cursor in insert
vim.opt.guicursor = ""

-- No need fo Vi compatibility
vim.opt.compatible = false;

--Commands
vim.opt.cmdheight = 1; -- Commands are x lines tall

vim.g.netrw_keepdir = 0;

--============== netrw ============== 
---- Make netrw open in the current file buffer

vim.g.netrw_liststyle = 3; -- Lists like a tree view
vim.g.netrw_browse_split = 4
-- Netrw banner
-- 0 : Disable banner
-- 1 : Enable banner
vim.g.netrw_banner = 0
-- Show directories first (sorting)
vim.g.netrw_sort_sequence = [[[\/]$,*]]
vim.g.netrw_winsize = 25
-- Keep the current directory and the browsing directory synced.
-- This helps you avoid the move files error.
vim.g.netrw_keepdir = 0
-- Human-readable files sizes
vim.g.netrw_sizestyle = "H"
-- Line numbers and Relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

--Line indenting
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

--Undotree gains access to old changes
vim.opt.swapfile = false
vim.opt.backup = false
local undoDir = "empty"

if vim.g.osname == "win" then
    undoDir = os.getenv("USERPROFILE") ..  "/.vim/undodir"
else
    undoDir = os.getenv("HOME") ..  "/.vim/undodir"

end
vim.undodir = undoDir
vim.opt.undofile = true

--Nice looking search
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.updatetime = 50

vim.opt.colorcolumn = "100"

