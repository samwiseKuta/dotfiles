--Set the leader to start commands
vim.g.mapleader = " "
-- Open netrw (File tree)
vim.keymap.set("n", "<leader>ko",':30Lex<CR>')
--CTRL C should function the same as escape, something with vertical save idk theprimeagem said it
vim.keymap.set("n","<C-c>","<Esc>")
vim.keymap.set("v","<C-c>","<Esc>")
--Remove trailing whitespace
vim.keymap.set('n', '<Leader>rws', [[:%s/\s\+$//e<cr>]])
--Move highlited lines up and down with capital J and K
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
--Cursor stays at the start when appending line below to current line
vim.keymap.set("n", "J", "mzJ`z")
--Cursor stays centered when half page jumping and searching
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
--Paste without overwriting current copied buffer
vim.keymap.set("x","<leader>p","\"_dP")
--Paste from system clipboard
vim.keymap.set("n","<leader>p","\"+p")
--Copy to system clipboard
vim.keymap.set("n","<leader>y","\"+y")
vim.keymap.set("v","<leader>y","\"+y")
--Delete to void register
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
--Copy full path to current buffer
vim.keymap.set("n","<leader>cap",":let @+ = expand(\"%:p\")")
--Copy relative path to current buffer
vim.keymap.set("n","<leader>crp",":let @+ = expand(\"%\")")
-- Set buftype to non-empty (e.g. nowrite) to prevent Neovim asking the file has changed question
vim.keymap.set("v","<leader>p","\"+p")
--No capital Q, it's evil
vim.keymap.set("n","Q","<nop")
--Find and replace current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
--Make current file executable (Linux)
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
--LSP bindings
vim.api.nvim_create_autocmd('LspAttach',{
    callback = function(e)

        local opts = {buffer = e.buf}

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>ws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>rf", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
})
-- adjust split sizes easier
vim.keymap.set("n", "<C-Left>", ":vertical resize +3<CR>")		-- Control+Left resizes vertical split +
vim.keymap.set("n", "<C-Right>", ":vertical resize -3<CR>")	-- Control+Right resizes vertical split -
-- easy split navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")	-- control+h switches to left split
vim.keymap.set("n", "<C-l>", "<C-w>l")	-- control+l switches to right split
vim.keymap.set("n", "<C-j>", "<C-w>j")	-- control+j switches to bottom split
vim.keymap.set("n", "<C-k>", "<C-w>k")  -- control+k switches to top split
--Auto completion bindings
-- Bindings can be found in lazy/cmp.lua

