return {
  "Exafunction/codeium.vim",
  config = function()
    -- Change '<C-g>' here to any keycode you like.
    vim.g.codeium_disable_bindings = 1
    vim.keymap.set("i", "<C-y>", function()
      return vim.fn["codeium#Accept"]()
    end, { expr = true, silent = true })
  end,
}
