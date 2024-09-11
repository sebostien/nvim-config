return {
  {
    "smoka7/hop.nvim",
    version = "*",
    keys = {
      { "gs", "<CMD>HopWord<CR>", desc = "Hop to word in buf" },
      { "<localleader>p", "<CMD>HopPasteChar1<CR>", desc = "Put with Hop" },
      { "<localleader>y", "<CMD>HopYankChar1<CR>", desc = "Yank with Hop" },
    },
    opts = {},
  },
}
