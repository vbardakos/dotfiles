local M = {}

M.ensure_installed = {
  "stylua",
}

local _ = {
  logLevel = "debug",
  codeAction = {
    fixViolation = { enable = true },
  },
  lint = {
    preview = true,
  },
  format = {
    preview = true,
  },
}

-- note :: will be added in ensure_installed
M.servers = {
  rust_analyzer = {},
  -- https://docs.astral.sh/ruff/editors/settings
  ruff = {
    init_options = {
      settings = {
        configuration = vim.fn.stdpath "config" .. "/ruff.toml",
        configurationPreference = "filesystemFirst",
        lint = { enable = true, preview = true },
        format = { enable = true, preview = true, backend = "uv" },
        organizeImports = true,
        showSyntaxErrors = true,
        codeAction = {
          disableRuleComment = { enable = true },
          fixViolation = { enable = true },
        },
      },
      -- settings = {
      --   logLevel = "debug",
      --   codeAction = {
      --     fixViolation = { enable = true },
      --   },
      --   lint = {
      --     preview = true,
      --     -- select = { "ALL" },
      --     extendSelect = {
      --       "F",
      --       "E",
      --       "W",
      --       "C",
      --       "I",
      --       "N",
      --       "D",
      --       "U",
      --       "ASYNC",
      --       "S",
      --       "B",
      --       "A",
      --       "C4",
      --       "DTZ",
      --       "EM",
      --       "EXE",
      --       "FA",
      --       "ICN",
      --       "LOG",
      --       "G",
      --       "INP",
      --       "PIE",
      --       "PYI",
      --       "PT",
      --       "Q",
      --       "RET",
      --       "SIM",
      --       "TID",
      --       "TC",
      --       "ARG",
      --       "PTH",
      --       "FIX",
      --       "ERA",
      --       "PD",
      --       "PGH",
      --       "PL",
      --       "TRY",
      --       "NPY",
      --       "FAST",
      --       "AIR",
      --       "PERF",
      --       "FURB",
      --       "RUF",
      --     },
      --     ignore = { "D1" },
      --   },
      --   format = {
      --     preview = true,
      --   },
      -- },
    },
  },
  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          diagnosticMode = "openFilesOnly",
          typeCheckingMode = "off",
          -- ignore = { "*" },
          -- exclude = { "*" },
          inlayHints = {
            variableTypes = true,
            callArgumentNames = true,
            functionReturnTypes = true,
            genericTypes = true,
          },
        },
      },
    },
  },
  marksman = {},
  lua_ls = {
    filetypes = { "lua" },
    cmd = { "lua-language-server" },
    root_markers = { ".luarc.json", ".git" },
    -- settings = {
    --   Lua = {
    --     runtime = { version = "LuaJIT" },
    --     workspace = { library = vim.api.nvim_get_runtime_file("", true) },
    --     telemetry = { enable = false },
    --     diagnostics = {
    --       globals = {
    --         "vim",
    --         "require",
    --       },
    --     },
    --     format = {
    --       enable = true,
    --       defaultConfig = {
    --         indent_style = "space",
    --         indent_size = "2",
    --         quote_style = "double",
    --         max_lines_length = 120,
    --         space_after_comment_dash = "true",
    --         call_arg_parentheses = "remove",
    --       },
    --     },
    --   },
    -- },
  },
  -- gopls = {},
  -- bashls = {},
  -- yamlls = {
  --   completion = true,
  --   schemas = {
  --     kubernetes = "*.yaml",
  --     ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
  --     ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
  --     ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
  --     ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
  --     ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
  --     ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
  --     ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
  --     ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
  --     ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
  --     ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
  --     ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
  --     ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
  --   },
  -- },
}

M.capabilities = vim.lsp.protocol.make_client_capabilities()
function M.add_capabilities(caps)
  if caps ~= nil then
    vim.tbl_deep_extend("force", M.capabilities, caps)
  end
end

M.extra_keymaps = {}
function M.set_extra_keymaps(...)
  for _, fn in ipairs { ... } do
    M.extra_keymaps[#M.extra_keymaps + 1] = fn
  end
end

function M.native_keymaps(buf)
  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = buf, desc = "LSP: " .. desc })
  end

  map("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd")
  map("<leader>wr", vim.lsp.buf.add_workspace_folder, "[W]orkspace [R]emove")
  map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "v" })
  map("K", vim.lsp.buf.hover, "Hover Documentation")
  map("<leader>k", vim.lsp.buf.signature_help, "Hover Documentation")
  map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

  map("<leader>cl", function()
    vim.lsp.codelens.refresh { bufnr = 0 }
  end, "[C]ode[L]ens refresh")
  map("<leader>th", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, "[T]oggle inlay [H]int")
  map("<leader>tc", function()
    vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled())
  end, "[T]oggle inline [C]ompletion")
end

function M.attach()
  vim.lsp.protocol.make_client_capabilities()
  vim.api.nvim_create_autocmd("LspAttach", {
    -- group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),  -- original
    group = vim.api.nvim_create_augroup("lsp-attach", {}),
    callback = function(event)
      M.native_keymaps(event.buf)

      for _, fn in ipairs(M.extra_keymaps) do
        fn(event.buf)
      end

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })
end

function M.setup()
  vim.pack.add {
    "https://github.com/j-hui/fidget.nvim",
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-tool-installer.nvim",
    "https://github.com/williamboman/mason-lspconfig.nvim",
  }

  require("mason").setup {}
  M.attach()

  local ensure_installed = vim.tbl_keys(M.servers)
  vim.list_extend(ensure_installed, M.ensure_installed)
  require("mason-tool-installer").setup {
    ensure_installed = ensure_installed,
  }

  for name, cfg in pairs(M.servers) do
    cfg.capabilities = vim.tbl_deep_extend("force", {}, M.capabilities, cfg.capabilities or {})
    vim.lsp.config[name] = cfg
  end

  vim.lsp.enable(ensure_installed)
end

return M
