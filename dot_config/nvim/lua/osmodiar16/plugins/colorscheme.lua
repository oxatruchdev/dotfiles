return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
