if vim.g.disable_treesitter ~= 1 then
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",

    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<M-g>",
        node_incremental = "<M-g>",
        scope_incremental = "<M-s>",
        node_decremental = "gm",
      },
    },
    indent = { enable = true }
  }
end

-- This is already done in init.vim, at least I hope so:
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup()

require("lualine").setup {}
require("bufferline").setup {}

-- Telescope:
require("telescope").setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
require("telescope").load_extension("fzf")

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<space>ff', builtin.git_files, {})
vim.keymap.set('n', '<space>fF', builtin.find_files, {})
vim.keymap.set('n', '<space>FF', builtin.find_files, {})
vim.keymap.set('n', '<space>fg', builtin.live_grep, {})
vim.keymap.set('n', '<space>b',  builtin.buffers, {})
vim.keymap.set('n', '<space>fh', builtin.help_tags, {})
-- /Telescope

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>BufferLineCycleNext<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>m", "<cmd>BufferLineCyclePrev<CR>", opts)
vim.api.nvim_set_keymap("n", "<lt>N", "<cmd>BufferLineMoveNext<CR>", opts)
vim.api.nvim_set_keymap("n", "<lt>M", "<cmd>BufferLineMovePrev<CR>", opts)

vim.api.nvim_set_keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
