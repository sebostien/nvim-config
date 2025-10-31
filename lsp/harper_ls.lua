---@brief
---
--- https://github.com/automattic/harper
---
--- The language server for Harper, the slim, clean language checker for developers.
---
--- See our [documentation](https://writewithharper.com/docs/integrations/neovim) for more information on settings.
---
--- In short, they should look something like this:
--- ```lua
--- vim.lsp.config('harper_ls', {
---   settings = {
---     ["harper-ls"] = {
---       userDictPath = "~/dict.txt"
---     }
---   },
--- })
--- ```

return {
  cmd = { "harper-ls", "--stdio" },
  root_markers = { ".git" },
  settings = {
    ["harper-ls"] = {
      diagnosticseverity = "warning",
      userDictPath = vim.api.nvim_get_runtime_file("dict/words.txt", false)[1],
      linters = {
        AnotherThinkComing = true,
        BoringWords = true,
        NoOxfordComma = true,
        SpelledNumbers = true,
        UseGenitive = true,
        PossessiveNoun = true,
      },
      codeActions = { ForceStable = false },
      markdown = { IgnoreLinkTitle = false },
      diagnosticSeverity = "hint",
      isolateEnglish = false,
      dialect = "American",
      maxFileLength = 120000,
      ignoredLintsPath = "",
      excludePatterns = {},
    },
  },
}
