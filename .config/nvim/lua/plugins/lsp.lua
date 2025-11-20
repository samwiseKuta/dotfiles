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
    omnisharp ={
        cmd = { "dotnet", vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp.dll"},

        settings = {
            FormattingOptions = {
                -- Enables support for reading code style, naming convention and analyzer
                -- settings from .editorconfig.
                EnableEditorConfigSupport = true,
                -- Specifies whether 'using' directives should be grouped and sorted during
                -- document formatting.
                OrganizeImports = nil,
            },
            MsBuild = {
                -- If true, MSBuild project system will only load projects for files that
                -- were opened in the editor. This setting is useful for big C# codebases
                -- and allows for faster initialization of code navigation features only
                -- for projects that are relevant to code that is being edited. With this
                -- setting enabled OmniSharp may load fewer projects and may thus display
                -- incomplete reference lists for symbols.
                LoadProjectsOnDemand = nil,
            },
            RoslynExtensionsOptions = {
                -- Enables support for roslyn analyzers, code fixes and rulesets.
                EnableAnalyzersSupport = nil,
                -- Enables support for showing unimported types and unimported extension
                -- methods in completion lists. When committed, the appropriate using
                -- directive will be added at the top of the current file. This option can
                -- have a negative impact on initial completion responsiveness,
                -- particularly for the first few completion sessions after opening a
                -- solution.
                EnableImportCompletion = nil,
                -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
                -- true
                AnalyzeOpenDocumentsOnly = nil,
            },
            Sdk = {
                -- Specifies whether to include preview versions of the .NET SDK when
                -- determining which version to use for project loading.
                IncludePrereleases = true,
            },
        },
    }
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
