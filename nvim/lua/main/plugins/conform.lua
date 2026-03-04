-- note :: add me if builtin doesn't work

vim.pack.add { "https://github.com/stevearc/conform.nvim" }

local conform = require "conform"
conform.setup {
  opts = {
    notify_on_error = false,
    format_on_save = function(bufno)
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufno].filetype],
      }
    end,
    formatters_by_ft = {
      lua = { "stylua" },
      yaml = { "yamlfmt" },
      sh = { "shfmt" },
      zsh = { "shfmt" },
    },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(_)
    vim.lsp.buf.format {}
    -- conform.format { bufnr = args.buf }
  end,
})

vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format { async = true, lsp_fallback = true, timeout_ms = 3000 }
end)
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
