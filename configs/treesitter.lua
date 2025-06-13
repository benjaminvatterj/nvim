local options = {
    ensure_installed = {
        "bash",
        "fish",
        "lua",
        "luadoc",
        "markdown",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
        "python",
    },

    highlight = {
        enable = true,
        use_languagetree = true,
    },

    indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
