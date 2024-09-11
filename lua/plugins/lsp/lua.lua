return {
  {
    "folke/lazydev.nvim",
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
