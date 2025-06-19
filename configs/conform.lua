local options = {
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        -- css = { "prettier" },
        -- html = { "prettier" },
    },
    formatters = {
        -- Python
        black = {
            prepend_args = {
                "--fast",
                "--line-length",
                "88",
                "-",
            },
        },
        isort = {
            prepend_args = {
                "--profile",
                "black",
            },
        },
        stylua = {
            prepend_args = { "--indent-width", "4", "--indent-type", "Spaces" },
        },
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 2000,
        lsp_fallback = true,
    },
}

require("conform").setup(options)

-- lua/configs/conform.lua
local conform = require "conform"

-- Create :ConformFormat (no args) to format the current buffer
vim.api.nvim_create_user_command("ConformFormat", function()
    conform.format {
        async = false,
        timeout_ms = 3000, -- timeout for formatting
        lsp_fallback = true, -- if no formatter, fall back to LSP
    }
end, { desc = "Format buffer with Conform" })
return options
