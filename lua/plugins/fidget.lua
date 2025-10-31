-- Notifications
-- LSP progress

-- TODO: Telescope integration not working

return {
  "j-hui/fidget.nvim",
  tag = "v1.6.1",
  lazy = false,
  opts = {
    notification = {
      filter = vim.log.levels.DEBUG,
      override_vim_notify = true,
    },
  },
}
