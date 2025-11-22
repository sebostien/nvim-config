local util = require("extra.util")

local M = {}

---@class sn.InputOpts
---@field prompt (string|nil) Text of the prompt
---@field default string|nil Default reply to the input
---@field completion string|nil Specifies type of completion supported for input. Supported types are the same that can be supplied to a user-defined command using the "-complete=" argument. See |:command-completion|
---@field highlight function Function that will be used for highlighting user inputs.

-- TODO: Use this?
-- vim.api.nvim_buf_set_var(bufnr, "buftype", "prompt")
-- vim.fn.prompt_setprompt(bufnr, "Hello ")
-- vim.fn.prompt_setcallback(bufnr, function(input)
--   vim.notify("| " .. vim.inspect(input) .. " |")
--   on_confirm(input)
--   close_win()
-- end)

---@param opts sn.InputOpts Additional options. See |input()|
---@param on_confirm fun(input: string|nil): nil Called once the user confirms or abort the input. `input` is what the user typed (it might be an empty `string` if nothing was entered), or `nil` if the user aborted the dialog.
M.input = function(opts, on_confirm)
  local config = {
    win_config = {
      style = "minimal",
      relative = "cursor",
      title_pos = "left",
      height = 1,
      row = 1,
      col = 0,
      zindex = 999,
      border = "rounded",
    },
  }

  local prompt = opts.prompt or "Input"

  local win_config = vim.deepcopy(config.win_config)

  local default_value_width = opts.default and vim.str_utfindex(opts.default, "utf-16") or 0
  local input_width = 20 + default_value_width
  local prompt_width = vim.str_utfindex(prompt, "utf-16")

  win_config.width = math.min(math.max(input_width, prompt_width), 50)
  win_config.title = { { prompt, "SnInputTitle" } }

  local win = util.open_float_win(win_config, { opts.default or nil })

  if win == nil then
    on_confirm(nil)
    return
  end

  local cursor_col = opts.default and default_value_width + 1 or 0
  vim.cmd("startinsert")
  vim.api.nvim_win_set_cursor(win.win_id, { 1, cursor_col })
  local confirmed = false

  vim.keymap.set({ "n", "i", "v" }, "<cr>", function()
    local lines = vim.api.nvim_buf_get_lines(win.bufnr, 0, 1, false)
    if on_confirm then
      confirmed = true
      on_confirm(lines[1])
    end
    util.close_window(win.win_id)
  end, { buffer = win.bufnr })

  vim.api.nvim_create_autocmd({ "BufLeave", "InsertLeave" }, {
    buffer = win.bufnr,
    callback = function()
      util.close_window(win.win_id)
      if on_confirm and not confirmed then
        on_confirm(nil)
      end
    end,
  })
end

return M
