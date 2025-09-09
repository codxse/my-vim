return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "ruby",
      "go",
      "css",
      "javascript",
      "json",
      "xml",
      "yaml",
      "html",
      "bash",
      "tsx",
      "typescript",
    })

    opts.textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",

          -- This is the one you're looking for!
          -- We'll map it to 'b' for block
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",

          -- You can also map parameter lists
          ["a,"] = "@parameter.outer",
          ["i,"] = "@parameter.inner",
        },
      },
      -- You can also add modules for moving and swapping here
      -- move = { ... },
      -- swap = { ... },
    }
  end,
}
