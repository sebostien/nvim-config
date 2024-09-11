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
    -- Formatting
    { "onsails/lspkind.nvim" },
  },
  config = function()
    local cmp = require("cmp")
    local types = require("cmp.types")
    local lspkind = require("lspkind")

    WIDE_HEIGHT = 80

    cmp.setup({
      completion = { completeopt = "menu,menuone,noinsert" },
      mapping = cmp.mapping.preset.insert({
        -- Select
        ["<C-n>"] = cmp.mapping.select_next_item,
        ["<C-p>"] = cmp.mapping.select_prev_item,
        -- Scroll docs
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        -- Other
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
        -- TODO: This
        default_behavior = types.cmp.ConfirmBehavior.Replace,
      },
      window = {
        -- TODO: This
        documentation = {
          maxwidth = math.floor(WIDE_HEIGHT * (vim.o.columns / 100)),
          maxheight = math.floor(WIDE_HEIGHT * (vim.o.lines / 100)),
        },
      },
      formatting = {
        -- TODO: This
        format = lspkind.cmp_format({
          with_text = true,
          maxwidth = 50,
        }),
      },
    })
  end,
}
