-- note :: add me if builtin doesn't work

vim.pack.add { "https://github.com/stevearc/conform.nvim" }

local conform = require "conform"
conform.setup {
  notify_on_error = false,
  format_on_save = function(bufno)
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufno].filetype] then
      return
    end
    return {
      timeout_ms = 500,
      lsp_format = "fallback",
    }
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    yaml = { "yamlfmt" },
    sh = { "shfmt" },
    zsh = { "shfmt" },
  },
}

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format { async = true, lsp_format = "fallback", timeout_ms = 3000 }
end)
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
