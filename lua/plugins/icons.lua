return {
  "nvim-mini/mini.icons",
  version = "v0.16.0",
  lazy = true,
  opts = {},
  config = function(_, opts)
    require("mini.icons").setup(opts)
    MiniIcons.mock_nvim_web_devicons()
  end,
}
