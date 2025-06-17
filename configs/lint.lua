local lint = require("lint")

lint.linters_by_ft = {
    lua = { "luacheck" },
    -- haskell = { "hlint" },
    python = { "flake8" },
}

lint.linters.luacheck.args = {
    "--globals",
    "love",
    "vim",
    "--formatter",
    "plain",
    "--codes",
    "--ranges",
    "-",
}

lint.linters.flake8.args = {
    "--ignore=E203",
    "--format=%(path)s:%(row)d:%(col)d:%(code)s:%(text)s",
    "--max-line-length=88",
    "--no-show-source",
    "--stdin-display-name",
    function()
        return vim.api.nvim_buf_get_name(0)
    end,
    "-",
    -- "--ignore=E501,W503,E203",
    -- "79",
    -- "--format=%(path)s:%(row)d:%(col)d: %(code)s %(text)s",
    -- "-",
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})
