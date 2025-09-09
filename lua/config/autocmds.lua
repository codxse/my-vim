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

-- File location is now shown in bufferline custom area (right side of tabs)

-- Ensure files opened from Telescope/search replace blank buffers
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    -- Only process if current buffer is a real file (not special buffers)
    if vim.bo.buftype ~= "" then
      return
    end

    local current_buf = vim.api.nvim_get_current_buf()
    local current_name = vim.api.nvim_buf_get_name(current_buf)

    -- Only process if this is a real file (not empty, not directory)
    if current_name == "" or current_name == "." then
      return
    end

    -- Find and delete any directory/blank buffers
    local bufs = vim.api.nvim_list_bufs()
    for _, buf in ipairs(bufs) do
      if buf ~= current_buf then
        local buf_name = vim.api.nvim_buf_get_name(buf)
        local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')

        -- Delete directory buffers or empty buffers that are not the current file
        if buf_type == "" and (buf_name == "." or buf_name == vim.fn.getcwd() or buf_name == "") then
          vim.api.nvim_buf_delete(buf, { force = true })
          break  -- Only delete one at a time to avoid issues
        end
      end
    end
  end,
})

-- Note: This prevents Neo-tree from auto-opening when opening directories
-- but Neo-tree remains available for manual use with <leader>e
