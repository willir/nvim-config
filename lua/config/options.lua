local opt = vim.opt

opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.hlsearch = true
opt.number = true
opt.directory = vim.fn.expand("~/.vim/swap-files/")
opt.wildmode = { "longest", "list", "full" }
opt.wildmenu = true
opt.mouse = "a"
opt.confirm = true

-- Show wrapped lines like a normal editor
opt.breakindent = true
opt.breakindentopt = "sbr"
opt.showbreak = "↪>"
opt.sidescroll = 1 -- side-scrolls instead of jumping a full screen
opt.scrolloff = 3 -- start scrolling near the edge instead of right at it
opt.sidescrolloff = 5
opt.list = true
opt.listchars = { tab = ">-", trail = ".", precedes = "<", extends = ">" }

-- Cursor shape changes depending on mode
opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor2"
-- Mode is redundant with the statusline plugin, so free up the space
opt.showmode = false

opt.colorcolumn = "80"

opt.diffopt:append({ "algorithm:histogram", "indent-heuristic" })

if vim.fn.has("termguicolors") == 1 then
  opt.termguicolors = true
  opt.background = "dark"
end

-- FixCursorHold.nvim
vim.g.cursorhold_updatetime = 50
