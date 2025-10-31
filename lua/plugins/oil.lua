--- A file explorer that lets you edit your filesystem like a normal Neovim buffer.

local util = require("extra.util")

--- @param git_status_stdout string
--- @param git_ls_tree_stdout string
--- @return table<string, {index: string, working_tree: string}>
local parse_git_status = function(git_status_stdout, git_ls_tree_stdout)
  local status_lines = vim.split(git_status_stdout, "\n")

  --- @type table<string, {index: string, working_tree: string}>
  local status = {}

  for _, line in ipairs(status_lines) do
    local index_status_code = line:sub(1, 1)
    local working_status_code = line:sub(2, 2)
    local filename = line:sub(4)

    if vim.endswith(filename, "/") then
      filename = filename:sub(1, -2)
    end

    local dir_index = filename:find("/")
    if dir_index ~= nil then
      filename = filename:sub(1, dir_index - 1)

      if not status[filename] then
        status[filename] = {
          index = index_status_code,
          working_tree = working_status_code,
        }
      else
        if index_status_code ~= " " then
          status[filename].index = "M"
        end
        if working_status_code ~= " " then
          status[filename].working_tree = "M"
        end
      end
    else
      status[filename] = {
        index = index_status_code,
        working_tree = working_status_code,
      }
    end
  end

  for _, filename in ipairs(vim.split(git_ls_tree_stdout, "\n")) do
    if not status[filename] then
      -- In index but not modified
      status[filename] = { index = " ", working_tree = " " }
    end
  end

  return status
end

local function add_status_extmarks(oil, buffer, status)
  local namespace = vim.api.nvim_create_namespace("sn-oil-git-status")

  vim.api.nvim_buf_clear_namespace(buffer, namespace, 0, -1)

  if status then
    for n = 1, vim.api.nvim_buf_line_count(buffer) do
      local entry = oil.get_entry_on_line(buffer, n)
      if entry and entry.name ~= ".." then
        local name = entry.name

        local status_codes = status[name] or { index = "!", working_tree = "!" }

        if status_codes then
          vim.api.nvim_buf_set_extmark(buffer, namespace, n - 1, 0, {
            sign_text = status_codes.index,
            sign_hl_group = "OilGitStatusIndex",
            priority = 2,
          })
          vim.api.nvim_buf_set_extmark(buffer, namespace, n - 1, 0, {
            sign_text = status_codes.working_tree,
            sign_hl_group = "OilGitStatusWorkingTree",
            priority = 1,
          })
        end
      end
    end
  end
end

local function load_git_status(buffer, callback)
  local oil_url = vim.api.nvim_buf_get_name(buffer)
  local file_url = oil_url:gsub("^oil", "file")
  local path = vim.uri_to_fname(file_url)
  util.concurrent({
    function(cb)
      vim.system(
        { "git", "-c", "core.quotepath=false", "-c", "status.relativePaths=true", "status", ".", "--short" },
        { text = true, cwd = path },
        cb
      )
    end,
    function(cb)
      vim.system(
        { "git", "-c", "core.quotepath=false", "ls-tree", "HEAD", ".", "--name-only" },
        { text = true, cwd = path },
        cb
      )
    end,
  }, function(results)
    vim.schedule(function()
      local git_status_results = results[1]
      local git_ls_tree_results = results[2]

      if git_ls_tree_results.code ~= 0 or git_status_results.code ~= 0 then
        return callback()
      end

      callback(parse_git_status(git_status_results.stdout, git_ls_tree_results.stdout))
    end)
  end)
end

local function setup_oil_git_status()
  local oil = require("oil")

  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "oil" },

    callback = function()
      local buffer = vim.api.nvim_get_current_buf()
      local current_status = nil

      if vim.b[buffer].oil_git_status_started then
        return
      end

      vim.b[buffer].oil_git_status_started = true

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        buffer = buffer,

        callback = function()
          load_git_status(buffer, function(status)
            current_status = status
            add_status_extmarks(oil, buffer, current_status)
          end)
        end,
      })

      vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
        buffer = buffer,

        callback = function()
          if current_status then
            add_status_extmarks(oil, buffer, current_status)
          end
        end,
      })
    end,
  })

  vim.api.nvim_set_hl(0, "OilGitStatusIndex", { link = "DiagnosticSignInfo", default = true })
  vim.api.nvim_set_hl(0, "OilGitStatusWorkingTree", { link = "DiagnosticSignWarn", default = true })
end

return {
  {
    "stevearc/oil.nvim",
    version = "v2.15.0",
    event = { "VeryLazy" },
    dependencies = {
      { "nvim-mini/mini.icons" },
    },
    opts = {
      win_options = {
        signcolumn = "yes:2",
      },
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 8,
        max_width = 128,
      },
      keymaps = {
        ["<ESC>"] = "actions.close",
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["g."] = { "actions.toggle_hidden", mode = "n" },
      },
      use_default_keymaps = false,
      lsp_file_methods = {
        autosave_changes = true,
      },
    },
    config = function(_, opts)
      require("oil").setup(opts)
      setup_oil_git_status()
    end,
  },
}
