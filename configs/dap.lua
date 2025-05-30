
local dap, dapui = require("dap"), require("dapui")

------------------------------------------------------------------------
-- 1.  Core UI ---------------------------------------------------------
------------------------------------------------------------------------
dapui.setup({
  layouts = {
    -- left: scopes & breakpoints
    { elements = { "scopes", "breakpoints", "watches" }, size = 40, position = "left" },
    -- bottom: REPL & console
    { elements = { "repl", "console" }, size = 10, position = "bottom" },
  },
  floating = { max_height = 0.4 },
})
require("nvim-dap-virtual-text").setup({ commented = true })

------------------------------------------------------------------------
-- 2.  Python adapter --------------------------------------------------
------------------------------------------------------------------------
local py = require("dap-python")
py.setup("python")           -- uses whichever `python` your shell sees
py.test_runner = "pytest"

------------------------------------------------------------------------
-- 3.  Key-maps (match your NvChad style) ------------------------------
------------------------------------------------------------------------
local map = vim.keymap.set
map("n", "<leader>db", dap.toggle_breakpoint,   { desc = "DAP: toggle breakpoint" })
map("n", "<leader>dc", dap.continue,            { desc = "DAP: continue / start" })
map("n", "<leader>di", dap.step_into,           { desc = "DAP: step into" })
map("n", "<leader>do", dap.step_over,           { desc = "DAP: step over" })
map("n", "<leader>dO", dap.step_out,            { desc = "DAP: step out" })
map("n", "<leader>dr", dap.restart,             { desc = "DAP: restart" })
map("n", "<leader>de", dap.terminate,           { desc = "DAP: end session" })
map("n", "<leader>du", dapui.toggle,            { desc = "DAP-UI: toggle" })

------------------------------------------------------------------------
-- 4.  Auto-open / close UI panes --------------------------------------
------------------------------------------------------------------------
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
