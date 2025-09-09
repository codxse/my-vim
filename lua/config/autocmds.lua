-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Disable netrw (built-in file explorer) to prevent it from opening
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Neo-tree auto-opening is now disabled via lua/plugins/neo-tree.lua configuration

-- Note: This prevents Neo-tree from auto-opening when opening directories
-- but Neo-tree remains available for manual use with <leader>e
