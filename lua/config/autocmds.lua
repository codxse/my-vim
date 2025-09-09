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

-- Global variable to track the last real file (not Neo-tree buffers)
local last_real_file = nil

-- Track when we switch to a real file
vim.api.nvim_create_autocmd({"BufEnter", "BufReadPost"}, {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local buftype = vim.bo.buftype

    -- Only track real files, not special buffers
    if buftype == "" and bufname ~= "" and not bufname:match("neo%-tree") then
      local previous_file = last_real_file
      last_real_file = bufname

      -- If Neo-tree is already open and we switched files, update focus
      if previous_file ~= last_real_file then
        -- Check if Neo-tree window exists
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.api.nvim_buf_get_option(buf, 'filetype') == 'neo-tree' then
            -- Neo-tree is open, update focus to new file
            vim.defer_fn(function()
              if vim.fn.filereadable(last_real_file) == 1 then
                pcall(function()
                  vim.cmd("Neotree reveal " .. vim.fn.fnameescape(last_real_file))
                end)
              end
            end, 100)
            break
          end
        end
      end
    end
  end,
})

-- Auto-focus Neo-tree on current file when sidebar opens
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neo-tree",
  callback = function()
    -- Wait a bit for Neo-tree to fully load
    vim.defer_fn(function()
      -- Use the tracked real file instead of current buffer
      local current_file = last_real_file
      print("DEBUG: Neo-tree opened, tracked file:", current_file)

      if current_file and current_file ~= "" and vim.fn.filereadable(current_file) == 1 then
        print("DEBUG: File exists, attempting to reveal:", current_file)

        -- Try the simple reveal command first
        pcall(function()
          vim.cmd("Neotree reveal " .. vim.fn.fnameescape(current_file))
          print("DEBUG: Reveal command executed")
        end)

        -- Alternative: Try focus command
        vim.defer_fn(function()
          pcall(function()
            vim.cmd("Neotree focus")
            print("DEBUG: Focus command executed")
          end)
        end, 100)
      else
        print("DEBUG: No valid file to reveal")
      end
    end, 300)  -- Increased delay
  end,
})

-- Note: This prevents Neo-tree from auto-opening when opening directories
-- but Neo-tree remains available for manual use with <leader>e
