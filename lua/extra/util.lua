local M = {}

---@param file_path string
---@return boolean
local wez_open_img = function(file_path)
  local ext = file_path:match("^.+(%..+)$")
  local supported = { ".jpg", ".jpeg", ".png", ".gif" }

  for _, v in ipairs(supported) do
    if v == ext then
      -- If file_path is url, download to tmp and open
      if file_path:find("https?://") ~= nil then
        local temp_file = vim.fn.tempname() .. ext
        require("plenary.curl").get(file_path, { output = temp_file })
        file_path = temp_file
      end

      local cmd = "wezterm cli split-pane --right -- sh -c 'wezterm imgcat " .. file_path .. " ; read'"
      vim.fn.system(cmd)
      return true
    end
  end

  return false
end

M.preview_image = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  if ft == "oil" and vim.env.TERM_PROGRAM == "WezTerm" then
    local oil = require("oil")
    local entry = oil.get_cursor_entry()

    if entry ~= nil and entry.type == "file" then
      local dir = oil.get_current_dir()
      local file_name = entry.name
      local file_path = dir .. file_name
      wez_open_img(file_path)
    end

    -- Don't try anything else since ft=oil
    vim.notify("Could not open image")
    return
  end

  if wez_open_img(vim.fn.expand("<cfile>")) then
    return
  end

  if wez_open_img(vim.fn.expand("%")) then
    return
  end

  vim.notify("Could not open image")
end

return M
