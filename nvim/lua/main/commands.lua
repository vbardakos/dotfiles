vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local make_augroup = vim.api.nvim_create_augroup("automake", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  desc = "Python make automation",
  group = make_augroup,
  pattern = { "python" },
  callback = function (_)
    local current_file = vim.fn.expand('%:p')  -- Full path of the current file
    local relative_path = current_file:sub(#vim.fn.getcwd() + 2)
    local filename_without_extension = vim.fn.fnamemodify(relative_path, ':r')  -- Remove file extension
    local relative_dest = filename_without_extension:gsub('/', '.')

    if vim.env.VIRTUAL_ENV ~= nil then
      vim.bo.makeprg = "python -m"
    else
      vim.bo.makeprg = "uv run -m"
    end

    vim.keymap.set("n", "<leader>r", "<CMD>silent make " .. relative_dest .. "<CR>", { desc = "[M]ake Python", silent = true })
  end
})

vim.api.nvim_create_user_command("DiagnosticToggle", function()
  local config = vim.diagnostic.config
  local vt = config().virtual_text
  config {
    virtual_text = not vt,
    underline = not vt,
    signs = not vt,
  }
end, { desc = "toggle diagnostic" })

vim.api.nvim_create_user_command("DiagnosticBufferToggle", function()
  local status = vim.diagnostic.is_enabled { bufnr = 0 }
  vim.diagnostic.enable(not status, { bufnr = 0 })
end, { desc = "toggle buffer diagnostic" })

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
  local bufnr = vim.api.nvim_get_current_buf()
  local lineno, column = unpack(vim.api.nvim_win_get_cursor(0))
  local node = vim.treesitter.get_node {
    bufnr = bufnr,
    pos = { lineno - 1, math.max(column - 1, 0) },
    lang = "sql",
  }

  local function get_root_statement(node)
    local status, tmp = pcall(function()
      return node:parent()
    end)

    if not status or tmp:type() == "program" then
      return node
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

vim.keymap.set("n", "<leader>zz", "<cmd>:RootStatement<CR>")
-- vim.keymap.set("n", "<leader>xx", "<cmd>:RootStatement<space>S<CR>")
vim.keymap.set("n", "<leader>xx", function()
  local win = vim.api.nvim_get_current_win()
  local lineno, column = unpack(vim.api.nvim_win_get_cursor(0))
  -- vim.cmd "<leader>zz<leader>S"
  vim.cmd "RootStatement"
  -- vim.cmd "<leader>S"

  vim.api.nvim_win_set_cursor(win, { lineno, column })
end)
