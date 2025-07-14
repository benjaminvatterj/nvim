return {
    {
        "folke/which-key.nvim",
        keys = { "<leader>", "<c-w>", '"', "'", "`", "c", "v", "g" },
        cmd = "WhichKey",
        opts = function(_, opts)
            dofile(vim.g.base46_cache .. "whichkey")
            opts.on_close = function()
                vim.cmd("redraw!")
            end
            opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
                winblend = 0, -- 0 = fully opaque, no terminal redraw glitch
                zindex = 50, -- keep it above most other floats
            })
            return {}
        end,
    },
    -----------------------------------------------------------------
    -- nvim-tree: auto-open when Neovim starts with no file,
    --            auto-quit if it’s the last window
    -----------------------------------------------------------------
    -----------------------------------------------------------------
    -- nvim-tree: auto-open on empty start, auto-quit when last win
    -----------------------------------------------------------------
    {
        -- "nvim-tree/nvim-tree.lua",
        -- lazy = false, -- ← override NvChad’s lazy setting
        -- opts = function(_, opts)
        --     opts.actions = opts.actions or {}
        --     opts.actions.open_file =
        --         vim.tbl_deep_extend("force", opts.actions.open_file or {}, { quit_on_open = false })
        --     return opts
        -- end,

        -- config = function(_, opts)
        --     require("nvim-tree").setup(opts)
        --     local api = require("nvim-tree.api")
        --
        --     ----------------------------------------------------------------
        --     -- 1.  Open the tree at startup *only* if no file is given
        --     ----------------------------------------------------------------
        --     vim.api.nvim_create_autocmd("VimEnter", {
        --         once = true,
        --         callback = function()
        --             if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" then
        --                 vim.schedule(function()
        --                     api.tree.open({ focus = false })
        --                 end)
        --             end
        --         end,
        --     })
        --
        --     ----------------------------------------------------------------
        --     -- 2.  Quit Neovim when nvim-tree is the only window left
        --     ----------------------------------------------------------------
        --     vim.api.nvim_create_autocmd("BufEnter", {
        --         pattern = "NvimTree_*",
        --         nested = true,
        --         callback = function()
        --             if #vim.api.nvim_list_wins() == 1 then
        --                 vim.cmd("quit")
        --             end
        --         end,
        --     })
        -- end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("nvchad.configs.lspconfig").defaults()
            require("configs.lspconfig")
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("configs.mason-lspconfig")
        end,
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.lint")
        end,
    },

    {
        "rshkarin/mason-nvim-lint",
        event = "VeryLazy",
        dependencies = { "nvim-lint" },
        config = function()
            require("configs.mason-lint")
        end,
    },

    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("configs.conform")
        end,
    },

    {
        "zapling/mason-conform.nvim",
        event = "VeryLazy",
        dependencies = { "conform.nvim" },
        config = function()
            require("configs.mason-conform")
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            local cmp = require("cmp")

            ----------------------------------------------------------------
            -- 1 KEYS — leave as you had them
            ----------------------------------------------------------------
            opts.mapping["<CR>"] = cmp.mapping(function(fb)
                fb()
            end, { "i", "s" })
            opts.mapping["<C-y>"] = cmp.mapping.confirm({ select = true })
            opts.mapping["<C-l>"] = nil -- Copilot keeps this

            ----------------------------------------------------------------
            -- 2 DISABLE snippet expansion completely
            ----------------------------------------------------------------
            opts.snippet = { expand = function() end }

            ----------------------------------------------------------------
            -- 3 ONLY keep LSP + path sources (drop buffer, luasnip, copilot)
            ----------------------------------------------------------------
            opts.sources = {
                { name = "nvim_lsp", group_index = 1 }, -- methods, vars, etc.
                { name = "path", group_index = 2 }, -- ./foo/bar.py
            }

            ----------------------------------------------------------------
            -- 4 Make the popup a bit calmer
            ----------------------------------------------------------------
            opts.completion = { keyword_length = 3 } -- start after 3 chars
            opts.view = { entries = { name = "custom", max_item_count = 8 } }
            opts.window = {
                completion = cmp.config.window.bordered({ max_height = 8 }),
                documentation = cmp.config.window.bordered(),
            }

            ----------------------------------------------------------------
            -- 5 TURN OFF cmp’s ghost-text so it doesn’t clash with Copilot
            ----------------------------------------------------------------
            opts.experimental = { ghost_text = false }
        end,
    },

    -----------------------------------------------------------------
    -- Copilot core
    -----------------------------------------------------------------
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        build = ":Copilot auth",
        config = function()
            require("copilot").setup({
                panel = { enabled = false },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<C-l>", -- ← only Copilot uses this key now
                        next = "<C-]>", -- cycle forward
                        prev = "<C-[>", -- cycle back
                        dismiss = "<C-h>",
                    },
                },
            })

            -- Ensure Copilot suggestions use a subtle color distinct from comments
            local function set_copilot_hl()
                vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#6c7086", italic = true })
            end
            set_copilot_hl()

            -- reapply highlight after colorscheme changes
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = set_copilot_hl,
            })

            -- Toggle (<leader>ct) still handy
            vim.keymap.set("n", "<leader>ct", function()
                if vim.b.copilot_enabled == false then
                    vim.cmd("Copilot enable")
                    vim.notify("Copilot ▶ on")
                else
                    vim.cmd("Copilot disable")
                    vim.notify("Copilot ⏸ off")
                end
            end, { desc = "Toggle Copilot" })
        end,
    },

    {
        "kdheepak/lazygit.nvim",
        cmd = "LazyGit",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = { -- optional mapping
            { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit (float)" },
        },
    },

    -- lua/plugins/init.lua  (inside your return { ... })
    {
        "folke/trouble.nvim",
        opts = { use_diagnostic_signs = true },
        keys = {
            -- 1.  Workspace diagnostics  (same as the old "workspace_diagnostics")
            {
                "<leader>xX",
                function()
                    require("trouble").toggle("diagnostics")
                end,
                desc = "Diagnostics (workspace)",
            },

            -- 2.  Current-file diagnostics  (buffer-local filter)
            {
                "<leader>xx",
                function()
                    require("trouble").toggle("diagnostics", { filter = { buf = 0 } })
                end,
                desc = "Diagnostics (buffer)",
            },

            -- 3.  Quick jump next/prev (optional)
            {
                "[d",
                function()
                    require("trouble").next({ skip_groups = true, jump = true })
                end,
                desc = "Next diagnostic",
            },
            {
                "]d",
                function()
                    require("trouble").prev({ skip_groups = true, jump = true })
                end,
                desc = "Prev diagnostic",
            },
        },
    },

    {
        "stevearc/aerial.nvim",
        opts = {
            backends = { "lsp", "treesitter" },
            layout = {
                default_direction = "right", -- always open on the right
                width = 30,
            },

            filter_kind = { -- omit variables, constants, etc.
                "Class",
                "Function",
                "Method",
                "Interface",
                "Struct",
                "Type", -- covers type aliases / declarations in many servers
                "Module", -- keep if you want top-level modules/packages
            },

            -- nice optional touches
            show_guides = true,
            highlight_on_jump = 300, -- ms
        },
        cmd = "AerialToggle",
        keys = {
            { "<F2>", "<cmd>AerialToggle<CR>", desc = "Outline (Aerial)" },
        },
    },
    --------------------------------------------------------------
    --- Re-open file from its last location
    --------------------------------------------------------------
    {
        "ethanholz/nvim-lastplace",
        event = "BufReadPost", -- loads only when a file is read
        opts = {
            lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
            lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
            lastplace_open_folds = true, -- reopen folded code around the cursor
        },
    },

    -----------------------------------------------------------------
    --- Show context header for current function/class
    --------------------------------------------------------------------

    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            enable = true,
            max_lines = 0, -- how many context lines to keep
            trim_scope = "outer", -- remove far-away scopes first
            multiline_threshold = 20, -- collapse huge blocks
            mode = "cursor", -- update on cursor move
            separator = "-", -- you can set "─" etc.
            -- patterns = { -- only show these kinds
            --     default = { "class", "function", "method" },
            --     python = { "class", "function", "method" },
            -- },
        },
        -- keys = {
        --     { "<leader>tc", "<Cmd>TSContextToggle<CR>", desc = "Toggle context header" },
        -- },
    },

    -- -- ── DAP STACK ───────────────────────────────────────────────────────────────
    -- {
    --     "mfussenegger/nvim-dap",
    --     dependencies = {
    --         "mfussenegger/nvim-dap-python",
    --         "rcarriga/nvim-dap-ui",
    --         "theHamsta/nvim-dap-virtual-text",
    --         "nvim-neotest/nvim-nio"
    --     },
    --     config = function()
    --         require("configs.dap")
    --     end,
    --     -- load lazily so normal editing stays snappy
    --     ft = { "python" },
    -- },
    --
    -----------------------------------------------------------------
    --- Tiny code actions
    --- This plugin provides a simple way to trigger code actions
    --- and view them in a picker.
    -------------------------------------------------------------------
    -- {
    --     "rachartier/tiny-code-action.nvim",
    --     dependencies = {
    --         { "nvim-lua/plenary.nvim" },
    --
    --         -- optional picker via telescope
    --         { "nvim-telescope/telescope.nvim" },
    --         -- optional picker via fzf-lua
    --         { "ibhagwan/fzf-lua" },
    --         -- .. or via snacks
    --         {
    --             "folke/snacks.nvim",
    --             opts = {
    --                 terminal = {},
    --             },
    --         },
    --     },
    --     event = "LspAttach",
    --     opts = {},
    -- },
    -----------------------------------------------------------------
    -- Copilot as a cmp source (no extra cmp.setup!)
    -----------------------------------------------------------------
    -- {
    --     "zbirenbaum/copilot-cmp",
    --     event = "InsertEnter",
    --     dependencies = { "zbirenbaum/copilot.lua" },
    --     config = true, -- default config is fine
    -- },
}
