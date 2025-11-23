vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})

return {
  {
    "mfussenegger/nvim-lint",
    commit = "baf7c91c2b868b12446df511d4cdddc98e9bf66e",
    event = "VeryLazy",
    keys = {
      {
        "<leader>lc",
        function()
          require("lint").try_lint("cspell")
        end,
        desc = "Spellcheck",
      },
      {
        "<localleader>lc",
        function()
          local linters = require("lint").get_running()
          if #linters == 0 then
            vim.notify("No linters running")
          else
            vim.notify("󱉶 \n" .. table.concat(linters, "\n"))
          end
        end,
        desc = "Running linters",
      },
    },
    config = function()
      require("lint").linters.jq = {
        name = "jq",
        cmd = "jq",
        stdin = true,
        ignore_exitcode = true,
        stream = "stderr",
        parser = require("lint.parser").from_pattern(
          "jq: parse (.+): (.+) at line (%d+), column (%d+)",
          { "code", "message", "lnum", "col" }
        ),
      }

      require("lint").linters_by_ft = {
        json = { "jq" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        haskell = { "hlint" },
        markdown = { "markdownlint" },
      }
    end,
  },
}
