return {
  "nvim-treesitter/nvim-treesitter",
  tag = "v0.10.0",
  build = ":TSUpdate",
  lazy = false,
  opts = {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    ensure_installed = require("conf").ts_installed,
    auto_install = true,
    autopairs = {
      enable = true,
    },
    highlight = {
      enable = true,
    },
    indent = {
      enable = true,
      disable = { "yaml" },
    },
  },
  config = function(_, conf)
    require("nvim-treesitter.configs").setup(conf)
  end,
}
