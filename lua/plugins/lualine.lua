-- ~/.config/nvim/lua/plugins/lualine.lua

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Remove the custom file path component from the center section
    -- Keep the default lualine configuration but remove our custom filepath
    opts.sections.lualine_c = {}  -- Empty center section
  end,
}
