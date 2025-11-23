---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
  local conform = require("conform")
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

return {
  "stevearc/conform.nvim",
  tag = "v9.1.0",
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
    {
      "<leader>f",
      function()
        require("conform").format({
          async = true,
          lsp_fallback = true,
        })
      end,
      mode = "v",
      desc = "Format buffer",
    },
  },
  opts = {
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      rust = { "rustfmt" },
      toml = { "taplo" },
      haskell = { "ormolu" },
      json = { "jq" },
      python = function(bufnr)
        return { first(bufnr, "ruff_organize_imports", "isort"), first(bufnr, "ruff_format", "black") }
      end,

      -- Prettier
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      markdown = function(bufnr)
        return { first(bufnr, "prettierd", "prettier"), "markdownlint", "injected" }
      end,

      -- Shell
      sh = { "beautysh", "shfmt", stop_after_first = true },
      bash = { "beautysh", "shfmt", stop_after_first = true },
    },
    options = {
      lang_to_ft = {},
      lang_to_ext = {
        bash = "sh",
        c_sharp = "cs",
        elixir = "exs",
        javascript = "js",
        julia = "jl",
        latex = "tex",
        markdown = "md",
        python = "py",
        ruby = "rb",
        rust = "rs",
        typescript = "ts",
      },
      lang_to_formatters = {},
    },
  },
}
