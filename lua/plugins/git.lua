local blame_full = function()
  package.loaded.gitsigns.blame_line({ full = true })
end

return {
  -- Git decorations
  {
    "lewis6991/gitsigns.nvim",
    version = "v0.9.0",
    lazy = false,
    keys = {
      { "<localleader>gt", "<CMD>Gitsigns diffthis<CR>", desc = "Git toggle diff" },
      { "<localleader>gd", "<CMD>Gitsigns toggle_deleted<CR>", desc = "Git toggle inline deleted" },
      { "<localleader>gb", blame_full, desc = "Git blame line" },
    },
    opts = {
      signs = {
        untracked = { text = " " },
      },
    },
  },
  {
    "tpope/vim-fugitive",
    keys = {
      { "<localleader>gs", "<CMD>Git<CR>", desc = "Fugitive git status" },
    },
  },
}
