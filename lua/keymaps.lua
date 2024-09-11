local util = require("extra.util")
local keymap = vim.keymap.set

vim.g.mapleader = " " -- Commands involving current buffer
vim.g.maplocalleader = "," -- Commands beyond buffer

-- Use CTRL+<hjkl> to switch between windows
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resize windows
keymap("n", "<C-Up>", "<CMD>resize -5<CR>")
keymap("n", "<C-Down>", "<CMD>resize +5<CR>")
keymap("n", "<C-Left>", "<CMD>vertical resize -5<CR>")
keymap("n", "<C-Right>", "<CMD>vertical resize +5<CR>")

-- Clear highlights
keymap("n", "<Esc>", "<CMD>nohlsearch<CR>")

-- Lazy
keymap("n", "<localleader>ll", "<CMD>Lazy<CR>")

-- Open pdf
keymap("n", "<localleader>op", function()
  util.telescope_files({ "%.pdf" }, "zathura")
end, { desc = "Open file in zathura" })

-- Move lines
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
keymap("x", "<A-j>", ":m '>+1<CR>gv-gv", { desc = "Move selected lines up" })
keymap("x", "<A-k>", ":m '<-2<CR>gv-gv", { desc = "Move selected lines down" })

-- Search replace word under cursor
keymap(
  "n",
  "<leader>rs",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Substitue word under cursor" }
)

-- Stay in visual mode when indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Preview image
keymap("n", "<localleader>i", util.preview_image, { desc = "Preview image under cursor or buffer" })

--------------------
-- [[ Yank/Put ]] --

-- Yank/put system clipboard
keymap("v", "<leader>y", '"+y')
keymap("n", "<leader>y", '"+y')
keymap("n", "<leader>Y", '"+Y') -- Yank to end of line
keymap("n", "<leader>p", '"+p')

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("sn-highlight-on-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Delete to void
keymap("n", "<leader>d", '"_d')
keymap("v", "<leader>d", '"_d')

-- Keep cursor in middle when paging
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Keep cursor in middle when searching
keymap("n", "n", "nzz")
keymap("n", "N", "Nzz")

keymap("n", "Q", "<nop>")

-- Disable arrow keys in normal mode
keymap("n", "<left>", '<cmd>echo "DON\'T!"<CR>')
keymap("n", "<right>", '<cmd>echo "DON\'T!"<CR>')
keymap("n", "<up>", '<cmd>echo "DON\'T!"<CR>')
keymap("n", "<down>", '<cmd>echo "DON\'T!"<CR>')

---------------
-- [[ LSP ]] --
---------------

keymap("n", "<localleader>lm", "<CMD>Mason<CR>", { desc = "Mason" })
keymap("n", "<localleader>lr", "<CMD>LspRestart<CR><CMD>e<CR>", { desc = "Restart lsp servers" })
keymap(
  "n",
  "<localleader>ls",
  "<CMD>LspStop<CR><CMD>lua vim.diagnostic.reset()<CR>",
  { desc = "Stop lsp servers" }
)
keymap("n", "<localleader>li", "<CMD>LspInfo<CR>", { desc = "LspInfo" })
keymap("n", "<leader>ls", "<CMD>LspStart harper_ls ltex<CR>", { desc = "Start LSP spellcheckers" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("sn-lsp-attach-keymap", { clear = true }),
  desc = "Setup LSP keymaps",
  ---@param event { buf: number, data: { client_id: number }}
  callback = function(event)
    ---@param keys string
    ---@param func string|fun()
    ---@param desc string
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local tele = require("telescope.builtin")

    map("<space>e", vim.diagnostic.open_float, "Open diagnostics float")
    map("[d", vim.diagnostic.goto_prev, "Go to prev diagnostics")
    map("]d", vim.diagnostic.goto_next, "Go to next diagnostics")

    -- Gotos
    -- See `:help vim.lsp.*`
    map("gr", tele.lsp_references, "Goto References")
    map("gd", tele.lsp_definitions, "Goto Definition")
    map("gD", vim.lsp.buf.declaration, "Go to declaration")
    map("gi", tele.lsp_implementations, "Goto Implementation")
    map("gt", tele.lsp_type_definitions, "Goto type definition")
    map("<leader>sd", tele.lsp_document_symbols, "Document Symbols")
    map("<leader>sw", tele.lsp_dynamic_workspace_symbols, "Workspace Symbols")

    -- Other
    -- Also at hovercraft plugin
    map("<leader>k", vim.lsp.buf.hover, "Hover documentation")
    map("<leader>K", vim.lsp.buf.signature_help, "Signature help")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")

    map("<leader>ca", vim.lsp.buf.code_action, "Code actions")
    map("<leader>cl", vim.lsp.codelens.run, "Codelens")

    -- Cursor highlight
    map("<leader>h", vim.lsp.buf.document_highlight, "Highlight symbol")
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      callback = vim.lsp.buf.clear_references,
    })

    -- Inlay hints
    if client ~= nil and client.server_capabilities.inlayHintProvider then
      map("<leader>i", function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
          { bufnr = bufnr }
        )
      end, "Toggle inlay hints")
    end
  end,
})
