return {
  "stevearc/conform.nvim",
  lazy = false,
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({
          async = true,
          lsp_fallback = true,
        })
      end,
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { { "ruff_format", "black" }, "isort" },
      javascript = { { "prettierd", "prettier" } },
      typescript = { { "prettierd", "prettier" } },
      markdown = { { "prettierd", "prettier" }, "markdownlint" },
      rust = { "rustfmt" },
      typst = { "typstfmt" },
      haskell = { "ormolu" },

      sh = { { "beautysh", "shfmt" } },
      bash = { { "beautysh", "shfmt" } },
      zsh = { { "beautysh", "shfmt" } },
    },
  },
}
