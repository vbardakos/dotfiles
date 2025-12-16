local create_floating_window = function(opts)
  opts = opts or {}
  local width = opts.width or vim.o.columns
  local height = opts.height or vim.o.lines

  local row = math.floor((vim.o.columns - width) / 2)
  local col = math.floor((vim.o.lines - height) / 2)

  local bufr = vim.api.nvim_create_buf(false, true)

  local win_config = {
    width = width,
    height = height,
    col = col,
    row = row,
  }
  opts = vim.tbl_extend("force", opts, win_config)
  local win = vim.api.nvim_open_win(bufr, true, opts)
  return bufr, win
end

local list_relative_files = function(dir)
  local uv = vim.loop
  local result = {}
  local abs_dir = vim.fn.fnamemodify(dir, ":p") -- Convert to absolute path
  local prefix_len = #abs_dir + 1 -- Length to remove the directory prefix

  local function scan_directory(path)
    local handle = uv.fs_scandir(path)
    if not handle then
      return
    end

    while true do
      local name, type = uv.fs_scandir_next(handle)
      if not name then
        break
      end
      local full_path = path .. "/" .. name

      if type == "directory" then
        scan_directory(full_path) -- Recurse into subdirectories
      else
        table.insert(result, full_path:sub(prefix_len + 1))
      end
    end
  end

  scan_directory(abs_dir)
  return result, abs_dir
end

local create_floating_navigator = function(dir, opts)
  opts = opts or {}
  local files, abspath = list_relative_files(dir)

  local nav_config = {
    title = dir,
    width = math.max(#dir, opts.width or 0),
    title_pos = "center",
    relative = "editor",
    style = "minimal",
    border = "rounded",
  }

  opts = vim.tbl_extend("keep", opts, nav_config)

  local bufr, win = create_floating_window(opts)
  vim.api.nvim_buf_set_lines(bufr, 0, -1, false, files)

  return bufr, win
end

local function create_float_opts(height, width)
  -- Get the editor dimensions
  local editor_width = vim.o.columns
  local editor_height = vim.o.lines

  -- Calculate window size based on percentages
  local win_width = math.floor(editor_width * width / 100)
  local win_height = math.floor(editor_height * height / 100)
  local row = math.floor((editor_height - win_height) / 2)
  local col = math.floor((editor_width - win_width) / 2)

  -- Configure window options
  return {
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }
end

vim.api.nvim_create_user_command("Win", function()
  local width, height = math.floor((vim.o.columns * 30) / 100), math.floor((vim.o.lines * 30) / 100)
  local dir = "nvim/lua/main/lazy/plugins"
  create_floating_window {
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    relative = "win",
    style = "minimal",
    border = "solid",
  }
  -- create_file_navigator(dir, 50, math.max(#dir, 10))
end, {})
