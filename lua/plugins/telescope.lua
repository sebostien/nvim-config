-- Telescope
--     Show Help:
--     - Insert mode: <c-/>
--     - Normal mode: ?
return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      { "folke/trouble.nvim" },
      { "nvim-lua/plenary.nvim", version = "" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    keys = {
      { "<localleader>ff", "<CMD>Telescope find_files<CR>", desc = "Find files" },
      { "<localleader>fg", "<CMD>Telescope git_files<CR>", desc = "Find tracked files" },
      { "<localleader>ft", "<CMD>Telescope live_grep<CR>", desc = "Live grep" },
      { "<localleader>fb", "<CMD>Telescope buffers<CR>", desc = "Search buffers" },
      { "<localleader>fh", "<CMD>Telescope command_history<CR>", desc = "Search command history" },
      { "<localleader>fs", "<CMD>Telescope grep_string<CR>", desc = "Live grep current word" },
      { "<localleader>fr", "<CMD>Telescope resume<CR>", desc = "Resume previous" },
      { "<localleader>fn", "<CMD>Telescope notify<CR>", desc = "Search notifications" },
      { "<localleader>fd", "<CMD>Telescope diagnostics<CR>", desc = "Search diagnostics" },
      { "<localleader>fo", "<CMD>Telescope oldfiles<CR>", desc = "Search recent files" },

      -- Help stuff
      { "<localleader>hh", "<CMD>Telescope help_tags<CR>", desc = "NeoVim help pages" },
      { "<localleader>hm", "<CMD>Telescope man_pages<CR>", desc = "man pages" },
      { "<localleader>hk", "<CMD>Telescope keymaps<CR>", desc = "Keymaps" },
    },
    opts = {
      defaults = {
        layout_strategy = "flex",
        layout_config = {
          horizontal = { preview_cutoff = 80, preview_width = 0.55 },
          vertical = { mirror = true, preview_cutoff = 25 },
          width = 0.87,
          height = 0.80,
        },
        mappings = {
          i = {
            ["<c-enter>"] = "to_fuzzy_refine",
          },
          n = {},
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local trouble = require("trouble.sources.telescope")
      opts.defaults.mappings.i["<c-t>"] = trouble.open
      opts.defaults.mappings.n["<c-t>"] = trouble.open

      telescope.setup(opts)

      -- Enable Telescope extensions if they are installed
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
