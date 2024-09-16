vim.filetype.add({
  extension = {
    typ = "typst",
    lalrpop = "lalrpop",
    cheat = "cheat",
    jenkinsfile = "groovy",
  },
  filename = {
    ["justfile"] = "just",
  },
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = vim.api.nvim_create_augroup("ts-highlight-enable-extra", { clear = true }),
  pattern = { "justfile", "*.yuck" },
  command = "TSBufEnable highlight",
})

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
      { "folke/lazydev.nvim", optional = true },
      { "folke/neoconf.nvim", optional = true },
      -- Config in rust.lua
      { "mrcjkb/rustaceanvim", optional = true },
    },
    ---@class PluginLspOpts
    opts = {
      capabilities = {},
      servers = {
        svelte = {
          filetypes = { "svelte", "html" },
        },
        texlab = {
          on_attach = function(_, bufnr)
            vim.o.wrap = true -- Wrap lines

            -- Save and build
            vim.keymap.set(
              "n",
              "<leader>b",
              "<CMD>write<CR><CMD>TexlabBuild<CR>",
              { bufnr = bufnr, desc = "Build Latex" }
            )

            -- Open pdf in zathura
            vim.keymap.set("n", "<localleader><enter>", function()
              local file = vim.fn.expand("%:r") .. ".pdf"
              vim.fn.execute("!zathura '" .. file .. "' &", "silent")
            end, { bufnr = bufnr, desc = "Open pdf in Zathura" })
          end,
          settings = {
            texlab = {
              rootDirectory = "./",
              auxDirectory = "./out/",
              build = {
                executable = "latexmk",
                args = {
                  "-shell-escape",
                  "-pdf",
                  "-interaction=nonstopmode",
                  "-synctex=1",
                  "-auxdir=./out/",
                  "%f",
                },
              },
            },
          },
        },
        harper_ls = {
          autostart = false,
          settings = {
            ["harper-ls"] = {
              diagnosticseverity = "information",
              userDictPath = "~/.config/nvim/dict/harper.txt",
              linters = {
                spell_check = true,
                spelled_numbers = true,
                an_a = true,
                sentence_capitalization = true,
                unclosed_quotes = true,
                wrong_quotes = true,
                long_sentences = true,
                repeated_words = true,
                spaces = true,
                matcher = true,
              },
            },
          },
        },
        ltex = {
          autostart = false,
          settings = {
            ltex = {
              diagnosticseverity = "information",
              checkFrequency = "save",
              language = "en-US",
              additionalRules = {
                enablePickyRules = true,
                motherTongue = "sv",
              },
            },
          },
        },
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        typst_lsp = {
          exportPdf = "onType",
        },
      },
      -- Setup functions:
      --   Returns true if the server should not be setup with lspconfig.
      ---@type table<string, fun(opts: table): nil|boolean>
      setup = {
        -- Setup found in rust.lua
        rust_analyzer = function(_)
          return true
        end,
        -- Setup found at haskell-tools plugin
        hls = function(_)
          return true
        end,
        lua_ls = function(_)
          -- Setup found at LazyDev plugin
          return false
        end,
        ruff_lsp = function(opts)
          opts.on_attach = function(client, bufnr)
            opts.on_attach(client, bufnr)
            if client.name == "ruff_lsp" then
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
            server_opts.capabilities =
              vim.tbl_deep_extend("force", {}, vim.deepcopy(capabilities), server_opts.capabilities or {})

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
        ensure_installed = require("conf").mason_install,
      })
    end,
  },
}
