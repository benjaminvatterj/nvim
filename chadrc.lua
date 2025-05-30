-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
    theme = "catppuccin",

    hl_override = {
        -- lighter grey-blue taken from Catppuccin “overlay2” (#a6adc8)
        Comment = { fg = "#a6adc8", italic = true },
        ["@comment"] = { fg = "#a6adc8", italic = true }, -- Treesitter alias
    },
}

-- M.nvdash = { load_on_startup = true }
-- M.ui = {
--       tabufline = {
--          lazyload = false
--      }
--}

return M
