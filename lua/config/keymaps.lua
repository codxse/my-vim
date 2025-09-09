-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Show recent files
vim.keymap.set("n", "<leader>r", function()
  require("config.recent-files").show_recent_files()
end, { desc = "Show Recent Files" })

-- Clear file location winbar
vim.keymap.set("n", "<leader>wc", function()
  vim.wo.winbar = nil
end, { desc = "Clear File Location Winbar" })
