---- Other ----
return {
  {
    "nvim-lua/plenary.nvim",
    priority = 9999,
  },

  -- Make stuff prettier
  "stevearc/dressing.nvim",
  {
    "rcarriga/nvim-notify",
    priority = 9997,
    config = function()
      local notify = require("notify")
      vim.notify = notify
      ---@diagnostic disable-next-line
      notify.setup({
        background_colour = "#0d1117",
        render = "compact",
        timeout = 10000,
        animation = "static",
      })
    end,
  },

  -- Indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "VeryLazy" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
        },
      },
    },
    main = "ibl",
  },

  {
    "echasnovski/mini.indentscope",
    event = { "VeryLazy" },
    config = function()
      local mini = require("mini.indentscope")

      mini.setup({
        symbol = "│",
        options = { try_as_border = true },
        draw = {
          animation = mini.gen_animation.quadratic({ easing = "out", duration = 10 }),
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
        },
        callback = function()
          ---@diagnostic disable-next-line
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- Undotree
  {
    "mbbill/undotree",
    keys = {
      { "<localleader>u", "<CMD>UndotreeToggle<CR>", desc = "UndoTree toggle" },
    },
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "VeryLazy",
    opts = {
      check_ts = true,
    },
  },

  -- Shortcuts for surrounding
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    version = "*",
    opts = {},
  },
}
