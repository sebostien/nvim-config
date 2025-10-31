local utils = require("extra.util")

-- TODO: Watch file if opened. Need to make autorefresh.

---@type table<string, string>
local filetype_to_pandoc = {
  markdown = "gfm",
}

return function()
  if not vim.fn.executable("pandoc") then
    vim.notify("pandoc is not installed", vim.log.levels.ERROR)
    return
  end

  local filename, filetype = utils.get_current_file()
  if filename == nil then
    vim.notify("Could not find a suitable file to render", vim.log.levels.WARN)
    return
  end

  local outname = vim.fn.tempname() .. ".html"

  ---@type string[]
  local cmd = nil
  if filetype ~= nil and filetype_to_pandoc[filetype] then
    cmd = {
      "pandoc",
      "--from",
      filetype_to_pandoc[filetype],
      "--to",
      "html5",
      "--output",
      outname,
      filename,
    }
  else
    -- Hope that pandoc detects the ft
    cmd = { "pandoc", "--to", "html5", "--output", outname, filename }
  end

  vim.system(cmd):wait()
  utils.smart_open(outname)
end
