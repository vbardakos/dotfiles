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
  map("<leader>ct", builtin.lsp_type_definitions, "[C]ode: [T]ype Definition")
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

vim.pack.add { "https://github.com/smjonas/inc-rename.nvim" }
require("inc_rename").setup {}

vim.pack.add { "https://github.com/folke/lazydev.nvim" }
require("lazydev").setup {
  library = {
    -- Load luv types when `vim.uv` is referenced
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
}

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
------------ DEBUG -----------
-------------------------------

vim.pack.add {
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/theHamsta/nvim-dap-virtual-text",
  "https://github.com/nvim-neotest/nvim-nio", -- dap-ui dep
  "https://github.com/mfussenegger/nvim-dap-python",
}

local dap = require "dap"
local dapui = require "dapui"
dapui.setup()
require("nvim-dap-virtual-text").setup {}

-- auto open/close dap-ui on debug session lifecycle
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- Rust / C / C++ adapter via codelldb (installed by mason)
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.exepath "codelldb",
    args = { "--port", "${port}" },
  },
}

dap.configurations.rust = {
  {
    name = "Launch",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
}

-- Python: prefer debugpy from a discoverable virtualenv, else fall back to system python
local function debugpy_python()
  local cwd = vim.fn.getcwd()
  for _, p in ipairs { cwd .. "/.venv/bin/python", cwd .. "/venv/bin/python" } do
    if vim.fn.executable(p) == 1 then
      return p
    end
  end
  return "python3"
end
require("dap-python").setup(debugpy_python())

local dap_breakpoint_condition = function()
  vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
    if cond and cond ~= "" then
      dap.set_breakpoint(cond)
    end
  end)
end

local dap_log_point = function()
  vim.ui.input({ prompt = "Log point message: " }, function(msg)
    if msg and msg ~= "" then
      dap.set_breakpoint(nil, nil, msg)
    end
  end)
end

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: toggle [B]reakpoint" })
vim.keymap.set("n", "<leader>dB", dap_breakpoint_condition, { desc = "DAP: conditional [B]reakpoint" })
vim.keymap.set("n", "<leader>dl", dap_log_point, { desc = "DAP: [L]og point" })
vim.keymap.set("n", "<leader>dC", function()
  dap.clear_breakpoints()
end, { desc = "DAP: [C]lear all breakpoints" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: [C]ontinue / start" })
vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: continue / start" })
vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "DAP: terminate" })
vim.keymap.set("n", "<leader>dr", dap.run_last, { desc = "DAP: [R]un last" })
vim.keymap.set("n", "<leader>dR", dap.repl.open, { desc = "DAP: open [R]EPL" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "DAP: step [O]ver" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: step [I]nto" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "DAP: step [O]ut" })
vim.keymap.set("n", "<leader>dh", function()
  require("dap.ui.widgets").hover()
end, { desc = "DAP: [H]over value" })
vim.keymap.set({ "n", "v" }, "<leader>de", function()
  require("dapui").eval()
end, { desc = "DAP: [E]val under cursor / selection" })
vim.keymap.set("n", "<leader>du", function()
  dapui.toggle {}
end, { desc = "DAP: toggle [U]I" })

-- python-specific
vim.keymap.set("n", "<leader>dn", function()
  require("dap-python").test_method()
end, { desc = "DAP: debug [N]earest test (python)" })
vim.keymap.set("n", "<leader>df", function()
  require("dap-python").test_class()
end, { desc = "DAP: debug test class/[F]ile (python)" })
vim.keymap.set("v", "<leader>dv", function()
  require("dap-python").debug_selection()
end, { desc = "DAP: debug [V]isual selection (python)" })

-------------------------------
------------- RUST ------------
-------------------------------

vim.pack.add { "https://github.com/mrcjkb/rustaceanvim" }
vim.g.rustaceanvim = {
  server = {
    capabilities = require("main.plugins.lsp").capabilities,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
        procMacro = { enable = true },
      },
    },
  },
  -- DAP picks up the codelldb adapter we set above in the DEBUG section.
}

vim.api.nvim_create_autocmd("FileType", {
  desc = "rustaceanvim keymaps in .rs",
  group = vim.api.nvim_create_augroup("RustaceanKeymaps", { clear = true }),
  pattern = "rust",
  callback = function(ev)
    local map = function(key, cmd, desc)
      vim.keymap.set("n", key, cmd, { buffer = ev.buf, desc = "Rust: " .. desc })
    end
    map("<leader>cr", "<cmd>RustLsp runnables<cr>", "[R]unnables picker")
    map("<leader>cb", "<cmd>RustLsp debuggables<cr>", "de[B]uggables picker")
    map("<leader>ce", "<cmd>RustLsp expandMacro<cr>", "[E]xpand macro")
    map("<leader>cp", "<cmd>RustLsp parentModule<cr>", "[P]arent module")
    map("<leader>cx", "<cmd>RustLsp explainError<cr>", "e[X]plain error")
  end,
})

-------------------------------
----------- TESTING -----------
-------------------------------

vim.pack.add {
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/nvim-neotest/neotest-python",
  "https://github.com/rouge8/neotest-rust",
}

local neotest = require "neotest"
neotest.setup {
  adapters = {
    require "neotest-python" {
      dap = { justMyCode = false },
      runner = "pytest",
    },
    require "neotest-rust" {
      args = { "--no-capture" },
      dap_adapter = "codelldb",
    },
  },
  quickfix = { enabled = false },
  status = { virtual_text = true },
  output = { open_on_run = false },
}

vim.keymap.set("n", "<leader>tt", function()
  neotest.run.run()
end, { desc = "Test: run nearest" })
vim.keymap.set("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand "%")
end, { desc = "Test: run [F]ile" })
vim.keymap.set("n", "<leader>tT", function()
  neotest.run.run(vim.loop.cwd())
end, { desc = "Test: run all in cwd" })
vim.keymap.set("n", "<leader>tl", function()
  neotest.run.run_last()
end, { desc = "Test: run [L]ast" })
vim.keymap.set("n", "<leader>tD", function()
  neotest.run.run { strategy = "dap" }
end, { desc = "Test: [D]ebug nearest" })
vim.keymap.set("n", "<leader>tW", function()
  neotest.watch.toggle(vim.fn.expand "%")
end, { desc = "Test: toggle [W]atch file" })
vim.keymap.set("n", "<leader>ts", function()
  neotest.summary.toggle()
end, { desc = "Test: toggle [S]ummary" })
vim.keymap.set("n", "<leader>to", function()
  neotest.output.open { enter = true, auto_close = true }
end, { desc = "Test: show [O]utput float" })
vim.keymap.set("n", "<leader>tO", function()
  neotest.output_panel.toggle()
end, { desc = "Test: toggle [O]utput panel" })
vim.keymap.set("n", "<leader>tS", function()
  neotest.run.stop()
end, { desc = "Test: [S]top" })
vim.keymap.set("n", "<leader>tn", function()
  neotest.jump.next { status = "failed" }
end, { desc = "Test: jump [N]ext failed" })
vim.keymap.set("n", "<leader>tp", function()
  neotest.jump.prev { status = "failed" }
end, { desc = "Test: jump [P]rev failed" })

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
  "https://github.com/kevinhwang91/nvim-bqf",
  -- "https://github.com/lukas-reineke/indent-blankline.nvim", -- require "ibl".setup()
}

require("bqf").setup {
  preview = { auto_preview = true, win_height = 12, win_vheight = 12 },
  func_map = { vsplit = "v", ptogglemode = "z,", stoggleup = "" },
}

vim.pack.add { "https://github.com/saecki/crates.nvim" }
require("crates").setup {
  -- LSP mode: completion/hover/code-actions are served through the standard
  -- LSP machinery, so they ride your existing nvim_lsp cmp source and `K`/`<leader>ca`.
  lsp = { enabled = true, actions = true, completion = true, hover = true },
}

vim.api.nvim_create_autocmd("BufRead", {
  desc = "crates.nvim keymaps in Cargo.toml",
  group = vim.api.nvim_create_augroup("CratesKeymaps", { clear = true }),
  pattern = "Cargo.toml",
  callback = function(ev)
    local crates = require "crates"
    local map = function(key, fn, desc)
      vim.keymap.set("n", key, fn, { buffer = ev.buf, desc = "Crates: " .. desc })
    end
    map("<leader>cv", crates.show_versions_popup, "[V]ersions popup")
    map("<leader>cf", crates.show_features_popup, "[F]eatures popup")
    map("<leader>cd", crates.show_dependencies_popup, "[D]ependencies popup")
    map("<leader>cu", crates.update_all_crates, "[U]pdate all (semver)")
    map("<leader>cU", crates.upgrade_all_crates, "[U]pgrade all (across majors)")
    map("<leader>co", crates.open_homepage, "[O]pen homepage")
    map("<leader>cR", crates.open_crates_io, "open crates.io")
    map("<leader>cD", crates.open_documentation, "open docs.rs")
  end,
})

vim.pack.add { "https://github.com/folke/flash.nvim" }
require("flash").setup {
  modes = {
    char = { enabled = true }, -- label-augments f/F/t/T (multi-line targets)
    search = { enabled = true }, -- label-augments `/` and `?` (jump-to-match)
  },
}

-- s/S/treesitter are intentionally unbound: mini.surround owns `s`.
-- Remote-operator works in operator-pending mode only, so it doesn't
-- shadow normal-mode `r` (replace single char).
vim.keymap.set("o", "r", function()
  require("flash").remote()
end, { desc = "Flash: remote target (e.g. yr<jump>)" })

vim.pack.add { "https://github.com/MagicDuck/grug-far.nvim" }
local grug_far = require "grug-far"
grug_far.setup {
  headerMaxWidth = 80,
}

vim.keymap.set("n", "<leader>sx", function()
  grug_far.open()
end, { desc = "[S]earch & replace (grug-far)" })
vim.keymap.set("v", "<leader>sx", function()
  grug_far.with_visual_selection()
end, { desc = "[S]earch & replace within selection" })

vim.pack.add { "https://github.com/folke/persistence.nvim" }
local persistence = require "persistence"
persistence.setup {
  options = vim.opt.sessionoptions:get(),
}

vim.keymap.set("n", "<leader>ps", function()
  persistence.select()
end, { desc = "Session: [S]elect" })
vim.keymap.set("n", "<leader>pl", function()
  persistence.load()
end, { desc = "Session: [L]oad cwd session" })
vim.keymap.set("n", "<leader>pr", function()
  persistence.load { last = true }
end, { desc = "Session: [R]estore last" })
vim.keymap.set("n", "<leader>pn", function()
  persistence.stop()
end, { desc = "Session: do[N]'t save this exit" })

vim.pack.add { { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" } }
local harpoon = require "harpoon"
harpoon:setup()

vim.keymap.set("n", "<Tab>a", function()
  harpoon:list():add()
end, { desc = "[H]arpoon [A]dd file" })
vim.keymap.set("n", "<Tab>m", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "[H]arpoon toggle [M]enu" })
vim.keymap.set("n", "<Tab>n", function()
  harpoon:list():next()
end, { desc = "[H]arpoon [N]ext" })
vim.keymap.set("n", "<Tab>p", function()
  harpoon:list():prev()
end, { desc = "[H]arpoon [P]rev" })
vim.keymap.set("n", "<Tab>c", function()
  harpoon:list():clear()
end, { desc = "[H]arpoon [C]lear list" })
for i = 1, 5 do
  vim.keymap.set("n", "<Tab>" .. i, function()
    harpoon:list():select(i)
  end, { desc = "[H]arpoon slot " .. i })
end

vim.pack.add {
  "https://github.com/tpope/vim-dadbod",
  "https://github.com/kristijanhusak/vim-dadbod-ui",
}

vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_show_database_icon = 1
vim.g.db_ui_win_position = "left"
vim.g.db_ui_winwidth = 40
-- per-cwd notebook so SQL drafts live with the project
vim.g.db_ui_save_location = vim.fn.stdpath "data" .. "/db_ui"
vim.g.db_ui_use_nvim_notify = 0
vim.g.db_ui_auto_execute_table_helpers = 1

vim.api.nvim_create_autocmd("FileType", {
  desc = "cmp: dadbod completion source in SQL/MySQL/PLSQL buffers",
  group = vim.api.nvim_create_augroup("DadbodCmp", { clear = true }),
  pattern = { "sql", "mysql", "plsql" },
  callback = function()
    require("cmp").setup.buffer { sources = { { name = "vim-dadbod-completion" }, { name = "buffer" } } }
  end,
})

vim.keymap.set("n", "<leader>Du", "<cmd>DBUIToggle<cr>", { desc = "DB: toggle DBUI sidebar" })
vim.keymap.set("n", "<leader>Da", "<cmd>DBUIAddConnection<cr>", { desc = "DB: [A]dd connection" })
vim.keymap.set("n", "<leader>Df", "<cmd>DBUIFindBuffer<cr>", { desc = "DB: [F]ind current buffer" })
vim.keymap.set("n", "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", { desc = "DB: [R]ename SQL buffer" })

vim.pack.add { "https://github.com/danymat/neogen" }
local neogen = require "neogen"
neogen.setup {
  enabled = true,
  snippet_engine = "luasnip",
  languages = {
    python = { template = { annotation_convention = "google_docstrings" } },
    rust = { template = { annotation_convention = "rustdoc" } },
    lua = { template = { annotation_convention = "ldoc" } },
  },
}

vim.keymap.set("n", "<leader>nf", function()
  neogen.generate { type = "func" }
end, { desc = "Neogen: [F]unction docstring" })
vim.keymap.set("n", "<leader>nc", function()
  neogen.generate { type = "class" }
end, { desc = "Neogen: [C]lass docstring" })
vim.keymap.set("n", "<leader>nt", function()
  neogen.generate { type = "type" }
end, { desc = "Neogen: [T]ype docstring" })
vim.keymap.set("n", "<leader>nF", function()
  neogen.generate { type = "file" }
end, { desc = "Neogen: [F]ile-level docstring" })

vim.pack.add { "https://github.com/folke/which-key.nvim" }

local wk = require "which-key"
wk.add {
  { "<leader>a", group = "[A]I (claudecode)" },
  { "<leader>b", group = "[B]uffer" },
  { "<leader>bd", desc = "delete buffer (keep window)" },
  { "<leader>bD", desc = "force-delete buffer" },
  { "<leader>ac", desc = "toggle Claude Code terminal" },
  { "<leader>af", desc = "focus Claude Code" },
  { "<leader>as", desc = "send selection to Claude Code", mode = "v" },
  { "<leader>aa", desc = "accept proposed diff" },
  { "<leader>ad", desc = "deny proposed diff" },
  { "<leader>c", group = "[C]ode" },
  { "<Tab>", group = "[H]arpoon" },
  { "<leader>n", group = "[N]eogen (docstrings)" },
  { "<leader>nf", desc = "function docstring" },
  { "<leader>nc", desc = "class docstring" },
  { "<leader>nt", desc = "type docstring" },
  { "<leader>nF", desc = "file docstring" },
  { "<leader>l", group = "[L]LM (codecompanion)" },
  { "<leader>la", desc = "actions menu", mode = { "n", "v" } },
  { "<leader>lc", desc = "toggle chat", mode = { "n", "v" } },
  { "<leader>ld", desc = "add selection to chat", mode = "v" },
  { "<leader>li", desc = "inline transform", mode = { "n", "v" } },
  { "<leader>lp", desc = "prompt-then-inline", mode = { "n", "v" } },
  { "s", group = "[S]urround", mode = { "n", "v" } },
  { "sa", desc = "add surrounding", mode = { "n", "v" } },
  { "sd", desc = "delete surrounding" },
  { "sr", desc = "replace surrounding" },
  { "sf", desc = "find surrounding (right)" },
  { "sF", desc = "find surrounding (left)" },
  { "sh", desc = "highlight surrounding" },
  { "sn", desc = "update n_lines" },
  { "<leader>D", group = "[D]atabase (dadbod)" },
  { "<leader>Du", desc = "toggle DBUI sidebar" },
  { "<leader>Da", desc = "add connection" },
  { "<leader>Df", desc = "find current buffer" },
  { "<leader>Dr", desc = "rename SQL buffer" },
  { "<leader>d", group = "[D]ebug" }, -- also holds <leader>ds (doc symbols)
  { "<leader>db", desc = "toggle breakpoint" },
  { "<leader>dB", desc = "conditional breakpoint" },
  { "<leader>dl", desc = "log point" },
  { "<leader>dC", desc = "clear all breakpoints" },
  { "<leader>dc", desc = "continue / start" },
  { "<leader>dx", desc = "terminate" },
  { "<leader>dr", desc = "run last" },
  { "<leader>dR", desc = "open REPL" },
  { "<leader>do", desc = "step over" },
  { "<leader>di", desc = "step into" },
  { "<leader>dO", desc = "step out" },
  { "<leader>dh", desc = "hover value" },
  { "<leader>de", desc = "eval (n/v)" },
  { "<leader>du", desc = "toggle dap-ui" },
  { "<leader>dn", desc = "debug nearest test (py)" },
  { "<leader>df", desc = "debug test file/class (py)" },
  { "<leader>dv", desc = "debug visual selection (py)", mode = "v" },
  { "<leader>p", group = "[P]ersistence" },
  { "<leader>ps", desc = "select session" },
  { "<leader>pl", desc = "load cwd session" },
  { "<leader>pr", desc = "restore last session" },
  { "<leader>pn", desc = "don't save this exit" },
  { "<leader>r", group = "[R]ename" },
  { "<leader>s", group = "[S]earch" },
  { "<leader>sx", desc = "search & replace (grug-far)", mode = { "n", "v" } },
  { "<leader>t", group = "[T]oggle / [T]est" }, -- shared: toggles (tb,tw,td,th,tc) + neotest
  { "<leader>tt", desc = "run nearest test" },
  { "<leader>tf", desc = "run test file" },
  { "<leader>tT", desc = "run all tests (cwd)" },
  { "<leader>tl", desc = "run last test" },
  { "<leader>tD", desc = "debug nearest test" },
  { "<leader>tW", desc = "toggle watch file" },
  { "<leader>ts", desc = "toggle test summary" },
  { "<leader>to", desc = "test output float" },
  { "<leader>tO", desc = "toggle output panel" },
  { "<leader>tS", desc = "stop running test" },
  { "<leader>tn", desc = "next failed test" },
  { "<leader>tp", desc = "prev failed test" },
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

local mini_bufremove = require "mini.bufremove"
mini_bufremove.setup {}

vim.keymap.set("n", "<leader>bd", function()
  mini_bufremove.delete(0, false)
end, { desc = "[B]uffer [D]elete (keep window)" })
vim.keymap.set("n", "<leader>bD", function()
  mini_bufremove.delete(0, true)
end, { desc = "[B]uffer force-[D]elete" })

-- mini.surround + mini.ai: ship inside mini.nvim (already in the pack list)
local mini_ai = require "mini.ai"
mini_ai.setup {
  custom_textobjects = {
    -- function arg (a/i) — improved arg detection over default `a`
    -- everything else uses mini.ai's built-in matchers for brackets, quotes, tags, etc.
  },
  n_lines = 500,
}

local mini_surround = require "mini.surround"
local ts_input = mini_surround.gen_spec.input.treesitter
mini_surround.setup {
  mappings = {
    add = "sa",
    delete = "sd",
    find = "sf",
    find_left = "sF",
    highlight = "sh",
    replace = "sr",
    update_n_lines = "sn",
    suffix_last = "l",
    suffix_next = "n",
  },
  n_lines = 100,
  search_method = "cover_or_next",
  custom_surroundings = {
    -- treesitter-aware "input" specs: only matter for sd/sr/sf/sF/sh,
    -- not sa (add doesn't need a parse). Captures come from
    -- nvim-treesitter-textobjects' textobjects.scm.
    f = { input = ts_input { outer = "@call.outer", inner = "@call.inner" } },
    o = { input = ts_input { outer = "@function.outer", inner = "@function.inner" } },
    c = { input = ts_input { outer = "@class.outer", inner = "@class.inner" } },
    a = { input = ts_input { outer = "@parameter.outer", inner = "@parameter.inner" } },
  },
}

vim.pack.add {
  "https://github.com/selimacerbas/live-server.nvim",
  "https://github.com/selimacerbas/markdown-preview.nvim",
}

-------------------------------
------------- AI -------------
-------------------------------

vim.pack.add { "https://github.com/olimorris/codecompanion.nvim" }
require("codecompanion").setup {
  adapters = {
    acp = {
      claude_code = function()
        return require("codecompanion.adapters").extend("claude_code", {
          env = {
            -- Pro/Max users: run `claude setup-token`, then export the result
            -- as CLAUDE_CODE_OAUTH_TOKEN in your shell rc. Falls back to
            -- ANTHROPIC_API_KEY if the OAuth token is unset.
            CLAUDE_CODE_OAUTH_TOKEN = "CLAUDE_CODE_OAUTH_TOKEN",
          },
        })
      end,
    },
  },
  strategies = {
    chat = { adapter = "claude_code" },
    inline = { adapter = "claude_code" },
    agent = { adapter = "claude_code" },
  },
  display = {
    chat = {
      window = {
        layout = "vertical",
        width = 0.4,
      },
    },
  },
}

-- codecompanion lives under <leader>l (LLM) so claudecode.nvim can own <leader>a*
vim.keymap.set({ "n", "v" }, "<leader>la", "<cmd>CodeCompanionActions<cr>", { desc = "LLM: [A]ctions menu" })
vim.keymap.set({ "n", "v" }, "<leader>lc", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "LLM: toggle [C]hat" })
vim.keymap.set("v", "<leader>ld", "<cmd>CodeCompanionChat Add<cr>", { desc = "LLM: a[D]d selection to chat" })
vim.keymap.set({ "n", "v" }, "<leader>li", "<cmd>CodeCompanion<cr>", { desc = "LLM: [I]nline transform" })
vim.keymap.set({ "n", "v" }, "<leader>lp", function()
  vim.ui.input({ prompt = "LLM prompt: " }, function(prompt)
    if prompt and prompt ~= "" then
      vim.cmd("CodeCompanion " .. prompt)
    end
  end)
end, { desc = "LLM: [P]rompt-then-inline" })

-------------------------------
--------- CLAUDE CODE ---------
-------------------------------

vim.pack.add {
  "https://github.com/folke/snacks.nvim", -- terminal backing for claudecode
  "https://github.com/coder/claudecode.nvim",
}

require("snacks").setup {} -- minimal; claudecode only needs the terminal module
require("claudecode").setup {}

vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Claude Code: toggle terminal" })
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Claude Code: [F]ocus" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Claude Code: [S]end selection" })
vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Claude Code: [A]ccept diff" })
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Claude Code: [D]eny diff" })

vim.keymap.set("n", "<leader>mps", "<cmd>MarkdownPreview<cr>", { desc = "Markdown: Start preview" })
vim.keymap.set("n", "<leader>mpS", "<cmd>MarkdownPreviewStop<cr>", { desc = "Markdown: Stop preview" })
vim.keymap.set("n", "<leader>mpr", "<cmd>MarkdownPreviewRefresh<cr>", { desc = "Markdown: Refresh preview" })
