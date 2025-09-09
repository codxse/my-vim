-- Recent files display functionality
local M = {}

-- Function to show recent files in a small buffer
function M.show_recent_files()
  -- Get recent files from vim.v.oldfiles
  local oldfiles = vim.v.oldfiles or {}

  -- Get current working directory for filtering
  local cwd = vim.fn.getcwd()

  -- Filter to get only the first 4 existing files from current directory
  local recent_files = {}
  local count = 0

  for _, file in ipairs(oldfiles) do
    if count >= 4 then break end
    if vim.fn.filereadable(file) == 1 then
      -- Check if file is in current directory or subdirectory
      local file_dir = vim.fn.fnamemodify(file, ':h')
      if file_dir == cwd or file_dir:find(cwd .. '/', 1, true) == 1 then
        table.insert(recent_files, file)
        count = count + 1
      end
    end
  end

  if #recent_files == 0 then
    return
  end

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)

  -- Prepare the content
  local lines = { "Recent Files (Current Directory):", "" }
  for i, file in ipairs(recent_files) do
    -- Get just the filename without full path for cleaner display
    local filename = vim.fn.fnamemodify(file, ':t')
    local dirname = vim.fn.fnamemodify(file, ':h')
    table.insert(lines, string.format("%d. %s (%s)", i, filename, dirname))
  end

  table.insert(lines, "")
  table.insert(lines, "Navigate with j/k, press Enter to open, s to search, q to close")

  -- Set the content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Set buffer name
  vim.api.nvim_buf_set_name(buf, "Recent Files")

  -- Create a larger window
  local width = 80  -- Increased from 60
  local height = #lines + 2  -- Add some padding
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
  })

  -- Set window options
  vim.api.nvim_win_set_option(win, 'number', false)
  vim.api.nvim_win_set_option(win, 'relativenumber', false)
  vim.api.nvim_win_set_option(win, 'cursorline', true)

  -- Position cursor on first file (line 3, since lines are 1-indexed)
  vim.api.nvim_win_set_cursor(win, {3, 0})

  -- Key mappings
  local function close_window()
    vim.api.nvim_win_close(win, true)
  end

  -- Function to get the file index from current line
  local function get_file_index_from_line()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line = cursor[1]
    -- File lines start at line 3 (1. filename, 2. filename, 3. filename)
    if line >= 3 and line <= 2 + #recent_files then
      return line - 2
    end
    return nil
  end

  -- Function to open file at current line
  local function open_file_at_cursor()
    local index = get_file_index_from_line()
    if index and recent_files[index] then
      close_window()

      -- Get the current buffer (should be the directory buffer)
      local current_buf = vim.api.nvim_get_current_buf()
      local buf_name = vim.api.nvim_buf_get_name(current_buf)

      -- If this is a directory buffer, delete it before opening the new file
      if buf_name == "." or buf_name == vim.fn.getcwd() then
        vim.api.nvim_buf_delete(current_buf, { force = true })
      end

      -- Open the selected file
      vim.cmd('edit ' .. vim.fn.fnameescape(recent_files[index]))
    end
  end

  -- Map Enter to open file at cursor
  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', '', {
    noremap = true,
    silent = true,
    callback = open_file_at_cursor
  })

  -- Restrict cursor movement to file lines only
  local function restrict_cursor()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local line = cursor[1]
    -- File lines are from 3 to 2 + #recent_files
    local min_line = 3
    local max_line = 2 + #recent_files

    if line < min_line then
      vim.api.nvim_win_set_cursor(win, {min_line, 0})
    elseif line > max_line then
      vim.api.nvim_win_set_cursor(win, {max_line, 0})
    end
  end

  -- Apply cursor restriction after any movement
  vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    buffer = buf,
    callback = restrict_cursor
  })

  -- Map number keys to open files (support up to 4)
  for i = 1, math.min(#recent_files, 4) do
    vim.api.nvim_buf_set_keymap(buf, 'n', tostring(i), '', {
      noremap = true,
      silent = true,
      callback = function()
        close_window()

        -- Get the current buffer (should be the directory buffer)
        local current_buf = vim.api.nvim_get_current_buf()
        local buf_name = vim.api.nvim_buf_get_name(current_buf)

        -- If this is a directory buffer, delete it before opening the new file
        if buf_name == "." or buf_name == vim.fn.getcwd() then
          vim.api.nvim_buf_delete(current_buf, { force = true })
        end

        -- Open the selected file
        vim.cmd('edit ' .. vim.fn.fnameescape(recent_files[i]))
      end
    })
  end

  -- Map q to close
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = close_window
  })

  -- Map Esc to close
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '', {
    noremap = true,
    silent = true,
    callback = close_window
  })

  -- Map s to search files in current directory
  vim.api.nvim_buf_set_keymap(buf, 'n', 's', '', {
    noremap = true,
    silent = true,
    callback = function()
      close_window()
      -- Trigger LazyVim's default file search (same as <leader><leader>)
      -- This works regardless of whether Telescope or fzf-lua is used
      local cwd = vim.fn.getcwd()
      vim.api.nvim_set_current_dir(cwd)  -- Set cwd for the search
      vim.cmd('lua require("lazyvim.util").pick("files")()')
    end
  })

  -- Auto-close on buffer leave
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    callback = close_window
  })
end

return M