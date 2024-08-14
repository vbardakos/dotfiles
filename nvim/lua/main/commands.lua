vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "nvim make automation",
  group = vim.api.nvim_create_augroup("automake", { clear = true }),
  pattern = { "python" },
  callback = function(opts)
    if opts.match == "python" then
      vim.bo.makeprg = "python"
    elseif opts.match == "rust" then
      local fname = vim.fn.fnamemodify(vim.fn.expand "%:t", ":r")
      -- local dest = vim.fn.expand("%:r").
      -- --manifest-path
      if fname == "main" then
        vim.bo.makerpg = "cargo run"
      else
        vim.bo.makerpg = "cargo test " .. fname
      end
    end
  end,
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
