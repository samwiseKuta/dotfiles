-- Execute lua files from the /lua directory
require("core.set")
require("core.remap")
require("core.statusline")
vim.g.osname = string.sub(string.lower(vim.loop.os_uname().sysname),0,3)
require("lazy_init")

