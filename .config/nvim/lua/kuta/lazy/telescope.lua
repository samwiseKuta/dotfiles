return {

        --Telescope
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "plenary"
        },

    config = function()
        require('telescope').setup({})
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>kf', builtin.find_files, {})
        vim.keymap.set('n','<C-f>',builtin.git_files,{})
        vim.keymap.set('n','<leader>ks',function()
            builtin.grep_string({search = vim.fn.input("Grep > ")});
        end)
    end
}
