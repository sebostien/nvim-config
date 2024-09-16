local indent_guide_ft_disable = {
  "help",
  "neo-tree",
  "Trouble",
  "lazy",
  "mason",
  "notify",
}

---- Other ----
return {
  -- Make stuff prettier
  {
    "stevearc/dressing.nvim",
    version = "v2.2.2",
    opts = {},
  },
  {
    "rcarriga/nvim-notify",
    priority = 9997,
    version = "v3.13.5",
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

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "VeryLazy" },
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
      exclude = {
        filetypes = indent_guide_ft_disable,
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    version = "v0.13.0",
    event = { "VeryLazy" },
    config = function()
      local mini = require("mini.indentscope")

      mini.setup({
        symbol = "│",
        options = { try_as_border = true },
        draw = {
          animation = mini.gen_animation.none(),
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = indent_guide_ft_disable,
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
    commit = "ffc139f",
    event = "VeryLazy",
    opts = {
      check_ts = true,
    },
  },

  -- Shortcuts for surrounding
  {
    "echasnovski/mini.surround",
    version = "v0.13.0",
    event = "VeryLazy",
    opts = {},
  },
}
