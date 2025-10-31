return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    enabled = require("conf").is_personal,
    lazy = false,
    dependencies = {},
    config = function()
      vim.g.rustaceanvim = {
        inlay_hints = {
          highlight = "NonText",
        },
        -- Plugin configuration
        tools = {
          float_win_config = {
            border = "rounded",
          },
        },
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

            vim.keymap.set(
              "n",
              "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
              function()
                vim.cmd.RustLsp({ "hover", "actions" })
              end,
              { silent = true, buffer = bufnr }
            )
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
    version = "v0.7.1",
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
      popup = {
        border = "rounded",
      },
    },
  },
}
