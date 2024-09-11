return {
  {
    "numToStr/Comment.nvim",
    event = { "VeryLazy" },
    opts = {},
  },
  {
    -- Detect embedded language and comment correctly
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufAdd", "BufEnter" },
  },
}
