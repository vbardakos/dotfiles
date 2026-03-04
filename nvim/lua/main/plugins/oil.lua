local M = {}

-- NOTE :: bypass hidden patterns w/ false
M.hide_files = {
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
  [".ruff_cache"] = true,
  [".git"] = true,
}

M.hide_patterns = {
  "%.pyc$", -- Matches ".pyc" names
  "%.pyo$", -- Matches ".pyo" names
  "%.venv$", -- Matches ".venv/" directories
}

function M.is_hidden(name, _)
  local hide = M.hide_files[name]
  if hide ~= nil then
    return hide
  end

  for _, ptn in ipairs(M.hide_patterns) do
    if name:match(ptn) then
      return true
    end
  end

  return false
end

function M.setup(oil)
  oil.setup {
    columns = { "icon" }, -- "size" => filesize
    win_options = { signcolumn = "yes" },
    view_options = {
      is_hidden_file = M.is_hidden,
      is_always_hidden = function(name, _)
        return name == ".."
      end,
    },
    confirmation = { win_options = { winblend = 10 } },
  }

  vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "[O]il File Explorer" })
end

return M
