return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  config = function()
    local harpoon = require "harpoon"
    harpoon:setup()

    -- stylua: ignore start
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "[A]dd Harpoon"})
    vim.keymap.set("n", "<Tab><leader>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Toggle Harpoon" })

    vim.keymap.set({ "n", "t" }, "<Tab>a", function() harpoon:list():select(1) end, { desc = "Harpoon [1]"})
    vim.keymap.set({ "n", "t" }, "<Tab>s", function() harpoon:list():select(2) end, { desc = "Harpoon [2]"})
    vim.keymap.set({ "n", "t" }, "<Tab>d", function() harpoon:list():select(3) end, { desc = "Harpoon [3]"})
    vim.keymap.set({ "n", "t" }, "<Tab>f", function() harpoon:list():select(4) end, { desc = "Harpoon [4]"})
    vim.keymap.set({ "n", "t" }, "<Tab>g", function() harpoon:list():select(4) end, { desc = "Harpoon [5]"})

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set("n", "<Tab>p", function() harpoon:list():prev() end, { desc = "Harpoon Prev" })
    vim.keymap.set("n", "<Tab>n", function() harpoon:list():next() end, { desc = "Harpoon Next" })
    -- stylua: ignore end
  end,
}
