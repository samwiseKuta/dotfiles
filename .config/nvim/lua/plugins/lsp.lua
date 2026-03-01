-- ================== SERVER INSTALL AND CONFIG ====================================
-- Servers that will be installed and maintained by Mason.nvim
-- The keys are the names of the language servers supported by mason, 
-- and the values are config tables, for default config use empty table
local lsp_servers = {
    ts_ls ={},
    gradle_ls ={},
    bashls={},
    cssls ={},
    jdtls ={},
    jedi_language_server ={},
    jsonls ={},
    lua_ls ={
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" }}}}
    },
    html ={},
    tailwindcss ={},
    omnisharp ={},
    lemminx = {}
}


local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities() or {}
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


for server,config in pairs(lsp_servers) do
    config.capabilities =  capabilities

    if(next(config) ~= nil) then
        vim.lsp.config(server,config)
    end
    vim.lsp.enable(server)
end


return {
    "neovim/nvim-lspconfig",
    dependencies = {
        --Mason
        {
            "williamboman/mason.nvim",
            config = function()
                require("mason").setup({
                    ensure_installed = lsp_servers
                })
            end,
        },
    },
}
