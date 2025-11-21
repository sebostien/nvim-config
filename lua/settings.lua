local o = vim.o

-- Debug my stuff
vim.g.sn_debug = false

o.background = "dark"
o.showmode = false
o.wrap = false
o.breakindent = false
o.inccommand = "split"
o.incsearch = true
o.termguicolors = true -- Correct terminal colors

-- Default: "!,'100,<50,s10,h"
o.shada = "!,'250,<50,s50,h"
o.history = 10000

o.swapfile = false
o.undodir = os.getenv("HOME") .. "/.vim/undodir"
o.undofile = true -- Sets undo to file

o.scrolloff = 8
o.signcolumn = "yes"
o.timeoutlen = 400 -- Cancel current key-combo
o.splitbelow = false
o.splitright = true
o.updatetime = 1000
o.wildmode = "list,full"
o.wildignorecase = true
o.pumheight = 12 -- Number of completions
o.ignorecase = true
o.smartcase = true

o.number = true
o.relativenumber = true
o.cursorlineopt = "number"

o.autoindent = true
o.expandtab = true
o.smarttab = true
o.smartindent = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 8

o.list = true
o.listchars = "tab:» ,trail:·,nbsp:␣"

-- UI
vim.ui.input = require("extra.input").input
vim.ui.select = require("extra.select").select

-- Remove mouse pop-up text
vim.cmd([[ aunmenu PopUp.How-to\ disable\ mouse ]])
vim.cmd([[ aunmenu PopUp.-1- ]])

-- Use Oil.nvim instead of netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.cmd([[ nnoremap \ :Oil <cr> ]])

-- Windows to close with "q"
vim.cmd([[ autocmd FileType vim,help,qf,lspinfo,gitsigns-blame nnoremap <buffer><silent> q :close<CR> ]])
vim.cmd([[ autocmd FileType man nnoremap <buffer><silent> q :quit<CR> ]])

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("sn-highlight-on-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

----------------------------------
--- Disable stuff on big files ---
----------------------------------

-- Lifted from https://github.com/folke/snacks.nvim

vim.filetype.add({
  pattern = {
    [".*"] = {
      function(path, buf)
        if not path or not buf or vim.bo[buf].filetype == "bigfile" then
          return
        end
        if path ~= vim.fs.normalize(vim.api.nvim_buf_get_name(buf)) then
          return
        end
        local size = vim.fn.getfsize(path)
        if size <= 0 then
          return
        end
        -- 2MB
        if size > 2 * 1024 * 1024 then
          return "bigfile"
        end
        local lines = vim.api.nvim_buf_line_count(buf)
        -- average line length > 1000
        return (size - lines) / lines > 1000 and "bigfile" or nil
      end,
    },
  },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("sn_bigfile", { clear = true }),
  pattern = "bigfile",
  callback = function(ev)
    local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ":p:~:.")
    vim.notify(("Big file detected `%s`."):format(path), vim.log.levels.INFO, { annote = "Big File" })
    vim.api.nvim_buf_call(ev.buf, function()
      local ctx = {
        buf = ev.buf,
        ft = vim.filetype.match({ buf = ev.buf }) or "",
      }

      if vim.fn.exists(":NoMatchParen") ~= 0 then
        vim.cmd([[NoMatchParen]])
      end

      vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local", win = 0 })
      vim.api.nvim_set_option_value("statuscolumn", "", { scope = "local", win = 0 })
      vim.api.nvim_set_option_value("conceallevel", 0, { scope = "local", win = 0 })

      vim.b.completion = false
      vim.b.minianimate_disable = true
      vim.b.minihipatterns_disable = true
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ctx.buf) then
          vim.bo[ctx.buf].syntax = ctx.ft
        end
      end)
    end)
  end,
})

----------------------------------
----------------------------------
----------------------------------
