local MAX_WIDTH = 50 -- Max width of completion pop-up

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
  "hrsh7th/nvim-cmp",
  event = "VeryLazy",
  dependencies = {
    -- CMP Sources
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-calc" },
  },
  config = function()
    local cmp = require("cmp")
    local types = require("cmp.types")

    cmp.setup({
      completion = { completeopt = "menu,menuone,noinsert" },
      mapping = cmp.mapping.preset.insert({
        -- Select
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),

        -- Scroll docs
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Other
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-s>"] = cmp.mapping.complete(),
      }),
      -----
      sources = {
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "calc" },
        { name = "buffer" },
      },
      confirmation = {
        default_behavior = types.cmp.ConfirmBehavior.Insert, -- Insert completion before any text after
        get_commit_characters = function(commit_characters)
          return commit_characters
        end,
      },
      window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered(),
      },
      formatting = {
        expandable_indicator = true,
        fields = { "kind", "abbr", "menu" },
        format = function(_, vim_item)
          local symbol = KIND_MAP[vim_item.kind] or ""
          vim_item.kind = string.format("%s", symbol)

          if vim.fn.strchars(vim_item.abbr) > MAX_WIDTH then
            vim_item.abbr = vim.fn.strcharpart(vim_item.abbr, 0, MAX_WIDTH) .. "..."
          end
          return vim_item
        end,
      },
    })

    -- `/` cmdline setup.
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      view = {
        entries = { name = "wildmenu", separator = " " },
      },
      sources = {
        { name = "buffer" },
      },
    })
  end,
}
