return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    ensure_installed = {
      "rust",
      "ron",
      "javascript",
      "just",
      "typescript",
      "c",
      "cmake",
      "python",
      "toml",
      "yuck",
      "yaml",
      "css",
      "scss",
      "zathurarc",
      "latex",
      "vimdoc",
      "vim",
      "lua",
      "luadoc",
      "markdown_inline",
      "markdown",
      "bash",
      "html",
      "help",
      "groovy",
    },
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
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  },
}
