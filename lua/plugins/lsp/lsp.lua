return {
  ----------------
  -- LSP-Config --
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Show load status
      { "j-hui/fidget.nvim", opts = {} },
      -- Mason
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      -- Conifg in lua.lua
      "folke/lazydev.nvim",
      "folke/neoconf.nvim",
    },
    ---@class PluginLspOpts
    opts = {
      capabilities = {},
      servers = {},
      -- Setup functions:
      --   Returns true if the server should not be setup with lspconfig.
      ---@type table<string, fun(opts: table): nil|boolean>
      setup = {
        lua_ls = function(_)
          -- Setup found at LazyDev plugin
          return false
        end,
        ruff = function(opts)
          opts.on_attach = function(client, bufnr)
            opts.on_attach(client, bufnr)
            if client.name == "ruff" then
              -- Disable hover in favor of Pyright
              client.server_capabilities.hoverProvider = false
            end
          end
        end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        opts.capabilities or {}
      )

      require("lspconfig.ui.windows").default_options.border = "rounded"
      require("mason").setup({
        ui = {
          border = "rounded",
        },
      })

      -- Apply default handler for mason
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server_opts = opts.servers[server_name] or {}
            server_opts.capabilities = vim.tbl_deep_extend(
              "force",
              {},
              vim.deepcopy(capabilities),
              server_opts.capabilities or {}
            )

            -- Run setup function
            if opts.setup[server_name] == nil or opts.setup[server_name](server_opts) ~= true then
              require("lspconfig")[server_name].setup(server_opts)
            end
          end,
        },
      })

      require("mason-tool-installer").setup({
        auto_update = false,
        run_on_start = true,
        start_delay = 1000,
        debounce_hours = 24,
        ensure_installed = {
          "eslint",
          "jsonls",
          "marksman",
          "pyright",
          "ruff",
          "lua-language-server",
          "shellcheck",
        },
      })
    end,
  },
}
