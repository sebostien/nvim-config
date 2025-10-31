-- TODO: Maybe change to https://github.com/nvim-mini/mini.pairs
return {
  "windwp/nvim-autopairs",
  tag = "0.10.0",
  event = "InsertEnter",
  opts = {
    disable_filetype = { "TelescopePrompt" },
    disable_in_macro = false, -- disable when recording or executing a macro
    ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
    check_ts = true, -- Check treesitter
  },
}
