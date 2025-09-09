-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Show recent files
vim.keymap.set("n", "<leader>r", function()
  require("plugins.recent-files").show_recent_files()
end, { desc = "Show Recent Files" })
