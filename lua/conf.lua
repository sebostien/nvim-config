local IS_PERSONAL = true

---@class Setup
---@field is_personal boolean
---@field mason_install string[]

if IS_PERSONAL then
  ---@type Setup
  local M = {
    is_personal = true,
    mason_install = {
      "isort",
      "black",
      "ast-grep",
      "bash-language-server",
      "beautysh",
      "clangd",
      "codelldb",
      "cspell",
      "css-lsp",
      "editorconfig-checker",
      "eslint-lsp",
      "harper-ls",
      "hlint",
      "json-lsp",
      "ltex-ls",
      "lua-language-server",
      "marksman",
      "misspell",
      "ormolu",
      "pyright",
      "ruff",
      "shellcheck",
      "shfmt",
      "sqlls",
      "stylua",
      "taplo",
      "texlab",
      "typescript-language-server",
      "typst-lsp",
      "yaml-language-server",
    },
  }

  return M
else
  ---@type Setup
  local M = {
    is_personal = false,
    mason_install = {
      "jsonls",
      "marksman",
      "ruff",
      "lua-language-server",
      "shellcheck",
    },
  }

  return M
end
