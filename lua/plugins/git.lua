return {
  -- Git decorations
  {
    "lewis6991/gitsigns.nvim",
    version = "v1.0.2",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signs_staged_enable = true,
      current_line_blame_opts = {
        delay = 100,
        ignore_whitespace = true,
      },
      -- TODO: Maybe need to reduce this
      max_file_length = 100000, -- Disable if file is longer than this (in lines).
      preview_config = { border = "rounded", row = -1 },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        ---@param mode string|string[]
        ---@param keys string
        ---@param func string|fun()
        ---@param desc string
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "Git: " .. desc })
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, "Goto next hunk")
        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "Goto prev hunk")

        -- Actions
        map("n", "<localleader>gha", gitsigns.stage_hunk, "Stage hunk")
        map("n", "<localleader>ghr", gitsigns.reset_hunk, "Reset hunk")

        map("v", "<localleader>gha", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk")
        map("v", "<localleader>ghr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk")

        map("n", "<localleader>ga", gitsigns.stage_buffer, "Stage file")
        map("n", "<localleader>gr", gitsigns.reset_buffer, "Unstage file")
        map("n", "<localleader>ghp", gitsigns.preview_hunk, "Show hunk popup")
        map("n", "<localleader>ghi", gitsigns.preview_hunk_inline, "Show hunk inline")

        map("n", "<localleader>gb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame line")

        map("n", "<localleader>gt", function()
          gitsigns.diffthis(nil, { vertical = true })
        end, "Diff file")

        map("n", "<localleader>ghQ", function()
          gitsigns.setqflist("all")
        end, "Show all hunks in Trouble")
        map("n", "<localleader>ghq", gitsigns.setqflist, "Show buffer hunks in Trouble")

        -- Toggles
        map("n", "<localleader>gd", gitsigns.toggle_deleted, "Toggle inline deleted")
        map("n", "<localleader>gB", gitsigns.blame, "Toggle blame")
        map("n", "<localleader>gl", gitsigns.toggle_current_line_blame, "Toggle inline blame")
        map("n", "<localleader>gw", gitsigns.toggle_word_diff, "Toggle word diff")

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
      end,
    },
  },
}
