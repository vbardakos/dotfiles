return {
  "stevearc/oil.nvim",
  opts = {
    columns = { "icon", "size" },
    win_options = { signcolumn = "yes" },
  },
  use_default_keymaps = false,
  -- stylua: ignore
  keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
      ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      -- ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    ["<space>t"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
    ["<space>p"] = "actions.preview",
    ["<space>c"] = "actions.close",
    ["<space>l"] = "actions.refresh",
    -- ["<C-h>"] = { "<C-w><C-h>" },
    -- ["<C-l>"] = { "<C-w><C-l>" },
    -- ["<C-j>"] = { "<C-w><C-j>" },
    -- ["<C-k>"] = { "<C-w><C-k>" },
    },
  config = function(_, opts)
    require("oil").setup(opts)
    vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "[O]il File Explorer" })
  end,
}
