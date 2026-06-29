local M = {}

M.mini = false
function M.setup_mini()
  local ok, mini = pcall(require, "mini.snippets")
  if not ok then
    vim.pack.add { "https://github.com/echasnovski/mini.snippets" }
    mini = require "mini.snippets"
  end
  vim.pack.add {
    "https://github.com/abeldekat/cmp-mini-snippets",
  }

  mini.setup {
    snippets = {
      -- Load custom file with global snippets first
      mini.gen_loader.from_file "~/.config/nvim/snippets/global.json",
      mini.gen_loader.from_lang(),
    },
  }

  M.mini = true
end

function M.capabilities()
  return require("cmp_nvim_lsp").default_capabilities()
end

function M.setup(cmp)
  vim.pack.add {
    "https://github.com/hrsh7th/cmp-nvim-lsp",
    "https://github.com/hrsh7th/cmp-buffer",
    "https://github.com/hrsh7th/cmp-path",
    "https://github.com/hrsh7th/cmp-emoji",

    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/saadparwaiz1/cmp_luasnip",

    "https://github.com/onsails/lspkind.nvim",
    "https://github.com/kristijanhusak/vim-dadbod-completion", -- SQL
  }

  local snippet_expand = function(args)
    require("luasnip").lsp_expand(args.body)

    if M.mini then
      local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
      insert { body = args.body }
      cmp.resubscribe { "TextChangedI", "TextChangedP" }
      require("cmp.config").set_onetime { sources = {} }
    end
  end

  cmp.setup {
    snippet = { expand = snippet_expand },
    formatting = { format = require("lspkind").cmp_format() },
    -- window = {
    --   completion = cmp.config.window.bordered(),
    --   documentation = cmp.config.window.bordered(),
    -- },
    completion = { completeopt = "menu,menuone,noinsert" },
    mapping = cmp.mapping.preset.insert {
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-y>"] = cmp.mapping.confirm { select = true },

      -- Think of <c-l> as moving to the right of your snippet expansion.
      --  So if you have a snippet that's like:
      --  function $name($args)
      --    $body
      --  end
      --
      -- <c-l> will move you to the right of each of the expansion locations.
      -- <c-h> is similar, except moving you backwards.
      --[[
			["<C-l>"] = cmp.mapping(function()
			if luasnip.expand_or_locally_jumpable() then
			luasnip.expand_or_jump()
			end
			end, { "i", "s" }),
			["<C-h>"] = cmp.mapping(function()
			if luasnip.locally_jumpable(-1) then
			luasnip.jump(-1)
			end
			end, { "i", "s" }),
			--]]
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
      { name = "emoji" },
    }, { { name = "buffer" } }),
    experimental = { ghost_text = true },
  }

  cmp.setup.filetype({ "sql" }, {
    sources = {
      { name = "vim-dadbod-completion" },
      { name = "buffer" },
    },
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  -- cmp.setup.cmdline(':', {
  -- mapping = cmp.mapping.preset.cmdline(),
  -- sources = cmp.config.sources({
  -- { name = 'path' }
  -- }, {
  -- { name = 'cmdline' }
  -- }),
  -- matching = { disallow_symbol_nonprefix_matching = false }
  -- })
end

return M
