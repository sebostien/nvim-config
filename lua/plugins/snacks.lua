-- TODO: Image preview

return {
  "folke/snacks.nvim",
  tag = "v2.30.0",
  priority = 1000,
  lazy = false,
  dependencies = { "nvim-mini/mini.icons" },
  opts = {
    bigfile = {
      enabled = true,
      notify = false,
      size = 2 * 1024 * 1024, -- 2MB
    },
    input = { enabled = true },
  },
}
