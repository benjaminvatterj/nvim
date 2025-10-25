local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local servers = {
    "lua_ls",
    "pyright",
}

vim.g.lspconfig_servers = servers

-- list of servers configured with default config overrides
local default_servers = {}

local function configure(server, opts)
    local config = vim.tbl_deep_extend("force", {
        on_attach = on_attach,
        on_init = on_init,
        capabilities = capabilities,
    }, opts or {})

    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end

for _, server in ipairs(default_servers) do
    configure(server)
end

configure("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                enable = false, -- Disable all diagnostics from lua_ls
                -- globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                    vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
                    vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
                    -- "${3rd}/love2d/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
        },
    },
})

-- read :h vim.lsp.config for changing options of lsp servers
