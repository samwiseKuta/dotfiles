-- Set FAT cursor in insert
vim.opt.guicursor = ""

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

