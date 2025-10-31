local BASE_COLORS = require("colors").Colors

local COLORS = {
  bg1 = BASE_COLORS.subsurface0,
  bg2 = BASE_COLORS.subsurface1,
  orange = BASE_COLORS.orange,
  text = BASE_COLORS.text,
  green = BASE_COLORS.kiwi,
  blue = BASE_COLORS.blueberry,
  red = BASE_COLORS.red,
}

local SN_LINE_THEME = {
  visual = {
    a = { fg = COLORS.bg1, bg = COLORS.orange, gui = "bold" },
    b = { fg = COLORS.text, bg = COLORS.bg2 },
  },
  replace = {
    a = { fg = COLORS.bg1, bg = COLORS.red, gui = "bold" },
    b = { fg = COLORS.text, bg = COLORS.bg2 },
  },
  inactive = {
    c = { fg = COLORS.text, bg = COLORS.bg1 },
    a = { fg = COLORS.bg1, bg = COLORS.blue, gui = "bold" },
    b = { fg = COLORS.text, bg = COLORS.bg2 },
  },
  normal = {
    c = { fg = COLORS.text, bg = COLORS.bg1 },
    a = { fg = COLORS.bg1, bg = COLORS.blue, gui = "bold" },
    b = { fg = COLORS.text, bg = COLORS.bg2 },
  },
  insert = {
    a = { fg = COLORS.bg1, bg = COLORS.green, gui = "bold" },
    b = { fg = COLORS.text, bg = COLORS.bg2 },
  },
}

local active_lsp_clients = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then
    return ""
  end

  local c = {}
  for _, client in pairs(clients) do
    table.insert(c, client.name)
  end
  return " " .. table.concat(c, "|")
end

local lualine_c = {
  {
    "filename",
    file_status = true,
    newfile_status = true,
    path = 4,
    symbols = {
      unnamed = "",
      readonly = "󰣯",
      modified = "",
      newfile = "",
    },
  },
  "searchcount",
}

local lualine_y = {
  { "filetype" },
  { "fileformat", separator = "" },
  { "encoding" },
}

local lualine_z = { "progress", { "location", padding = { left = 0 } } }

local oil_extension = {
  sections = {
    lualine_a = { "mode" },
    lualine_c = lualine_c,
  },
  filetypes = { "oil" },
}

local help_extension = {
  sections = {
    lualine_c = { { "filename", file_status = false }, "searchcount" },
    lualine_y = { "filetype" },
    lualine_z = lualine_z,
  },
  filetypes = { "help" },
}

local man_extension = {
  sections = {
    lualine_c = { { "filename", file_status = false }, "searchcount" },
    lualine_y = { "filetype" },
    lualine_z = lualine_z,
  },
  filetypes = { "man" },
}

local qf_extension = {
  sections = {
    lualine_c = { { "filename", file_status = false }, "searchcount" },
    lualine_y = { "filetype" },
    lualine_z = lualine_z,
  },
  filetypes = { "qf" },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    commit = "3946f0122255bc377d14a59b27b609fb3ab25768",
    dependencies = { "nvim-mini/mini.icons" },
    lazy = false,
    opts = {
      extensions = {
        oil_extension,
        help_extension,
        man_extension,
        qf_extension,
      },
      options = {
        disabled_filetypes = {
          statusline = { "trouble" },
        },
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        theme = SN_LINE_THEME,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = lualine_c,
        lualine_x = {
          active_lsp_clients,
        },
        lualine_y = lualine_y,
        lualine_z = lualine_z,
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = lualine_c,
        lualine_x = {},
        lualine_y = lualine_y,
        lualine_z = lualine_z,
      },
    },
  },
}
