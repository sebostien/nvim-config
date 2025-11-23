local IS_PERSONAL = true

---@class sebostien.Config
---@field is_personal boolean
---@field common_dirs string[]
---@field ts_installed string[]

---@type sebostien.Config
local M = {
  is_personal = IS_PERSONAL,
  common_dirs = {
    vim.fn.expand("~/dev/"),
    vim.fn.expand("~/Downloads/"),
    vim.fn.expand("~/Desktop/"),
  },
  ts_installed = {
    "bash",
    "c",
    "css",
    "fish",
    "groovy",
    "html",
    "json",
    "lua",
    "luadoc",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "rust",
    "scss",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
  },
  enabled_lsp_clients = { "ruff", "texlab", "svelte", "lua_ls", "any_ls", "stylua" },
}

if IS_PERSONAL then
  M.ts_installed = vim.tbl_extend("keep", M.ts_installed, {
    "cmake",
    "javascript",
    "just",
    "latex",
    "ron",
    "typescript",
    "yuck",
    "zathurarc",
  })
end

return M
