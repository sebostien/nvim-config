local conf = require("conf")

local M = {}

M.telescope_files = function(extensions, command)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local tele_conf = require("telescope.config").values

  local opts = {}
  local dirs = table.concat(conf.project_dirs, " ")

  local pwd = vim.fn.getcwd()
  local all = vim.fn.system("find " .. dirs .. " " .. pwd .. " -mindepth 1 -maxdepth 3")
  local results = {}
  for f in string.gmatch(all, "([^\n]*)\n?") do
    for _, ext in ipairs(extensions) do
      if string.match(f, ext .. "$") then
        table.insert(results, f)
      end
    end
  end

  pickers
    .new(opts, {
      prompt_title = "Select file",
      finder = finders.new_table({
        results = results,
      }),
      sorter = tele_conf.generic_sorter(opts),
      attach_mappings = function(promt_bufnr)
        actions.select_default:replace(function()
          actions.close(promt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.fn.system(command .. " " .. selection[1] .. " &")
        end)
        return true
      end,
    })
    :find()
end

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

      local cmd = "wezterm cli split-pane --right -- sh -c 'wezterm imgcat "
        .. file_path
        .. " ; read'"
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
