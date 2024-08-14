return {
  "folke/which-key.nvim",
  event = "VimEnter",
  config = function()
    local which = require "which-key"

    which.setup()
    which.add {
      { "<leader>c", group = "[C]ode" },
      { "<leader>h", group = "[H]arpoon" },
      { "<leader>d", group = "[D]ocument" },
      { "<leader>r", group = "[R]ename" },
      { "<leader>s", group = "[S]earch" },
      { "<leader>w", group = "[W]orkspace" },
    }
  end,
}
