return {
  {
    "folke/lazydev.nvim",
    version = "v1.8.0",
    ft = "lua",
    opts = {
      integrations = {
        lspconfig = true,
        cmp = true,
      },
    },
  },
  {
    "folke/neoconf.nvim",
    opts = {},
    priority = 1,
  },
}
