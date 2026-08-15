local map = vim.keymap.set

-- ZoomWinTab disables the regular <C-W>o to close other windows, restore it
map("n", "<C-w><leader>O", "<C-W>o")

map("n", "<A-Home>", "^")
map("v", "<A-Home>", "^")
map("i", "<A-Home>", "<ESC>^i")

map("n", "<leader>/", ":nohlsearch<CR>", { silent = true })

-- Jump to the next git conflict marker (also matches diff3 "|||||||")
-- Original config's version of this pattern was a broken regex; fixed here.
map("n", "<leader>fc", [[/^<<<<<<<\|^=======\|^>>>>>>>\|^|||||||<CR>]])

-- Delete without clobbering the unnamed register
map("x", "x", '"0x')
map("n", "dd", '"0dd')
map("n", "D", '"0D')
map("n", "dj", '"0dj')

-- Make Esc exit edit mode in terminal mode, but keep this variant for
-- pasting a register while returning to insert mode
map("t", "<C-\\><C-R>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })

map("i", "<A-h>", "<Left>")
map("i", "<A-j>", "<Down>")
map("i", "<A-k>", "<Up>")
map("i", "<A-l>", "<Right>")

map("c", "<A-h>", "<Left>")
map("c", "<A-j>", "<Down>")
map("c", "<A-k>", "<Up>")
map("c", "<A-l>", "<Right>")

map("n", "<A-a>", "<C-a>")
map("n", "<A-x>", "<C-x>")
map("v", "<A-a>", "<C-a>")
map("v", "<A-x>", "<C-x>")
map("v", "g<A-a>", "g<C-a>")
map("v", "g<A-x>", "g<C-x>")

-- Visually select what you've just pasted
map("n", "gp", "`[v`]")

-- Horizontal scroll
map("n", "<C-L>", "zl")
map("n", "<C-H>", "zh")

-- Session save/restore, using cmdline <C-D> completion to expand the glob
map("n", "<leader>ss", ":mks! ~/.config/nvim/sessions/*.vim<C-D><BS><BS><BS><BS><BS>")
map("n", "<leader>sr", ":so ~/.config/nvim/sessions/*.vim<C-D><BS><BS><BS><BS><BS>")

-- Search for the word under the cursor, keeping it in the search register
map("n", "&", [[:let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <CR>]], { silent = true })

map("n", "<leader>t", ":NvimTreeToggle<CR>", { silent = true })
map("n", "<leader>rt", ":NvimTreeFindFile!<CR>:NvimTreeFocus<CR>", { silent = true })
map("n", "<leader>ft", ":NvimTreeFocus<CR>", { silent = true })

-- Next/prev quickfix error
map("n", "<leader>e", ":cbelow<CR>", { silent = true })
map("n", "<leader>E", ":cabove<CR>", { silent = true })

vim.g.BufKillCreateMappings = 0
map("n", "<leader>c", ":BW<CR>", { silent = true })
