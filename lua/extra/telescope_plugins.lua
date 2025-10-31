local conf = require("conf")

local M = {}

-- TODO: A previewer that does not crash on pdf :)

M.common_dirs = function()
  local util = require("extra.util")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local tele_conf = require("telescope.config").values

  local opts = {}

  local pwd = vim.fn.getcwd()
  local all = {}

  if vim.fn.executable("fd") then
    local cmd = { "fd", "--min-depth", "1", "--max-depth", "3" }

    for _, dir in ipairs(conf.common_dirs) do
      table.insert(cmd, "--search-path")
      table.insert(cmd, dir)
    end

    table.insert(cmd, "--search-path")
    table.insert(cmd, pwd)

    table.insert(cmd, ".") -- pattern
    all = vim.system(cmd):wait()
  else
    local cmd = { "find" }
    for _, dir in ipairs(conf.common_dirs) do
      table.insert(cmd, dir)
    end

    table.insert(cmd, pwd) -- pattern
    table.insert(cmd, "-mindepth")
    table.insert(cmd, "1")
    table.insert(cmd, "-maxdepth")
    table.insert(cmd, "3")
    all = vim.system(cmd):wait()
  end

  local results = {}
  for e in string.gmatch(all.stdout or "", "([^\n]*)\n?") do
    table.insert(results, e)
  end

  pickers
    .new(opts, {
      prompt_title = "Select file to open",
      finder = finders.new_table({
        results = results,
      }),
      sorter = tele_conf.generic_sorter(opts),
      previewer = tele_conf.file_previewer(opts),
      attach_mappings = function(promt_bufnr)
        actions.select_default:replace(function()
          actions.close(promt_bufnr)
          local selection = action_state.get_selected_entry()
          util.smart_open(selection[1])
        end)
        return true
      end,
    })
    :find()
end

---@class TeleJqConfig
---@field file string? Optional file to search in. Tries to pick a sensible default.

-- TODO: Make this work!

---Search using jq
---@param opts TeleJqConfig?
M.jq = function(opts)
  local util = require("extra.util")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local tele_conf = require("telescope.config").values
  local make_entry = require("telescope.make_entry")
  local entry_display = require("telescope.pickers.entry_display")

  local tele_opts = {}
  opts = opts or {}

  local filepath = opts.file or util.get_current_file()
  local results = { "a", "b", "c" }

  pickers
    .new(tele_opts, {
      prompt_title = "Search",
      finder = finders.new_table({
        results = {
          { "red", "#ff0000" },
          { "green", "#00ff00" },
          { "blue", "#0000ff" },
        },
        entry_maker = function(entry)
          return {
            filename = filepath,
            lnum = entry[1]:len(),
            value = entry,
            display = entry[1],
            ordinal = entry[1],
          }
        end,
      }),
      sorter = tele_conf.generic_sorter(tele_opts),
      previewer = tele_conf.grep_previewer({}),
      sorting_strategy = "ascending",
      attach_mappings = function(promt_bufnr)
        actions.select_default:replace(function()
          actions.close(promt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.notify(vim.inspect(selection))
        end)
        return true
      end,
    })
    :find()
end

return M
