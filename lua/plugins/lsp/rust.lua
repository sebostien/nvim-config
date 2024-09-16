if not require("conf").is_personal then
  return {}
end

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
    },
    config = function()
      vim.g.rustaceanvim = {
        inlay_hints = {
          highlight = "NonText",
        },
        -- Plugin configuration
        tools = {},
        -- LSP configuration
        server = {
          on_attach = function(_, bufnr)
            local map = function(keys, func, desc)
              vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
            end

            -- Popup list for code actions
            map("<leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, "Code Action")

            map("<leader>cd", function()
              vim.cmd.RustLsp("debug")
            end, "Debug")
          end,
          settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {},
          },
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    config = function()
      require("crates").setup()
      require("cmp").setup.filetype("toml", { { name = "crates" } })
    end,
  },
}
