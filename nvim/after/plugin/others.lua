
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})


-- [[ Background Transparency ]]
vim.api.nvim_create_user_command("TBEnable", function ()
    vim.g.tb_enabled = true
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
end, { desc = "[T]ransparent [B]ackground" })


vim.api.nvim_create_user_command("TBDisable", function ()
    vim.g.tb_enabled = false
    pcall(vim.cmd.colorscheme, vim.g.colors_name)
end, { desc = "[T]ransparent [B]ackground" })

