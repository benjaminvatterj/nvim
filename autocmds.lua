require("nvchad.autocmds")

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = [[:%s/\s\+$//e]],
})
