return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- Disable auto-opening when opening directories
    open_on_setup = false,
    open_on_setup_file = false,
    -- Disable opening on directory change
    filesystem = {
      hijack_netrw_behavior = "disabled",
      follow_current_file = {
        enabled = false,
      },
    },
    -- Disable window picker
    window = {
      mappings = {
        ["<space>"] = "none",
      },
    },
  },
}