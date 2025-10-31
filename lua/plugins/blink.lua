-- https://cmp.saghen.dev/configuration/reference.html#completion-list

-- TODO: Blink-cmp Providers
--       - calc, complete calculations (2+2 -> 4)
--       - dictionary
--       - Complete from env (hide values)
-- TODO: Snippets

-- FROM: https://github.com/onsails/lspkind.nvim
local KIND_MAP = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "",
}

return {
  {
    "saghen/blink.cmp",
    event = "VeryLazy",
    tag = "v1.8.0",
    opts = {
      -- tab: to accept
      -- C-n/C-p: Select next/previous item
      -- C-e: Hide menu
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = "super-tab" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
        },
      },
      completion = {
        menu = {
          auto_show = true,
          border = "rounded",
          draw = {
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
            components = {
              kind_icon = {
                text = function(ctx)
                  if
                    vim.tbl_contains({ "Path" }, ctx.source_name)
                    and not vim.tbl_contains({ "link" }, ctx.item.data.type)
                  then
                    local mini_icon, _ = require("mini.icons").get(ctx.item.data.type, ctx.label)
                    if mini_icon then
                      return mini_icon .. ctx.icon_gap
                    end
                  end

                  local icon = KIND_MAP[ctx.kind] or ""
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local mini_icon, mini_hl = require("mini.icons").get(ctx.item.data.type, ctx.label)
                    if mini_icon then
                      return mini_hl
                    end
                  end
                  return ctx.kind_hl
                end,
              },
            },
          },
        },
        documentation = { auto_show = true, window = { border = "rounded" } },
        ghost_text = { enabled = true },
      },
      signature = { enabled = true, window = { border = "rounded" } },
    },
    config = function(_, opts)
      require("blink.cmp").setup(opts)
      vim.lsp.config("*", require("blink.cmp").get_lsp_capabilities({}, true))
    end,
  },
}
