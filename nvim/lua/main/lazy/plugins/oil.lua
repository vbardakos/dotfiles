return {
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup {
      default_file_explorer = true,
      columns = { "icon" }, -- "size" => filesize
      win_options = { signcolumn = "yes" },
      -- Configuration for the floating window in oil.open_float
      float = {
        open_by_default = true,
        -- Padding around the floating window
        padding = 2,
        -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        max_width = 0.7,
        max_height = 0.8,
        border = "rounded",
        win_options = {
          signcolumn = "yes",
        },
        preview_split = "auto",
      },
      view_options = {
        is_hidden_file = function(name, _)
          -- Table-based lookup for exact matches
          local exact_matches = {
            [".svn"] = true,
            [".hg"] = true,
            ["_darcs"] = true,
            [".idea"] = true,
            [".vscode"] = true,
            ["__pycache__"] = true,
            [".cache"] = true,
            ["node_modules"] = true,
            ["dist"] = true,
            ["build"] = true,
            [".pytest_cache"] = true,
            [".DS_Store"] = true,
            ["Thumbs.db"] = true,
          }

          -- Patterns for names with extensions
          local patterns = {
            "%.git.*",
            "%.pyc$", -- Matches ".pyc" names
            "%.pyo$", -- Matches ".pyo" names
            "%.venv$", -- Matches ".venv/" directories
          }

          -- Check for exact match
          if exact_matches[name] then
            return true
          end

          -- Check patterns
          for _, pattern in ipairs(patterns) do
            if name:match(pattern) then
              return true
            end
          end

          return false
        end,
        is_always_hidden = function(name, _)
          return name == ".."
        end,
      },
    }
    vim.keymap.set("n", "<leader>o", "<CMD>Oil --float<CR>", { desc = "[O]il File Explorer" })

    vim.api.nvim_create_autocmd("FileType", {
      desc = "enable tmux navigation in oil",
      group = vim.api.nvim_create_augroup("OilTmuxNavigation", { clear = true }),
      pattern = { "oil" },
      callback = function()
        vim.schedule(function()
          vim.keymap.set("n", "<C-h>", "<CMD>TmuxNavigateLeft<cr>", { buffer = true })
          vim.keymap.set("n", "<C-j>", "<CMD>TmuxNavigateDown<cr>", { buffer = true })
          vim.keymap.set("n", "<C-k>", "<CMD>TmuxNavigateUp<cr>", { buffer = true })
          vim.keymap.set("n", "<C-l>", "<CMD>TmuxNavigateRight<cr>", { buffer = true })
        end)
      end,
    })
  end,
}
