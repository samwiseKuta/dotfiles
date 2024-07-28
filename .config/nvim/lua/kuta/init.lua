require("kuta.remap")
require("kuta.set")
require("kuta.netrw")
require("kuta.sudoWrite")
require("kuta.lazy_init")
ColorTheme("melange")
vim.g.osname = string.sub(string.lower(vim.loop.os_uname().sysname),0,3)
vim.opt.termguicolors = true
