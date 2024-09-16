-------------------------------------------------
--------------------- Theme ---------------------
-------------------------------------------------
---@class Colors
local Colors = {
  rosewater = "#F5B8AB",
  flamingo = "#F29D9D",
  pink = "#AD6FF7",
  pinker = "#C8A5FF",
  violet = "#EA80FC",
  mauve = "#D87937",
  red = "#f65f54",
  ketchup = "#F44336",
  maroon = "#E76A77",
  peach = "#FAB770",
  yellow = "#FACA64",
  tangarine = "#FBC02D",
  orange = "#FA951A",
  green = "#70CF67",
  kiwi = "#2ECC71",
  cactus = "#27AE60",
  grass = "#91B362",
  cyan = "#90E1C6",
  teal = "#4CD4BD",
  turquoise = "#00C8D4",
  bluish = "#45D7FC",
  sky = "#61BDFF",
  sapphire = "#4BA8FA",
  blue = "#03A9F4",
  blueberry = "#2880FE",
  lavender = "#B7BDF8",
  text = "#EFF2F6",
  subtext1 = "#A3AAC2",
  subtext0 = "#8E94AB",
  overlay2 = "#7D8296",
  overlay1 = "#676B80",
  overlay0 = "#464957",
  surface2 = "#3A3D4A",
  surface1 = "#2F313D",
  surface0 = "#1D1E29",
  base = "#0D1117",
  mantle = "#0D1117",
  crust = "#191926",

  -- Whites
  fg0 = "#EFF2F6",
  fg1 = "#D5D9DF",
  fg2 = "#BCC0C6",
  fg3 = "#A3A7AD",
  fg4 = "#838589",
}

---@param colors Colors
local custom_highlights = function(colors)
  return {
    -- NeoVim
    LineNr = { fg = colors.overlay0 },
    CursorLineNr = { fg = colors.blue, style = { "bold" } },
    DashboardFooter = { fg = colors.overlay0 },
    -- WinSeparator = { fg = colors.overlay0, style = { "bold" } },
    -- Headline = { fg = colors.blue, style = { "bold" } },

    -- Telescope
    TelescopeNormal = { link = "background" },
    TelescopePreviewTitle = { fg = colors.base, bg = colors.green },
    TelescopePromptTitle = { fg = colors.base, bg = colors.peach },
    TelescopeResultsTitle = { fg = colors.base, bg = colors.blue },

    -- Mini
    MiniIndentscopeSymbol = { link = "Comment" },
    MiniSurround = { bg = colors.pink, fg = colors.surface1 },

    -- Syntax
    -- String = { fg = colors.grass },
    Comment = { fg = colors.fg4 },
    Include = { fg = colors.bluish },
    -- ["@property"] = { link = "@lsp.type.variable" },
    -- ["@module"] = { fg = colors.bluish },
    -- ["@lsp.type.interface"] = { fg = colors.red },
  }
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1337,
    opts = {
      flavour = "macchiato",
      dim_inactive = {
        enabled = false,
      },
      custom_highlights = custom_highlights,
      default_integrations = true,
      color_overrides = {
        macchiato = Colors,
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        notify = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
