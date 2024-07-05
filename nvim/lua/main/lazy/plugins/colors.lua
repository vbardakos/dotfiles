return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  opts = {
    dim_inactive_windows = true,
    styles = {
      bold = true,
      italic = true,
      -- transparency = true,
    },
  },
  init = function()
    local palette = require "rose-pine.palette"

    vim.cmd.colorscheme "rose-pine"
    -- vim.cmd.hi "Comment gui=none"
    local highlight = "#26233a"

    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = palette.muted })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = palette.muted })

    -- deep orange #ff966c
    -- stylua: ignore
    vim.api.nvim_set_hl( 0, "CursorLineNR", { fg = palette.gold, bg = highlight, bold = true })
  end,
}
