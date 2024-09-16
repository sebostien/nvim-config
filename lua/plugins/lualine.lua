local colors = {
  bg1 = "#0f1419",
  bg2 = "#14191f",
  orange = "#FA951A",
  text = "#EFF2F6",
  green = "#2Ecc71",
  blue = "#2880FE",
  red = "#f65f54",
}

local SN_THEME = {
  visual = {
    a = { fg = colors.bg1, bg = colors.orange, gui = "bold" },
    b = { fg = colors.text, bg = colors.bg2 },
  },
  replace = {
    a = { fg = colors.bg1, bg = colors.red, gui = "bold" },
    b = { fg = colors.text, bg = colors.bg2 },
  },
  inactive = {
    c = { fg = colors.text, bg = colors.bg1 },
    a = { fg = colors.bg1, bg = colors.blue, gui = "bold" },
    b = { fg = colors.text, bg = colors.bg2 },
  },
  normal = {
    c = { fg = colors.text, bg = colors.bg1 },
    a = { fg = colors.bg1, bg = colors.blue, gui = "bold" },
    b = { fg = colors.text, bg = colors.bg2 },
  },
  insert = {
    a = { fg = colors.bg1, bg = colors.green, gui = "bold" },
    b = { fg = colors.text, bg = colors.bg2 },
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

return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      extensions = { "oil" },
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        theme = SN_THEME,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_c = {
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
        },
        lualine_x = {
          active_lsp_clients,
        },
        lualine_y = {
          { "filetype", separator = "" },
          { "encoding" },
        },
        lualine_z = {
          "progress",
          { "location", separator = "" },
          {
            function()
              return ""
            end,
            padding = { left = 0, right = 1 },
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
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
        },
        lualine_x = {},
        lualine_y = {
          { "filetype", separator = "" },
          { "encoding" },
        },
        lualine_z = {
          "progress",
          { "location", separator = "" },
          {
            function()
              return ""
            end,
            padding = { left = 0, right = 1 },
          },
        },
      },
    },
  },
}
