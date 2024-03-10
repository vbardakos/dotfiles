return {
  { "numToStr/Comment.nvim", opts = {} },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    config = true,
    keys = {},
  }
}
