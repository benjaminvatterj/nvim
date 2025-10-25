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

    if vim.lsp and vim.lsp.config then
        vim.lsp.config("stylua", { autostart = false })
    end

    local get_clients = vim.lsp.get_clients
    if not get_clients and vim.lsp.get_active_clients then
        get_clients = function(opts)
            local clients = vim.lsp.get_active_clients()
            if not opts or not opts.name then
                return clients
            end

            local filtered = {}
            for _, client in ipairs(clients) do
                if client.name == opts.name then
                    table.insert(filtered, client)
                end
            end

            return filtered
        end
    end

    for _, client in ipairs(get_clients and get_clients { name = "stylua" } or {}) do
        client.stop(true)
    end

    local group = vim.api.nvim_create_augroup("DisableStyluaLsp", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "stylua" then
                vim.schedule(function()
                    client.stop(true)
                end)
            end
        end,
    })

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
