local nvchad_lsp = require("nvchad.configs.lspconfig")
local on_attach = nvchad_lsp.on_attach
local on_init = nvchad_lsp.on_init
local capabilities = nvchad_lsp.capabilities

local servers = {
    pyright = {},
    lua_ls = {
        settings = {
            Lua = {
                diagnostics = {
                    enable = false,
                },
                workspace = {
                    library = {
                        vim.fn.expand("$VIMRUNTIME/lua"),
                        vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                        vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                        vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    },
                    maxPreload = 100000,
                    preloadFileSize = 10000,
                },
            },
        },
    },
}

local function with_shared_opts(config)
    return vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    }, config or {})
end

if vim.lsp and vim.lsp.config then
    for server, config in pairs(servers) do
        local merged = with_shared_opts(config)

        if vim.lsp.config[server] then
            merged = vim.tbl_deep_extend("force", vim.lsp.config[server], merged)
        end

        vim.lsp.config(server, merged)

        if vim.lsp.enable then
            vim.lsp.enable(server)
        end
    end
else
    local lspconfig = require("lspconfig")

    for server, config in pairs(servers) do
        lspconfig[server].setup(with_shared_opts(config))
    end
end

-- read :h vim.lsp.config for changing options of lsp servers
return {
    servers = servers,
}
