-- Blankline/scope indent

return {
  "nvimdev/indentmini.nvim",
  commit = "e0f1e381a3949ea6757365fa33f8f1722d3eae90",
  event = "VeryLazy",
  config = function()
    require("indentmini").setup({
      -- char = "▎",
      char = "│",
      exclude = {
        "Trouble",
        "dashboard",
        "help",
        "lazy",
        "mason",
        "neo-tree",
        "nofile",
        "notify",
        "prompt",
        "qf",
        "terminal",
        "bigfile",
      },
    })
  end,
}
