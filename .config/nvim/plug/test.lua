-- vim-test
vim.g["test#strategy"] = "neovim_sticky"

-- keymap
vim.keymap.set("n", "<leader>tt", ":TestNearest<CR>")
vim.keymap.set("n", "<leader>tT", ":TestFile<CR>")
vim.keymap.set("n", "<leader>tl", ":TestLast<CR>")

