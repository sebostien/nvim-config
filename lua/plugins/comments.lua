return {
  {
    "numToStr/Comment.nvim",
    tag = "v0.8.0",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        commit = "1b212c2eee76d787bbea6aa5e92a2b534e7b4f8f",
        opts = {
          enable_autocmd = false,
        },
      },
    },
    config = function(_, opts)
      require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = "^$",
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        opleader = {
          line = "gc",
          block = "gb",
        },
        extra = {
          above = "gcO",
          below = "gco",
          eol = "gcA",
        },
        mappings = {
          basic = true,
          extra = true,
          extended = false,
        },
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "folke/todo-comments.nvim",
    version = "v1.5.0",
    event = "VeryLazy",
    keys = {
      { "<localleader>tf", "<CMD>TodoTelescope<CR>", desc = "TODO Telescope" },
      { "<localleader>tt", "<CMD>TodoTrouble<CR>", desc = "TODO Trouble" },
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next TODO",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Prev TODO",
      },
    },
    opts = {
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "ISSUE" } },
        DONE = { icon = " ", color = "hint", signs = false },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },
}
