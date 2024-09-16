-- Set FAT cursor in insert
vim.opt.guicursor = ""

-- No need fo Vi compatibility
vim.opt.compatible = false;

--Commands
vim.opt.cmdheight = 1; -- Commands are x lines tall

--netrw
vim.g.netrw_liststyle = 3; -- Lists like a tree view
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

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

-- Status line
--vim.cmd "highlight StatusType guibg=#b16286 guifg=#1d2021"
--vim.cmd "highlight StatusFile guibg=#fabd2f guifg=#1d2021"
--vim.cmd "highlight StatusModified guibg=#fabd2f guifg=#1d2021"
--vim.cmd "highlight StatusBuffer guibg=#98971a guifg=#1d2021"
--vim.cmd "highlight StatusLocation guibg=#458588 guifg=#1d2021"
--vim.cmd "highlight StatusPercent guibg=#1d2021 guifg=#ebdbb2"
--vim.cmd "highlight StatusNorm guibg=none guifg=white"
vim.o.statusline = " "
				.. ""
				.. "%#StatusType#"
				.. "%Y"
				.. " /"
				.. "%#StatusFile#"
				.. "/ "
				.. "%F"
				.. ""
				.. "%#StatusModified#"
				.. ""
				.. " %m"
				.. " "
				.. "%#StatusNorm#"
				.. "%="
				.. "%#StatusBuffer#"
				.. " "
				.. ""
				.. "%n"
				.. " /"
				.. "%#StatusLocation#"
				.. "/ "
				.. ""
				.. "%l|%c"
				.. " /"
				.. "%#StatusPercent#"
				.. "/ "
				.. "%p%%"
