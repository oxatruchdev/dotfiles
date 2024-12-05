require("osmodiar16.core")
require("osmodiar16.lazy")

require("osmodiar16.setup.telescope-setup")
require("osmodiar16.setup.treesitter-setup")

require("lsp_signature").setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded",
  },
})
