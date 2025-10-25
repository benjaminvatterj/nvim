local nvchad_lsp = require "nvchad.configs.lspconfig"

local M = {}

local servers = {
    "lua_ls",
    "pyright",
}

vim.g.lspconfig_servers = servers

local function configure(server, opts)
    local config = vim.tbl_deep_extend("force", {
        on_attach = nvchad_lsp.on_attach,
        on_init = nvchad_lsp.on_init,
        capabilities = nvchad_lsp.capabilities,
    }, opts or {})

    vim.lsp.config(server, config)
    vim.lsp.enable(server)
end

function M.setup()
    nvchad_lsp.defaults()

    configure("lua_ls", {
        settings = {
            Lua = {
                diagnostics = {
                    enable = false, -- Disable all diagnostics from lua_ls
                    -- globals = { "vim" },
                },
                format = {
                    enable = false, -- Use conform.nvim for formatting instead of lua_ls
                },
                telemetry = { enable = false },
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
end

return M

-- read :h vim.lsp.config for changing options of lsp servers
