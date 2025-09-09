-- ~/.config/nvim/lua/plugins/ruby.lua

return {
  -- Ruby syntax highlighting and indentation
  {
    "vim-ruby/vim-ruby",
    ft = { "ruby", "eruby" },
  },

  -- Rails support
  {
    "tpope/vim-rails",
    ft = { "ruby", "eruby" },
  },

  -- Endwise to automatically add 'end' in Ruby
  {
    "tpope/vim-endwise",
    ft = { "ruby", "eruby" },
  },

  -- LSP configuration for Ruby
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solargraph = {
          settings = {
            solargraph = {
              diagnostics = true,
            },
          },
        },
      },
    },
  },

  -- Treesitter configuration for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ruby", "embedded_template" })
      end
    end,
  },

  -- Configure formatters
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop" },
        eruby = { "erb_format" },
      },
    },
  },

  -- Configure linters
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        ruby = { "rubocop" },
      },
    },
  },
}
