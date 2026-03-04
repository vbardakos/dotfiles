--[
-- Each event populates the following |event-data| fields:
-- • `active` - whether plugin was added via |vim.pack.add()| to current session.
-- • `kind` - one of "install" (install on disk; before loading), "update"
--   (update already installed plugin; might be not loaded), "delete" (delete
--   from disk).
-- • `spec` - plugin's specification with defaults made explicit.
-- • `path` - full path to plugin's directory.
--
-- These events can be used to execute plugin hooks. For example: >lua
--     local hooks = function(ev)
--       -- Use available |event-data|
--       local name, kind = ev.data.spec.name, ev.data.kind
--
--       -- Run build script after plugin's code has changed
--       if name == 'plug-1' and (kind == 'install' or kind == 'update') then
--         -- Append `:wait()` if you need synchronous execution
--         vim.system({ 'make' }, { cwd = ev.data.path })
--       end
--
--       -- If action relies on code from the plugin (like user command or
--       -- Lua code), make sure to explicitly load it first
--       if name == 'plug-2' and kind == 'update' then
--         if not ev.data.active then
--           vim.cmd.packadd('plug-2')
--         end
--         vim.cmd('PlugTwoUpdate')
--         require('plug2').after_update()
--       end
--     end
--
--     -- If hooks need to run on install, run this before `vim.pack.add()`
--     vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })
-- <
--]

local function get_clients()
  local clients = vim.lsp.get_clients { bufnr = 0 }
  for _, v in pairs(clients) do
    print(v.name)
  end
end

get_clients()
