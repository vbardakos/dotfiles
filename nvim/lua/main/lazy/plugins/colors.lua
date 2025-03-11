return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  opts = {
    styles = {
      bold = true,
      italic = true,
      transparency = true,
    },
  },
  init = function()
    local palette = require "rose-pine.palette"

    vim.cmd.colorscheme "rose-pine-moon"
    vim.cmd.hi "Comment gui=none"
    local highlight = "#26233a"

    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = palette.muted })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = palette.muted })

    -- deep orange #ff966c
    -- stylua: ignore
    vim.api.nvim_set_hl( 0, "CursorLineNR", { fg = palette.gold, bg = highlight, bold = true })

    local set_virtual_text_hl = function(level, fg)
      local capitalised = level:sub(1, 1):upper() .. level:sub(2):lower()
      local name = "DiagnosticVirtualText" .. capitalised
      vim.api.nvim_set_hl(0, name, { fg = fg, italic = true, blend = 100 })
    end

    -- lsp virtual text override
    set_virtual_text_hl("hint", palette.overlay)
    set_virtual_text_hl("info", palette.highlight_med)
    set_virtual_text_hl("warn", palette.highlight_high)
    set_virtual_text_hl("error", palette.subtle)
  end,
}
