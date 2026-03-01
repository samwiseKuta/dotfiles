return {
    --Telescope
    "nvim-telescope/telescope.nvim",
    lazy=false,
    dependencies = { 'nvim-lua/plenary.nvim'},
    config = function()
        require('telescope').setup({})
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>kf', builtin.find_files, {desc="Telescope fuzzy file search"})
        vim.keymap.set('n','<C-f>',builtin.git_files,{})
        vim.keymap.set('n','<leader>rf',builtin.lsp_references,{desc="Telescope lsp references"})
        vim.keymap.set('n','<leader>kls',builtin.live_grep,{})
        vim.keymap.set('n','<leader>gs',function()
            builtin.grep_string({search = vim.fn.input("Grep -> ")});
        end)
    end
}
