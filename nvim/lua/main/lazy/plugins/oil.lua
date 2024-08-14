return {
  "stevearc/oil.nvim",
  config = function()
    require("oil").setup {
      columns = { "icon", "size" },
      win_options = { signcolumn = "yes" },
    }
    vim.keymap.set("n", "<leader>o", "<CMD>Oil<CR>", { desc = "[O]il File Explorer" })
  end,
}
