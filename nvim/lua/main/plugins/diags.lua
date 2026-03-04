local M = {}

local map = function(keys, func, desc, mode)
  mode = mode or "n"
  vim.keymap.set(mode, keys, func, { desc = "DIAG: " .. desc })
end

function M.setup_virtual_text()
  vim.diagnostic.config {
    virtual_text = { prefix = "●", source = "if_many" },
    signs = {
      text = {
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.ERROR] = " ",
      },
    },
    severity_sort = true,
  }
end

function M.trouble_keymaps(trouble)
  map("<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)")
  map("<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)")
  map("<leader>cs", "<cmd>Trouble symbols toggle<cr>", "Symbols (Trouble)")
  map("<leader>cS", "<cmd>Trouble lsp toggle<cr>", "LSP references/definitions/... (Trouble)")
  map("<leader>xL", "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)")
  map("<leader>xQ", "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)")
  map("<leader>td", "<cmd>DiagnosticBufferToggle<cr>", "Toggle Buffer [D]iagnostics")

  map("[q", function()
    if trouble.is_open() then
      trouble.prev { skip_groups = true, jump = true }
    else
      local ok, err = pcall(vim.cmd.cprev)
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end
  end, "Next Trouble/Quickfix Item")

  map("]q", function()
    if trouble.is_open() then
      trouble.next { skip_groups = true, jump = true }
    else
      local ok, err = pcall(vim.cmd.cnext)
      if not ok then
        vim.notify(err, vim.log.levels.ERROR)
      end
    end
  end, "Next Trouble/Quickfix Item")
end

function M.builtin_keymaps()
  local diags = vim.diagnostic

  map("[d", function()
    diags.jump { count = -1 }
  end, "Go to previous [D]iagnostic message")
  map("]d", function()
    diags.jump { count = 1 }
  end, "Go to next [D]iagnostic message")

  map("<leader>e", diags.open_float, "Show diagnostic [E]rror messages")
  map("<leader>q", diags.setloclist, "Open diagnostic [Q]uickfix list")
end

function M.setup(trouble)
  M.builtin_keymaps()
  M.setup_virtual_text()

  if trouble == nil then
    return
  end

  trouble.opts = { modes = { lsp = { win = { position = "right" } } } }

  M.trouble_keymaps(trouble)
end

return M
