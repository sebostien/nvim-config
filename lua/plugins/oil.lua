return {
  {
    "refractalize/oil-git-status.nvim",
    event = "VeryLazy",
    dependencies = {
      "stevearc/oil.nvim",
    },
    opts = { show_ignored = true },
  },
  {
    "stevearc/oil.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      win_options = {
        signcolumn = "yes:2",
      },
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 8,
        max_width = 128,
      },
      keymaps = {
        ["<ESC>"] = "actions.close",
      },
    },
    keys = {
      {
        "<localleader>\\",
        function()
          require("oil").toggle_float()
        end,
        desc = "File tree float",
      },
    },
  },
}
