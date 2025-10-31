-- <ENSURE_INSTALLED>
-- Servers that will be installed and maintained by Mason.nvim
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
    "tailwindcss",
    "omnisharp",

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
            if(server == "jdtls") then
                goto continue
            end

            if(server == "lua_ls") then

                lspconfig[server].setup({
                    capabilities = capabilities,
                    settings = {
                        diagnostics = {
                            globals = {"vim"}
                        },
                    },
                })
                goto continue
            end

            if(server == "omnisharp") then
                lspconfig[server].setup({
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
                    capabilities = capabilities
                })
                goto continue
            end

            -- Default setup
            lspconfig[server].setup({
                capabilities = capabilities,
            })

            ::continue::
        end
        -- </SERVER_SETUP>
    end,
}
