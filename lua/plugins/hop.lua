return {
  {
    "smoka7/hop.nvim",
    tag = "v2.7.2",
    event = "VeryLazy",
    keys = {
      { "gs", "<CMD>HopWord<CR>", desc = "Hop to word in buf" },
      { "gl", "<CMD>HopAnywhereCurrentLine<CR>", desc = "Hop current line" },
      { "gC", "<CMD>HopChar1<CR>", desc = "Hop to char" },
      { "<localleader>p", "<CMD>HopPasteChar1<CR>", desc = "Put with Hop" },
      { "<localleader>y", "<CMD>HopYankChar1<CR>", desc = "Yank with Hop" },
    },
    opts = {},
  },
}
