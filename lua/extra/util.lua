local M = {}

---Get the path of the most sensible current file.
---Also returns the filetype (if possible).
---
---The most sensible file is choosen in the following order.
---1. The file under cursor in the buffer
---2. The file opened in the buffer
---@alias GetCurrentFileCallback fun(file: string): boolean
---@param callback nil|GetCurrentFileCallback Should return true if file is acceptable. Default: is readable
---@return string?, string?
M.get_current_file = function(callback)
  if callback == nil then
    ---@type fun(file: string): boolean
    callback = function(file)
      return vim.fn.filereadable(file) == 1
    end
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  if ft == "oil" then
    local oil = require("oil")
    local entry = oil.get_cursor_entry()

    if entry ~= nil and entry.type == "file" and entry.id ~= nil then
      local dir = oil.get_current_dir()
      local file_name = entry.name
      local file_path = dir .. file_name

      if callback(file_path) then
        return file_path, nil
      end
    end

    -- Don't try anything else since ft=oil
    return nil, nil
  end

  -- Check visual
  if vim.fn.mode() == "v" then
    -- Exit visual to set '<
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, true, true), "x", true)

    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local file_path = vim.fn.getregion(s_start, s_end)[1]

    if file_path and callback(file_path) then
      return file_path, nil
    end
  end

  local file_path = vim.fn.expand(vim.fn.expand("<cfile>"))
  if file_path and callback(file_path) then
    return file_path, nil
  end

  file_path = vim.api.nvim_buf_get_name(bufnr)
  if file_path and callback(file_path) then
    return file_path, ft
  end

  file_path = vim.fn.expand("%")
  if file_path and callback(file_path) then
    return file_path, ft
  end

  return nil, nil
end

---@param cmd function Callback function to get executable. Takes filepath as argument and returns string.
---@param file_path string
---@return boolean
local download_and_open_img = function(cmd, file_path)
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

      vim.fn.system(cmd(file_path))
      return true
    end
  end

  return false
end

M.preview_image = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  local cmd = nil

  if (vim.env.TERM_PROGRAM == "WezTerm" or vim.env.TERM_PROGRAM == "tmux") and vim.fn.executable("wezterm") then
    cmd = function(file_path)
      return "wezterm cli split-pane --right -- sh -c 'wezterm imgcat " .. file_path .. " ; read'"
    end
  elseif vim.fn.executable("bits") then
    cmd = function(file_path)
      return "bits open " .. file_path
    end
  elseif vim.fn.executable("xdg-open") then
    cmd = function(file_path)
      return "xdg-open " .. file_path
    end
  end

  if cmd == nil then
    vim.notify("Could not find suitable program to open image with", vim.log.levels.ERROR)
    return
  end

  if ft == "oil" then
    local oil = require("oil")
    local entry = oil.get_cursor_entry()

    if entry ~= nil and entry.type == "file" and entry.id ~= nil then
      local dir = oil.get_current_dir()
      local file_name = entry.name
      local file_path = dir .. file_name
      if download_and_open_img(cmd, file_path) then
        return
      end
    end

    -- Don't try anything else since ft=oil
  elseif download_and_open_img(cmd, vim.fn.expand("<cfile>")) then
    return
  elseif download_and_open_img(cmd, vim.fn.expand("%")) then
    return
  end

  vim.notify("Could not open image", vim.log.levels.ERROR)
end

---Run several functions in parallel and execute the callback with a table of results when all functions are finished.
---@param fns function[]
---@param callback function<any[]>
M.concurrent = function(fns, callback)
  local number_of_results = 0
  local results = {}

  for i, fn in ipairs(fns) do
    fn(function(result, ...)
      number_of_results = number_of_results + 1
      results[i] = result

      if number_of_results == #fns then
        callback(results, ...)
      end
    end)
  end
end

---Open file in "some" program :)
---@param filename string?
M.smart_open = function(filename)
  ---@type GetCurrentFileCallback
  local cmd = nil

  if vim.fn.executable("bits") then
    cmd = function(file)
      vim.notify("Trying to open " .. file .. " with bits")
      return vim.system({ "bits", "open", file }):wait().signal == 0
    end
  elseif vim.fn.executable("xdg-open") then
    cmd = function(file)
      return vim.system({ "xdg-open", file }):wait().signal == 0
    end
  else
    vim.notify("No suitable program to open file in", vim.log.levels.ERROR)
    return false
  end

  if filename ~= nil then
    cmd(filename)
  elseif M.get_current_file(cmd) == nil then
    vim.notify("Could not find file", vim.log.levels.WARN)
  end
end

return M
