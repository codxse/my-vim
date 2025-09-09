-- ~/.config/nvim/lua/plugins/lualine.lua

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- 1. Define our custom file path component
    local filepath = {
      function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~")
      end,
      cond = function()
        return vim.api.nvim_buf_get_name(0) ~= ""
      end,
    }

    -- 2. Redefine the center section to ONLY contain our file path
    -- This replaces the default, which includes the navic (LSP context) component.
    opts.sections.lualine_c = { filepath }

    -- 3. Ensure the default filename component on the right is removed
    for i, component in ipairs(opts.sections.lualine_x) do
      if component == "filename" or (type(component) == "table" and component.name == "filename") then
        table.remove(opts.sections.lualine_x, i)
        break
      end
    end
  end,
}
