-- ~/.config/nvim/lua/plugins/css.lua

return {
  -- color preview pfor css files
  {
    "nvchad/nvim-colorizer.lua",
    event = { "bufreadpost", "bufnewfile" },
    opts = {
      filetypes = { "css", "scss", "html", "javascript", "typescript", "vue", "svelte", "eruby" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue or blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        mode = "background", -- Set the display mode: "foreground", "background"
      },
    },
    config = function(_, opts)
      require("colorizer").setup(opts)

      -- Attach to all filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          require("colorizer").attach_to_buffer(0, { mode = "background", css = true })
        end,
      })
    end,
  },
}
