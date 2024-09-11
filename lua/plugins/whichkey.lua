return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        marks = true,
        registers = true,
      },
      win = {
        border = "single",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      wk.add({
        { "<leader>c",       group = "Codeactions LSP" },
        { "<leader>c_",      hidden = true },
        { "<leader>l",       group = "Start LSPs" },
        { "<leader>l_",      hidden = true },
        { "<leader>r",       group = "Rename symbols" },
        { "<leader>r_",      hidden = true },
        { "<leader>s",       group = "Search with LSP" },
        { "<leader>s_",      hidden = true },
        { "<leader>t",       group = "Buffer toggles" },
        { "<leader>t_",      hidden = true },
        { "<localleader>c",  group = "Change" },
        { "<localleader>c_", hidden = true },
        { "<localleader>d",  group = "DAP" },
        { "<localleader>d_", hidden = true },
        { "<localleader>f",  group = "Find stuff" },
        { "<localleader>f_", hidden = true },
        { "<localleader>g",  group = "Git info" },
        { "<localleader>g_", hidden = true },
        { "<localleader>h",  group = "Help pages" },
        { "<localleader>h_", hidden = true },
        { "<localleader>l",  group = "Lazy" },
        { "<localleader>l_", hidden = true },
        { "<localleader>o",  group = "Open with program" },
        { "<localleader>o_", hidden = true },
        { "<localleader>t",  group = "Show TODOs" },
        { "<localleader>t_", hidden = true },
      })
    end,
  },
}
