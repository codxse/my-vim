-- Global variable to track the last edited file
local last_edited_file = nil

return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
  },
  opts = {
    options = {
      -- stylua: ignore
      close_command = function(n) Snacks.bufdelete(n) end,
      -- stylua: ignore
      right_mouse_command = function(n) Snacks.bufdelete(n) end,
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,  -- Show bufferline even with 1 tab so file path is always visible
      diagnostics_indicator = function(_, _, diag)
        local icons = LazyVim.config.icons.diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
        {
          filetype = "snacks_layout_box",
        },
      },
      ---@param opts bufferline.IconFetcherOpts
      get_element_icon = function(opts)
        return LazyVim.config.icons.ft[opts.filetype]
      end,
      -- Add file path to the right side of bufferline (inside options)
      custom_areas = {
        right = function()
          local result = {}
          local filepath = vim.fn.expand('%:p')
          local buftype = vim.bo.buftype

          -- Show file path for regular files
          if filepath ~= "" and buftype == "" then
            -- Update last edited file
            last_edited_file = filepath

            local cwd = vim.fn.getcwd()
            local relative_path = vim.fn.fnamemodify(filepath, ':~:.')
            if relative_path == filepath then
              relative_path = vim.fn.fnamemodify(filepath, ':t')
            end

            table.insert(result, {
              text = " 📁 " .. relative_path .. " ",
              fg = "#61dafb",
              bg = "#1e1e2e",
              bold = true
            })
          -- Show last edited file path for terminal buffers
          elseif buftype == "terminal" and last_edited_file then
            local cwd = vim.fn.getcwd()
            local relative_path = vim.fn.fnamemodify(last_edited_file, ':~:.')
            if relative_path == last_edited_file then
              relative_path = vim.fn.fnamemodify(last_edited_file, ':t')
            end

            table.insert(result, {
              text = " 📁 " .. relative_path .. " ",
              fg = "#61dafb",
              bg = "#1e1e2e",
              bold = true
            })
          end
          return result
        end,
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
    -- Fix bufferline when restoring a session
    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
      callback = function()
        vim.schedule(function()
          pcall(nvim_bufferline)
        end)
      end,
    })
  end,
}