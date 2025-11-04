local mason_lsp = require("mason-lspconfig")
local custom_lsp = require("configs.lspconfig")

-- List of servers to ignore during install
local ignore_install = {}

-- Helper function to find if value is in table.
local function table_contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Build a list of lsp servers to install minus the ignored list.
local all_servers = {}
for _, server_name in ipairs(vim.tbl_keys(custom_lsp.servers or {})) do
    if not table_contains(ignore_install, server_name) then
        table.insert(all_servers, server_name)
    end
end

table.sort(all_servers)

mason_lsp.setup({
    ensure_installed = all_servers,
    automatic_installation = false,
    automatic_enable = false,
})
