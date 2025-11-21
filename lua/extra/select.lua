local util = require("extra.util")

local M = {
  ---Force selects with these titles to be in the center
  FORCE_CENTER_TITLES = {
    ["Select Trouble Mode:"] = true,
  },
}

-- TODO: ?
-- local window = vim.api.nvim_list_uis()

---@param title string
---@param lines string[]
---@param kind string|nil
---@return table
local get_select_float_config = function(title, lines, kind)
  if M.FORCE_CENTER_TITLES[title] then
    kind = "center"
  end

  title = " " .. util.trim_space(title) .. " "

  local width = math.max(8, title:len() + 2)
  for _, v in ipairs(lines) do
    width = math.max(width, v:len() + 5)
  end

  width = math.min(width, 120, vim.o.columns)
  local height = math.min(#lines, vim.o.lines / 2)

  local relative = "cursor"
  local title_pos = "left"
  local row = 0
  local col = 0

  if kind == "center" then
    title_pos = "center"
    relative = "editor"
    row = math.floor(((vim.o.lines - height) / 2) - 1)
    col = math.floor((vim.o.columns - width) / 2)
  end

  return {
    relative = relative,
    title = { { title, "SnSelectTitle" .. relative } },
    title_pos = title_pos,
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    zindex = 998,
  }
end

---@class sn.SelectOpts<T>
---@field prompt (string|nil) Text of the prompt. Defaults to `Select one of:`
---@field format_item fun(item: T): string Function to format an individual item from `items`. Defaults to `tostring`.
---@field kind (string|nil) Arbitrary hint string indicating the item shape.

---@generic T
---@param items T[]
---@param opts sn.SelectOpts<T>
---@param on_choice fun(item: T|nil, idx: integer|nil) Called once the user made a choice. `idx` is the 1-based index of `item` within `items`. `nil` if the user aborted the dialog.
M.select = function(items, opts, on_choice)
  ---@type sn.SelectOpts
  opts = vim.tbl_deep_extend("force", {
    prompt = "Select one of:",
    format_item = tostring,
    kind = nil,
  }, opts)

  if vim.g.sn_debug then
    vim.notify("vim.ui.select called with: " .. vim.inspect(opts))
  end

  local formatted_items = util.map(items, opts.format_item)

  local float_conf = get_select_float_config(opts.prompt, formatted_items, opts.kind)

  local win = util.open_float_win(float_conf, formatted_items, true)

  if win == nil then
    return
  end

  vim.api.nvim_set_option_value("number", true, { win = win.win_id })

  ---@param choice integer|nil
  local function close_win(choice)
    return function()
      vim.api.nvim_buf_delete(win.bufnr, { force = true })
      util.close_window(win.win_id)
      if choice ~= nil and choice ~= 0 then
        on_choice(items[choice], choice)
      end
    end
  end

  for index, item in ipairs(formatted_items) do
    if index > 9 then
      break
    end

    vim.keymap.set("n", tostring(index), close_win(index), {
      noremap = true,
      desc = "Select alternative " .. item,
      buffer = win.bufnr,
    })
  end

  vim.keymap.set("n", "<Enter>", function()
    local line = vim.fn.getpos(".")[2]

    if line ~= nil and 0 < line and line <= #formatted_items then
      close_win(line)()
      return
    end

    vim.notify("Unexpected cursor line: " .. tostring(line))
  end)

  vim.keymap.set("n", "q", close_win(nil), {
    noremap = true,
    desc = "Abort selection",
    buffer = win.bufnr,
  })
  vim.keymap.set("n", "<Esc>", close_win(nil), {
    noremap = true,
    desc = "Abort selection",
    buffer = win.bufnr,
  })
end

M.select_buffers = function()
  -- vim.notify(vim.inspect(vim.api.nvim_list_bufs()))
  local bs = vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 })

  ---@type vim.fn.getbufinfo.ret.item[]
  local bufs = {}

  for _, value in ipairs(bs) do
    -- NOTE: Maybe filter something here?
    table.insert(bufs, value)
  end

  if #bufs <= 1 then
    vim.notify("Not enough buffers")
    return
  end

  M.select(bufs, {
    prompt = "Choose buffer",
    format_item = function(item)
      return item.name
    end,
    kind = "center",
  }, function(item, idx)
    if item ~= nil then
      if vim.g.sn_debug then
        print(vim.inspect(item))
        assert(item == bufs[idx])
      else
        vim.api.nvim_win_set_buf(0, item.bufnr)
      end
    else
      vim.notify("Aborted")
    end
  end)
end

return M
