return {
  {
    "numToStr/Comment.nvim",
    version = "v0.8.0",
    event = { "VeryLazy" },
    opts = {},
  },
  {
    -- Detect embedded language and comment correctly
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = { "numToStr/Comment.nvim" },
    event = { "BufAdd", "BufEnter" },
  },
}
