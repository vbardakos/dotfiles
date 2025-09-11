return { -- Autoformat
  "stevearc/conform.nvim",
  lazy = true, -- remove for changes
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format { async = true, lsp_fallback = true, timeout_ms = 3000 }
      end,
      mode = { "n", "v" },
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. Add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true, ["yaml.ansible"] = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters_by_ft = {
      python = {
        "ruff_fix",
        "ruff_format",
        "ruff_organize_imports",
      },
      lua = { "stylua" },
      yaml = { "yamlfmt" },
      sh = { "shfmt" },
      zsh = { "shfmt" },
      rust = { "rustfmt", lsp_format = "fallback" },
    },
  },
}
