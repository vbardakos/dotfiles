require "main.options"
require "main.plugins"

vim.o.winborder = "none"

------------------------------
---------- KEYMAPS -----------
------------------------------

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- vim.keymap.set("n", "<leader>tm", "<CMD>MarkdownPreviewToggle<CR>", { desc = "Toggle [M]arkdown Preview" })

-- vim.keymap.set("n", "<leader>zz", "<cmd>:RootStatement<CR>")
-- vim.keymap.set("n", "<leader>xx", "<cmd>:RootStatement<space>S<CR>")
-- vim.keymap.set("n", "<leader>xx", function()
--   local win = vim.api.nvim_get_current_win()
--   local lineno, column = unpack(vim.api.nvim_win_get_cursor(0))
--   -- vim.cmd "<leader>zz<leader>S"
--   vim.cmd "RootStatement"
--   -- vim.cmd "<leader>S"
--
--   vim.api.nvim_win_set_cursor(win, { lineno, column })
-- end)

------------------------------
--------- COMMANDS -----------
------------------------------

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_user_command("MarkdownPreviewToggle", function()
  local markdown = require "render-markdown"
  local state = require "render-markdown.state"

  if state.enabled then
    markdown.disable()
  else
    markdown.enable()
  end
end, { desc = "toggle markdown preview" })

vim.api.nvim_create_user_command("RootStatement", function()
  local bufno = vim.api.nvim_get_current_buf()
  local lineno, column = unpack(vim.api.nvim_win_get_cursor(0))
  local node = vim.treesitter.get_node {
    bufnr = bufno,
    pos = { lineno - 1, math.max(column - 1, 0) },
    lang = "sql",
  }

  if node == nil then
    print "node is empty"
    return
  end

  local function get_root_statement(tsnode)
    local status, tmp = pcall(function()
      return tsnode:parent()
    end)

    -- depending the lang "program" changes
    if not status or tmp:type() == "program" then
      return tsnode
    end
    return get_root_statement(tmp)
  end

  if node and node ~= "program" then
    node = get_root_statement(node)
  end

  local win = vim.api.nvim_get_current_win()

  print("window" .. win)

  local srow, scol, frow, fcol = node:range(false)
  -- print(srow, scol, frow, fcol)
  vim.api.nvim_win_set_cursor(win, { srow + 1, scol })
  vim.cmd "normal v"
  vim.api.nvim_win_set_cursor(win, { frow + 1, fcol })

  -- local content = {}
  -- if node and node:type() ~= "program" then
  --   local sl, sc, el, ec = get_root_statement(node):range(false)
  --   content = vim.api.nvim_buf_get_text(bufnr, sl, sc, el, ec, {})
  -- end
  --
  -- local result = table.concat(content, "\n")
  -- print(result)
  -- return result
end, { desc = "get root statement" })
