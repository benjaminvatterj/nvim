local M = {}

-- Snacks configuration for NvChad
-- Only enable the modules that are useful for this setup.

-- Git helper utilities
-- - `<leader>gb` opens a floating window showing `git blame` information for the
--   current line.
M.git = {
    enabled = true,
}

-- Indent guides and scope lines. Useful for Python's indentation based blocks.
-- Toggle on/off with `<leader>ti` (see `mappings.lua`).
M.indent = {
    enabled = true,
}

-- Toggleable floating/split terminal.
-- Mapped to `<leader>tt` for quick access.
M.terminal = {
    enabled = true,
}

-- Highlight LSP references and jump between them.
-- Disabled by default. Uncomment the keymaps in `mappings.lua` to use.
M.words = {
    enabled = false,
}

-- Disable the rest of Snacks features to keep the setup minimal.
-- bigfile    : skips heavy plugins for huge files
M.bigfile = { enabled = false }
-- dashboard  : show a start screen when launching Neovim.
-- Example layout with multiple panes from the Snacks README.
M.dashboard = {
    enabled = true,
}
-- explorer   : minimal file explorer
M.explorer = { enabled = false }
-- input      : nicer vim.ui.input prompts
M.input = { enabled = false }
-- picker     : fuzzy item picker
M.picker = { enabled = false }
-- notifier   : better vim.notify UI
M.notifier = { enabled = false }
-- quickfile  : speed up startup when opening a file directly
M.quickfile = { enabled = false }
-- scope      : textobject-based scope jumping
M.scope = { enabled = false }
-- scroll     : smooth scrolling animations
M.scroll = { enabled = false }
-- statuscolumn: custom status column
M.statuscolumn = { enabled = false }
-- toggle     : create user toggles integrated with which-key
M.toggle = { enabled = false }
-- gitbrowse  : open files or commits on GitHub
M.gitbrowse = { enabled = false }
-- layout     : window layout utilities
M.layout = { enabled = false }
-- lazygit    : open lazygit in a float
M.lazygit = { enabled = false }
-- rename     : rename files with LSP integration
M.rename = { enabled = false }
-- scratch    : simple scratch buffers
M.scratch = { enabled = false }
-- profiler   : profile lua code
M.profiler = { enabled = false }
-- dim        : dim inactive windows
M.dim = { enabled = false }
-- image      : preview images using kitty graphics
M.image = { enabled = false }
-- win        : window helpers for floats/splits
M.win = { enabled = false }
-- zen        : distraction-free coding mode
M.zen = { enabled = false }

return M
