--============== |General| ============== 
vim.opt.guicursor = ""          -- Set FAT cursor in insert
vim.opt.hlsearch = false        -- Nice search
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8           -- While scrolling, always keep 8 lines above and below
vim.opt.updatetime = 50
vim.opt.colorcolumn = "100"     -- Highlict col x
vim.opt.compatible = false;     -- No need fo Vi compatibility
vim.opt.cmdheight = 1;          -- Commands are x lines tall

--============== |netrw| ============== 
vim.g.netrw_liststyle = 3;              -- Lists like a tree view
vim.g.netrw_browse_split = 4            -- Make netrw open in the current file buffer
vim.g.netrw_banner = 0                  -- Disable banner 
vim.g.netrw_sort_sequence = [[[\/]$,*]] -- Show directories first (sorting)
vim.g.netrw_winsize = 25                -- Netrw size
vim.g.netrw_keepdir = 0                 -- Keep current directory and browsing directory synced.
vim.g.netrw_sizestyle = "H"             -- Human-readable files sizes
vim.opt.nu = true                       -- Line numbers 
vim.opt.relativenumber = true           -- Relative line numbers
--============== |Indenting| ============== 
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
--============== |Undotree| ============== 
vim.opt.swapfile = false --Undotree gains access to old changes
vim.opt.backup = false
local undoDir = "empty"
if vim.g.osname == "win" then
    undoDir = os.getenv("USERPROFILE") ..  "/.vim/undodir"
else
    undoDir = os.getenv("HOME") ..  "/.vim/undodir"
end
vim.undodir = undoDir
vim.opt.undofile = true
