--Set the leader to start commands
vim.g.mapleader = " "
-- Open netrw (File tree)
-- '<Cmd>Lex<CR>'
vim.keymap.set("n", "<leader>ko", '<Cmd>Lex<CR>',{silent=true})
--CTRL C should function the same as escape
vim.keymap.set({"n","v","i","x"},"<C-c>","<Esc>")
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
        vim.keymap.set("n", "<leader>fd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>rf", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
})
-- adjust split sizes easier
vim.keymap.set("n", "<C-Left>", ":vertical resize -3<CR>",{silent = true})		-- Control+Left resizes vertical split +
vim.keymap.set("n", "<C-Right>", ":vertical resize +3<CR>",{silent=true})	-- Control+Right resizes vertical split -
vim.keymap.set("n", "<C-Up>", ":horizontal resize -3<CR>",{silent = true})		-- Control+Left resizes vertical split +
vim.keymap.set("n", "<C-Down>", ":horizontal resize +3<CR>",{silent=true})	-- Control+Right resizes vertical split -
-- easy split navigation
vim.keymap.set("n", "<C-h>", "<C-W>h")	-- control+h switches to left split
vim.keymap.set("n", "<C-l>", "<C-W>l")	-- control+l switches to right split
vim.keymap.set("n", "<C-j>", "<C-W>j")	-- control+j switches to bottom split
vim.keymap.set("n", "<C-k>", "<C-W>k")  -- control+k switches to top split


-- Keymaps for adding certain math symbols
vim.keymap.set("i", "<C-s>dg", "° ")
vim.keymap.set("i", "<C-s>a", "α ")
vim.keymap.set("i", "<C-s>b", "β ")
vim.keymap.set("i", "<C-s>g", "γ ")
vim.keymap.set("i", "<C-s>o", "Ω ")


local insert_text_at_cursor = function(text)

    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local line = cursor_pos[1]-1
    vim.api.nvim_buf_set_lines(0,line,line,false,{text})

end


local get_line_table = function(x,y)
    if(x == nil or y == nil or x<=0 or y<=0) then return nil end

    local line_table = {}

    local table_header = ""
    for _=1,y do
        table_header = table_header .. "|h"
    end
    table_header = table_header .. "|"
    table.insert(line_table,table_header)


    local header_sep = ""
    for _=1,y do
        header_sep = header_sep .. "|-"
    end
    header_sep = header_sep .. "|"
    table.insert(line_table,header_sep)

    local line
    for _=1,x do
        line = ""
        for _=1,y do
            line= line.."|x"
        end
        line= line.. "|"
        table.insert(line_table,line)
    end
    return line_table

end

local table_command = function()
    local input_values = {}
    local user_input = vim.fn.input("Enter rows,cols: ")
    for i in string.gmatch(user_input, "%S+") do
        local number_input = tonumber(i)
        if( number_input  == nil) then vim.api.nvim_err_writeln('Please enter numbers only')
            return
        end
        table.insert(input_values,number_input)
    end

    if(#input_values ~= 2) then
        vim.api.nvim_err_writeln('Enter exactly 2 numbers')
        return
    end
    local line_table = get_line_table(input_values[1],input_values[2])
    if(line_table == nil)  then
        vim.api.nvim_err_writeln('Could not finish table creation')
        return
    end
    for _,line in pairs(line_table) do
        insert_text_at_cursor(line)
    end
end
--Keymap for creating a table of 1+x*y size
vim.keymap.set("i", "<C-s>t",table_command)


--Insert header for a note file
vim.keymap.set("i","<C-s>nh",function ()
    local note_header = {
        "Author     : Samuel Kuta",
        "Subject    : -",
        "Date       :"..os.date("%A - %d.%m.%y"),
        "====================================="
    }
    for _,line in pairs(note_header) do
        insert_text_at_cursor(line)
    end
end)


--Auto completion bindings
-- Bindings can be found in lazy/cmp.lua
