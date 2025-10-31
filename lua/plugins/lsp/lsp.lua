vim.lsp.config("*", {
  capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
    root_markers = { ".git" },
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  }),
})

vim.filetype.add({
  extension = {
    typ = "typst",
    lalrpop = "lalrpop",
    cheat = "cheat",
    jenkinsfile = "groovy",
    yuck = "yuck",
  },
  filename = {
    ["justfile"] = "just",
  },
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = vim.api.nvim_create_augroup("ts-highlight-enable-extra", { clear = true }),
  pattern = { "*.yuck" },
  command = "TSBufEnable highlight",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("sn-lsp-attach-keymap", { clear = true }),
  desc = "Setup LSP keymaps",
  callback = require("keymaps").set_lsp_buffer_keymaps,
})

return {
  {
    "mason-org/mason.nvim",
    tag = "v2.1.0",
    event = "VeryLazy",
    opts = { ui = { border = "rounded" } },
    config = function(_, opts)
      require("mason").setup(opts)
      vim.lsp.enable({ "jsonls", "ruff", "texlab", "svelte", "lua_ls" }, true)
    end,
  },
}
