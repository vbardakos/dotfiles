local lsp_name = function()
  -- local msg = "No Active Lsp"
  local msg = ""
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return msg
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client.name
    end
  end
  return msg
end

return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      icons_enabled = true,
      theme = "rose-pine",
      component_separators = "|",
      section_separators = "",
    },
    sections = {
      -- stylua: ignore
      lualine_a = { { "mode", fmt = function(str) return str:sub(1, 1) end, } },
      lualine_b = {
        {
          "diagnostics",
          sources = { "nvim_diagnostic" },
          symbols = { error = " ", warn = " ", info = " " },
        },
        { lsp_name, icon = " " },
      },
      lualine_c = {
        -- stylua: ignore
        { "filetype", fmt = function(_) return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":~:.") end, },
      },
      lualine_x = {
        { "branch", icon = "" },
        { "diff", symbols = { added = " ", modified = "󰝤 ", removed = " " } },
        -- { "o:encoding", fmt = string.upper },
      },
    },
  },
}
