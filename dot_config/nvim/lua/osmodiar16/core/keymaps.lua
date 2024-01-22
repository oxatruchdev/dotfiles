--########################################################
--CUSTOM KEYMAPS
--########################################################

-- set leader key to space
vim.g.mapleader = " "

-- Open file explorer
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, {desc = 'Open file explorer'})

-- Move selected text up and down with JK
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- Set cursor at the middle when navigating with C-d
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Copy to clipboard when we have something highlighted
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
