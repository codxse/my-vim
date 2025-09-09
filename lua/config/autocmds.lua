-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable netrw (built-in file explorer) to prevent it from opening
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neo-tree auto-opening is now disabled via lua/plugins/neo-tree.lua configuration

-- Show dashboard when opening directories with nvim .
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.schedule(function()
      -- Check if we're opening a directory (last argument is "." or ends with "/")
      local argc = vim.v.argv
      local last_arg = argc[#argc]
      local is_directory_open = last_arg == "." or last_arg:sub(-1) == "/"

      if is_directory_open and #vim.api.nvim_list_bufs() == 1 then
        -- Only show dashboard if we have just one buffer (the directory buffer)
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].buftype == "" and (vim.fn.bufname(buf) == "" or vim.fn.bufname(buf) == ".") then
          -- This is an empty buffer or directory buffer, show recent files
          require("config.recent-files").show_recent_files()
        end
      end
    end)
  end,
})

-- Note: This prevents Neo-tree from auto-opening when opening directories
-- but Neo-tree remains available for manual use with <leader>e
