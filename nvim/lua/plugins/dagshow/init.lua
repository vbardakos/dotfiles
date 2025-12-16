local M = {}

M.setup = function()
  -- todo: add options
end

---@class panel
---@field name string
---@field opts Options
---@field state State?

---@class panel.Options
---@field relative  string
---@field width     integer
---@field height    integer
---@field col       integer
---@field row       integer
---@field style     string
---@field border    string

---@class panel.State
---@field buf integer
---@field win integer
---@field ctx string[]

---@param panel
---@return bool
local refresh = function(panel)
  if panel.name == "project" then
  elseif panel.name == "navigation" then
  elseif panel.name == "preview" then
  end
end

---@param panel panel
---@return panel.State
local retrieve = function(panel)
  local state = resolve_state(panel)
  state.buf = state.buf or vim.api.nvim_create_buf(false, true)
  state.win = state.win or -1

  if vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    vim.api.nvim_win_set_buf(state.win, state.buf)
    vim.api.nvim_win_set_config(state.win, config)
    return state
  end

  state.win = vim.api.nvim_open_win(state.buf, true, config)
  return state
end

M.initialize = function(opts)
  --[[
  --| file  | preview tasks |
  --| ....  | ............. |
  --| ----- | ............. |
  --| info  | ............. |
  --| ....  | ............. |
  ]]
  -- Show active projects
  -- If project exists
  -- 1. create background window
  -- 2. create navigation window
  -- 3. create preview windows: DAG Info & Tasks
  -- else
  -- find project
  local win_config = {
    relative = "editor",
    width = math.random(10, 30),
    height = math.random(10, 30),
    col = math.random(10, 30),
    row = math.random(10, 30),
    border = "rounded",
    style = "minimal",
  }

  return get_panel(nil, win_config)
end

return M.initialize()
