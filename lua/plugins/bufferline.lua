require("bufferline").setup({})

local opts = { noremap = true }
vim.keymap.set("n", "<leader>n", "<cmd>BufferLineCycleNext<CR>", opts)
vim.keymap.set("n", "<leader>m", "<cmd>BufferLineCyclePrev<CR>", opts)
vim.keymap.set("n", "<N", "<cmd>BufferLineMoveNext<CR>", opts)
vim.keymap.set("n", "<M", "<cmd>BufferLineMovePrev<CR>", opts)
