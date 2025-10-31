local Colors = require("colors").Colors

---@param colors Colors
local custom_highlights = function(colors)
  return {
    -- NeoVim
    LineNr = { fg = colors.overlay0 },
    CursorLineNr = { fg = colors.blue, style = { "bold" } },

    -- Telescope
    TelescopePreviewTitle = { fg = colors.base, bg = colors.green },
    TelescopePromptTitle = { fg = colors.base, bg = colors.peach },
    TelescopeResultsTitle = { fg = colors.base, bg = colors.blue },

    -- Blink
    BlinkCmpMenu = { link = "background" },
    BlinkCmpSignatureHelpBorder = { link = "BlinkCmpDocBorder" },
    BlinkCmpSignatureHelp = { link = "BlinkCmpDoc" },

    -- Trouble
    TroubleCount = { fg = colors.blue, bg = colors.crust },

    -- TODOs
    TodoBgDone = { bg = colors.green, fg = colors.base },
    TodoFgDone = { fg = colors.green },

    -- Mini
    MiniSurround = { bg = colors.pink, fg = colors.surface1 },

    -- Indent symbols
    IndentLine = { link = "LineNr" },
    IndentLineCurrent = { link = "Comment" },

    -- Syntax
    String = { fg = colors.green },
    Comment = { fg = colors.fg4 },
    Include = { fg = colors.bluish },
  }
end

return {
  {
    "uga-rosa/ccc.nvim",
    tag = "v2.0.3",
    keys = {
      { "<leader>tc", "<CMD>CccHighlighterToggle<CR>", desc = "Toggle color preview" },
    },
    opts = {},
    config = function(_, _)
      local ccc = require("ccc")

      ccc.setup({
        pickers = {
          ccc.picker.hex,
          ccc.picker.css_rgb,
          ccc.picker.css_hsl,
          ccc.picker.css_hwb,
          ccc.picker.css_lab,
          ccc.picker.css_lch,
          ccc.picker.css_oklab,
          ccc.picker.css_oklch,
          ccc.picker.custom_entries(Colors),
          ccc.picker.ansi_escape(),
        },
      })
    end,
  },
  {
    "catppuccin/nvim",
    tag = "v1.11.0",
    name = "catppuccin",
    lazy = false,
    priority = 1337,
    opts = {
      flavour = "mocha",
      dim_inactive = {
        enabled = false,
      },
      custom_highlights = custom_highlights,
      transparent_background = false,
      default_integrations = true,
      color_overrides = {
        mocha = Colors,
      },
      integrations = {
        blink_cmp = true,
        gitsigns = true,
        treesitter = true,
        mason = true,
        mini = { enabled = true },
        dap = true,
        dap_ui = true,
        telescope = { enabled = true },
        which_key = true,
        fidget = true,
        hop = true,
        snacks = { enabled = true }, -- TODO: Maybe remove? Make own vim.ui.select or fix highlights!
        lsp_trouble = false, -- NOTE: Disabled since BG active is wrong

        -- TODO: treesitter_context = true ??
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
