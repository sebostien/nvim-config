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
    opts = {
      extensions = { "oil" },
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        theme = "auto",
      },
      sections = {
        lualine_a = {
          {
            function()
              return ""
            end,
            padding = { left = 1, right = 0 },
            separator = "",
          },
          "mode",
        },
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
        lualine_c = { { "filename", file_status = true, newfile_status = true, path = 4 } },
        lualine_x = {},
        lualine_y = { "progress" },
        lualine_z = {
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
