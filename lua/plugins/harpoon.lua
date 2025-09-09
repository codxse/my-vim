return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      -- REQUIRED
      harpoon:setup()

      -- Basic keymaps
      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>hr", function()
        harpoon:list():remove()
      end, { desc = "Harpoon remove file" })
      vim.keymap.set("n", "<leader>hc", function()
        harpoon:list():clear()
      end, { desc = "Harpoon clear all" })
      vim.keymap.set("n", "<leader>h", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon Quick Menu" })
      vim.keymap.set("n", "<leader>H", function()
        harpoon:list():add()
      end, { desc = "Harpoon File" })

      -- Jump to file shortcuts
      vim.keymap.set("n", "<leader>1", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon to File 1" })
      vim.keymap.set("n", "<leader>2", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon to File 2" })
      vim.keymap.set("n", "<leader>3", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon to File 3" })
      vim.keymap.set("n", "<leader>4", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon to File 4" })
      vim.keymap.set("n", "<leader>5", function()
        harpoon:list():select(5)
      end, { desc = "Harpoon to File 5" })

      -- Navigation
      vim.keymap.set("n", "<C-p>", function()
        harpoon:list():prev()
      end, { desc = "Harpoon prev buffer" })
      vim.keymap.set("n", "<C-n>", function()
        harpoon:list():next()
      end, { desc = "Harpoon next buffer" })
    end,
  },
}
