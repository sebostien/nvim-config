return {
  "MagicDuck/grug-far.nvim",
  tag = "1.6.53",
  opts = { headerMaxWidth = 80 },
  cmd = { "GrugFar", "GrugFarWithin" },
  keys = {
    {
      "<localleader>r",
      function()
        local cfile = vim.fn.expand("<cfile>")
        require("grug-far").open({
          transient = true,
          prefills = {
            search = cfile,
            replacement = cfile,
            flags = "--ignore-case",
          },
        })
      end,
      mode = { "n", "x" },
      desc = "Search and Replace",
    },
  },
}
