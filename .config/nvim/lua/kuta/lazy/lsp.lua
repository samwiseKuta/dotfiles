-- <ENSURE_INSTALLED>
-- Servers that will be installed and maintained by Mason
local lsp_servers = {
    "ts_ls",
    "gradle_ls",
    "bashls",
    "cssls",
    "jdtls",
    "jedi_language_server",
    "jsonls",
    "lua_ls",
    "html",
    "volar",
    "tailwindcss",
}
-- </ENSURE_INSTALLED>
return {
    "neovim/nvim-lspconfig",
    --<DEPENDENCIES>
    dependencies = {

        -- Lua Snippets
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",

        --Mason
        {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup()
            end,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            config = function()
                require("mason-lspconfig").setup({
                    ensure_installed = lsp_servers,
                })
            end,
        },
    },
    -- </DEPENDENCIES>
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            cmp_nvim_lsp.default_capabilities()
        )
        vim.diagnostic.config({
            update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        -- <SERVER_SETUP>
        -- All installed servers are setup here using lspconfig.setup
        -- By default all servers are setup with the default lspconfig.setup
        -- If conditions for specific server setups
        for _,server in pairs(lsp_servers) do
            local mason_registry = require('mason-registry')
            local vue_language_server_path = 
            mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'

            if(server == "volar") then
                lspconfig[server].setup{
                    filetypes = {'vue','typescript','javascript','json',}
                }
            end

            if(server == "jdtls") then
                goto continue
            end

            if(server == "lua_ls") then

                lspconfig[server].setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                        },
                    },
                })
                goto continue
            end

            lspconfig[server].setup({
                capabilities = capabilities,
            })

            ::continue::
        end
        -- </SERVER_SETUP>
    end,
}
