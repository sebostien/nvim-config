local util = require("extra.util")
local tele_util = require("extra.telescope_plugins")
local keymap = vim.keymap.set

local M = {}

vim.g.mapleader = " " -- Commands involving current buffer
vim.g.maplocalleader = "," -- Commands beyond buffer

-- Resize windows
keymap("n", "<C-Up>", "<CMD>resize -5<CR>")
keymap("n", "<C-Down>", "<CMD>resize +5<CR>")
keymap("n", "<C-Left>", "<CMD>vertical resize -5<CR>")
keymap("n", "<C-Right>", "<CMD>vertical resize +5<CR>")

-- Clear highlights
keymap("n", "<Esc>", "<CMD>nohlsearch<CR>")

-- Lazy
keymap("n", "<localleader>ll", "<CMD>Lazy<CR>")

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

-- Open file under "cursor"
keymap("n", "gx", util.smart_open, { desc = "Open file under cursor" })
keymap("v", "gx", util.smart_open, { desc = "Open file under cursor" })

-- Select buffer
keymap("n", "gB", require("extra.select").select_buffers, { desc = "Select buffer" })

-- Stay in visual mode when indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Preview image
keymap("n", "<localleader>i", util.preview_image, { desc = "Preview image under cursor or buffer" })

-- Render markdown
keymap("n", "<localleader>m", require("extra.render_markdown"), { desc = "Render markdown of file" })

-- Telescope
keymap("n", "<localleader>fp", tele_util.common_dirs, { desc = "Files in common dirs" })
keymap("n", "<localleader>fj", tele_util.jq, { desc = "jq" })

-------------------------
--- Yank/Put ------------

-- Yank/put system clipboard
keymap("v", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
keymap("n", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
keymap("n", "<leader>p", "\"+p", { desc = "Put from clipboard" })

-- Delete to void
keymap("n", "<leader>d", "\"_d")
keymap("v", "<leader>d", "\"_d")

-- Keep cursor in middle when paging
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Keep cursor in middle when searching
keymap("n", "n", "nzz")
keymap("n", "N", "Nzz")

keymap("n", "Q", "<nop>")

-------------------------
--- LSP -----------------

vim.api.nvim_create_user_command("LspInfo", function()
  vim.cmd({ cmd = "checkhealth", args = { "vim.lsp" } })
end, {})
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd({ cmd = "edit", args = { vim.fn.expand("~/.local/state/nvim/lsp.log") } })
end, {})
keymap("n", "<localleader>lm", "<CMD>Mason<CR>", { desc = "Mason" })
keymap("n", "<localleader>lr", function()
  for _, lsp in ipairs(vim.lsp.get_clients()) do
    vim.notify(lsp.name)
    vim.lsp.enable(lsp.name, false)
  end
  vim.diagnostic.reset()
  vim.lsp.enable(require("conf").enabled_lsp_clients, true)
end, { desc = "Restart lsp servers" })
keymap("n", "<localleader>ls", function()
  for _, lsp in ipairs(vim.lsp.get_clients()) do
    vim.lsp.enable(lsp.name, false)
  end
  vim.diagnostic.reset()
end, { desc = "Stop lsp servers" }) -- TODO: Fix
keymap("n", "<leader>ls", function()
  vim.lsp.enable("harper_ls", true)
end, { desc = "Start LSP spellcheckers" })

---@param event { buf: number, data: { client_id: number }}
M.set_lsp_buffer_keymaps = function(event)
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
  map("[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, "Go to prev diagnostics")
  map("]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, "Go to next diagnostics")

  -- Gotos
  -- See `:help vim.lsp.*`
  map("gr", tele.lsp_references, "Goto References")
  map("gd", tele.lsp_definitions, "Goto Definition")
  map("gD", vim.lsp.buf.declaration, "Go to declaration")
  map("gi", tele.lsp_implementations, "Goto Implementation")
  map("gt", tele.lsp_type_definitions, "Goto type definition")
  map("<leader>sd", tele.lsp_document_symbols, "Document Symbols")
  map("<leader>sw", tele.lsp_dynamic_workspace_symbols, "Workspace Symbols")

  -- Hover
  local hover = vim.lsp.buf.hover
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.hover = function()
    return hover({
      border = "rounded",
      max_width = math.floor(vim.o.columns * 0.7),
      max_height = math.floor(vim.o.lines * 0.7),
    })
  end
  map("K", vim.lsp.buf.hover, "Hover")

  local signature = vim.lsp.buf.signature_help
  map("<leader>k", function()
    return signature({
      border = "rounded",
      max_width = math.floor(vim.o.columns * 0.7),
      max_height = math.floor(vim.o.lines * 0.7),
    })
  end, "Signature help")
  map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")

  -- Other
  vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, { buffer = event.buf, desc = "LSP: Code actions" })
  map("<leader>ca", vim.lsp.buf.code_action, "Code actions")
  map("<leader>cl", vim.lsp.codelens.run, "Codelens")
  map("<leader>cL", vim.lsp.codelens.refresh, "Refresh Codelens")

  -- Cursor highlight
  map("<leader>h", vim.lsp.buf.document_highlight, "Highlight symbol")
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = event.buf,
    callback = vim.lsp.buf.clear_references,
  })

  -- Inlay hints
  if client ~= nil and client.server_capabilities.inlayHintProvider then
    map("<leader>i", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, "Toggle inlay hints")
  end
end

return M
