local CmdLoad = {}

CmdLoad._once_lookup = {}
function CmdLoad.set_build_once(pkg_name, ...)
  CmdLoad._once_lookup[pkg_name] = { ... }
end

-------------------------------
------- HEADING PLUGINS -------
-------------------------------

vim.pack.add {
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
}

-------------------------------
---- COLORSCHEMES & GROUPS ----
-------------------------------

local COLORS = "horizon-dark"

vim.pack.add {
  "https://github.com/wincent/base16-nvim",
  "https://github.com/tribela/transparent.nvim", -- transparent background
}

vim.cmd.colorscheme(COLORS)
require("transparent").setup {}
vim.g.tinted_colorspace = 256

local marked = vim.api.nvim_get_hl(0, { name = "PMenu" })
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
  fg = marked.fg,
  bg = marked.bg,
  ctermfg = marked.ctermfg,
  ctermbg = marked.ctermbg,
  bold = true,
})

-- treesitter-context plugin
vim.api.nvim_set_hl(0, "TreesitterContext", { link = "LineNr", default = true })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { link = "LineNr", default = true })
vim.api.nvim_set_hl(0, "TreesitterContextBottom", { link = "NONE", default = true })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { link = "TreesitterContextBottom", default = true })
vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { link = "FloatBorder", default = true })

-- remove background from which-key
vim.api.nvim_set_hl(0, "WhichKeyNormal", { link = "NONE", default = true })

-- fix diagnostic colors
local set_diagnostics_hl = function(name, ref)
  local refc = vim.api.nvim_get_hl(0, { name = ref })
  if next(refc) == nil then
    refc = { fg = ref }
  end
  -- virtual text :: enabled @ diags
  vim.api.nvim_set_hl(0, "DiagnosticVirtualText" .. name, { fg = refc.fg, italic = true, blend = 100 })
  -- floating window text
  vim.api.nvim_set_hl(0, "DiagnosticFloating" .. name, { fg = refc.fg, italic = true, blend = 100 })
end

set_diagnostics_hl("Ok", "Normal")
set_diagnostics_hl("Hint", "Comment")
set_diagnostics_hl("Info", "Comment")
set_diagnostics_hl("Warn", "Boolean")
set_diagnostics_hl("Error", "darkred")

------------------------------
--------- TELESCOPE ----------
------------------------------

vim.pack.add {
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-ui-select.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
}

local telescope = require "telescope"
telescope.setup {
  ["ui-select"] = require("telescope.themes").get_dropdown(),
}

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")

-- See `:help telescope.builtin`
local builtin = require "telescope.builtin"
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })

-- telescope keybinds for lsp attach
local lsp_callback = function(buf)
  local map = function(key, fn, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, key, fn, { buffer = buf, desc = "LSP: " .. desc })
  end

  map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
  map("gr", builtin.lsp_references, "[G]oto [R]eferences")
  map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
  map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
  map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
  map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
end

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = "[/] Fuzzily search in current buffer" })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set("n", "<leader>s/", function()
  builtin.live_grep {
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  }
end, { desc = "[S]earch [/] in Open Files" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>sn", function()
  builtin.find_files { cwd = vim.fn.stdpath "config" }
end, { desc = "[S]earch [N]eovim files" })

------------------------------
-------- TREESITTER ----------
------------------------------

vim.pack.add {
  "https://github.com/nvim-treesitter/nvim-treesitter",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  -- "https://github.com/nvim-treesitter/playground",  -- optional
}

local treesitter = require "nvim-treesitter"

treesitter.setup { install_dir = vim.fn.stdpath "data" .. "/site" }
treesitter.update()

treesitter.install {
  "bash",
  "html",
  "lua",
  "luadoc",
  "markdown",
  "vim",
  "vimdoc",
  "python",
  "rust",
  "sql",
}

vim.g.no_plugin_maps = true -- avoids builtin conflicts
require("nvim-treesitter-textobjects").setup {
  select = {
    lookahead = true,
    selection_modes = {
      ["@parameter.outer"] = "v", -- charwise
      ["@function.outer"] = "V", -- linewise
      -- ['@class.outer'] = '<c-v>', -- blockwise
    },
    include_surrounding_whitespace = false,
  },
}

-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ "x", "o" }, "am", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "im", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
  require("nvim-treesitter-textobjects.select").select_textobject("@local.scope", "locals")
end)

require("treesitter-context").setup {
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  multiwindow = false, -- Enable multiwindow support.
  max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = false,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: "inner", "outer"
  mode = "cursor", -- Line used to calculate context. Choices: "cursor", "topline"
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = "━", -- Separator between context and content. Should be a single character string, like "-".
  zindex = 20, -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

-------------------------------
--------- COMPLETION ----------
-------------------------------

vim.pack.add { "https://github.com/hrsh7th/nvim-cmp" }
local cmp = require "main.plugins.cmp"
-- cmp.setup_mini()
cmp.setup(require "cmp")

-------------------------------
------------- LSP -------------
-------------------------------

local lsp = require "main.plugins.lsp"
lsp.set_extra_keymaps(lsp_callback)
lsp.add_capabilities(cmp.capabilities())
lsp.setup()

-- vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
--   callback = function()
--     vim.lsp.codelens.enable()
--   end,
-- })

-------------------------------
--------- DIAGNOSTICS ---------
-------------------------------

vim.pack.add { "https://github.com/folke/trouble.nvim" }

require("main.plugins.diags").setup(require "trouble")

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

-------------------------------
---------- FORMATING ----------
-------------------------------

require "main.plugins.conform"

-------------------------------
--------- NAVIGATION ----------
-------------------------------

vim.pack.add {
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/christoomey/vim-tmux-navigator",
}

require("main.plugins.oil").setup(require "oil")

-- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- hotfix :: cannot navigate through panes while in oil
vim.api.nvim_create_autocmd("FileType", {
  desc = "enable tmux navigation in oil",
  group = vim.api.nvim_create_augroup("OilTmuxNavigation", { clear = true }),
  pattern = { "oil" },
  callback = function()
    vim.schedule(function()
      vim.keymap.set("n", "<C-h>", "<CMD>TmuxNavigateLeft<CR>", { buffer = true })
      vim.keymap.set("n", "<C-j>", "<CMD>TmuxNavigateDown<CR>", { buffer = true })
      vim.keymap.set("n", "<C-k>", "<CMD>TmuxNavigateUp<CR>", { buffer = true })
      vim.keymap.set("n", "<C-l>", "<CMD>TmuxNavigateRight<CR>", { buffer = true })
    end)
  end,
})

------------------------------
--------- STATUSLINE ---------
------------------------------

------------------------------
-------- VERSION CTRL --------
------------------------------

vim.pack.add {
  "https://github.com/lewis6991/gitsigns.nvim",
  -- "https://github.com/tpope/vim-fugitive",
  -- "https://github.com/tpope/vim-rhubarb",
}

require("gitsigns").setup {
  signs_staged_enable = true,
  signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  on_attach = function(bufno)
    local gitsigns = require "gitsigns"

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufno
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal { "]c", bang = true }
      else
        gitsigns.nav_hunk "next"
      end
    end, { desc = "next hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal { "[c", bang = true }
      else
        gitsigns.nav_hunk "prev"
      end
    end, { desc = "prev hunk" })

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage hunk" })
    map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "reset hunk" })

    map("v", "<leader>hs", function()
      gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, { desc = "stage hunk" })

    map("v", "<leader>hr", function()
      gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, { desc = "reset hunk" })

    map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "stage buf" })
    map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "reset buf" })
    map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "preview hunk" })
    map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "preview inline" })

    map("n", "<leader>hb", function()
      gitsigns.blame_line { full = true }
    end, { desc = "blame line" })

    map("n", "<leader>hd", gitsigns.diffthis, { desc = "diff this" })

    map("n", "<leader>hD", function()
      gitsigns.diffthis "~"
    end, { desc = "diff ~" })

    map("n", "<leader>hQ", function()
      gitsigns.setqflist "all"
    end, { desc = "" })
    map("n", "<leader>hq", gitsigns.setqflist, { desc = "" })

    -- Toggles
    map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "toggle blame" })
    map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "toggle word diff" })

    -- Text object
    map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "select hunk" })
  end,
}

------------------------------
---------- UTILITIES ---------
------------------------------

vim.pack.add {
  "https://github.com/tpope/vim-sleuth",
  -- "https://github.com/lukas-reineke/indent-blankline.nvim", -- require "ibl".setup()
}

vim.pack.add { "https://github.com/folke/which-key.nvim" }

local wk = require "which-key"
wk.add {
  { "<leader>c", group = "[C]ode" },
  { "<Tab>", group = "[H]arpoon" },
  { "<leader>d", group = "[D]ocument" },
  { "<leader>r", group = "[R]ename" },
  { "<leader>s", group = "[S]earch" },
  { "<leader>w", group = "[W]orkspace" },
}

vim.pack.add { "https://github.com/folke/todo-comments.nvim" }

local comments = require "todo-comments"

vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "[S]earch [T]odo List" })

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

local ok, mini_pairs = pcall(require, "mini.pairs")

if not ok then
  vim.pack.add { "https://github.com/nvim-mini/mini.pairs" }
  mini_pairs = require "mini.pairs"
end

mini_pairs.setup {}

vim.pack.add {
  "https://github.com/selimacerbas/live-server.nvim",
  "https://github.com/selimacerbas/markdown-preview.nvim",
}

vim.keymap.set("n", "<leader>mps", "<cmd>MarkdownPreview<cr>", { desc = "Markdown: Start preview" })
vim.keymap.set("n", "<leader>mpS", "<cmd>MarkdownPreviewStop<cr>", { desc = "Markdown: Stop preview" })
vim.keymap.set("n", "<leader>mpr", "<cmd>MarkdownPreviewRefresh<cr>", { desc = "Markdown: Refresh preview" })
