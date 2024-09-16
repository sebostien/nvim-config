return {
  "stevearc/conform.nvim",
  version = "v8.1.0",
  event = "VeryLazy",
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
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      typst = { "typstfmt" },
      haskell = { "ormolu" },
      python = function(bufnr)
        if require("conform").get_formatter_info("ruff_format", bufnr).available then
          return { "ruff_format", "isort" }
        else
          return { "black", "isort" }
        end
      end,

      -- Prettier
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      markdown = function(bufnr)
        if require("conform").get_formatter_info("prettierd", bufnr).available then
          return { "prettierd", "markdownlint" }
        else
          return { "prettier", "markdownlint" }
        end
      end,

      -- Shell
      sh = { "beautysh", "shfmt", stop_after_first = true },
      bash = { "beautysh", "shfmt", stop_after_first = true },
    },
  },
}
