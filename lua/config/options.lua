-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ~/.config/nvim/lua/config/options.lua

local opt = vim.opt

-- Turn off relative line numbers and enable absolute line numbers
opt.relativenumber = true -- Disable relative line numbers
opt.number = true -- Enable absolute line numbers
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard

-- Disable netrw to prevent file explorer from opening
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Prevent opening directories as buffers
vim.opt.swapfile = false
