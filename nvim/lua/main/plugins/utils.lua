local M = {}

function M.setup_todo_comments()
  vim.pack.add { "https://github.com/folke/todo-comments.nvim" }

  local comments = require "todo-comments"

  comments.setup {
    signs = false,
    keywords = {
      FIX = {
        icon = " ",
        color = "error",
        alt = { "BUG", "HOTFIX", "ISSUE", "fix" },
      },
      TODO = { icon = " ", color = "info", alt = { "todo", "check" } },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "warn" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", "perf", "opt" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO", "info", "note", "hotfix" } },
      TEST = {
        icon = "⏲ ",
        color = "test",
        alt = { "TESTING", "PASSED", "FAILED", "passed", "failed" },
      },
    },
    -- stylua: ignore start
    highlight = {
      multiline = true,                -- enable multine todo comments
      multiline_pattern = "^.",        -- lua pattern to match the next multiline from the start of the matched keyword
      multiline_context = 10,          -- extra lines that will be re-evaluated when changing a line
      before = "",                     -- "fg" or "bg" or empty
      keyword = "fg",                  -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
      after = "fg",                    -- "fg" or "bg" or empty
      pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
      comments_only = true,            -- uses treesitter to match keywords in comments only
      max_line_len = 400,              -- ignore lines longer than this
      exclude = {},                    -- list of file types to exclude highlighting
    },
    -- stylua: ignore end
  }

  local ok, _ = pcall(require, "telescope")
  if ok then
    vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "[S]earch [T]odo List" })
  end
end

function M.setup_mini_pairs()
  local ok
  -- ok, _ = pcall(require, "treesitter-textobjects")
  -- if not ok then
  --   vim.pack.add { { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" } }
  -- end

  ok, pairs = pcall(require, "mini.pairs")
  if not ok then
    vim.pack.add { "https://github.com/nvim-mini/mini.pairs" }
    pairs = require "mini.pairs"
  end
  -- ok, surround = pcall(require, "mini.surround")
  -- if not ok then
  --   vim.pack.add { "https://github.com/
end

return M
