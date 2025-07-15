require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<Esc>", { desc = "an extra way of exiting insert" })
map("i", "<Esc>", "<Esc>", { noremap = true, silent = true, desc = "exit insert" })

-- Normal mode
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "move line down" })
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "move line up" })

-- Visual mode – keep the selection highlighted while moving
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "move block down" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "move block up" })
-- map({ "n", "i", "v" }, "<C-s>

-- map("n", "<leader>ca", function()
-- 	require("tiny-code-action").code_action()
-- end, { noremap = true, silent = true, desc = "Code Action" })
---------------------------------------------------------------------------
--  Restore real Delete key in Insert mode
---------------------------------------------------------------------------

-- 2. Re-map Delete to “delete char under cursor”
-- vim.keymap.set("i", "<Del>", "<C-o>x",
  -- { noremap = true, silent = true, desc = "Delete character right" })


-- -- F12  → jump to *definition* (or declaration – see note below)
-- map("n", "<F12>", function()
--     -- choose one of the two lines; comment-out the other
--     vim.lsp.buf.definition() -- VS Code “Go to Definition”
--     -- vim.lsp.buf.declaration()  -- if you really want “Go to Declaration”
-- end, { desc = "LSP: go to definition" })
--
-- Shift + F12  → list *references* (usages) in a Telescope picker
-- map("n", "<S-F12>", function()
--     require("telescope.builtin").lsp_references({
--         fname_width = 60,
--         show_line = true,
--     })
--     --  alternative Trouble view (uncomment if you prefer):
--     -- require("trouble").toggle("lsp_references")
-- end, { desc = "LSP: list references" })

-- Snacks.nvim
map("n", "<leader>gb", function()
  require("snacks.git").blame_line()
end, { desc = "Git blame current line" })

map("n", "<leader>tt", function()
  require("snacks.terminal").toggle()
end, { desc = "Toggle terminal" })

map("n", "<leader>ti", function()
  require("snacks.toggle").indent()
end, { desc = "Toggle indent guides" })

-- Jump between LSP references when Snacks.words is enabled
-- map("n", "]]", function() require("snacks.words").jump(1) end, { desc = "Next reference" })
-- map("n", "[[", function() require("snacks.words").jump(-1) end, { desc = "Prev reference" })
