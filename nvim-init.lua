if vim.g.disable_treesitter ~= 1 then
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "all",
    ignore_install = { "jsonc", "blueprint", "t32", "fusion", "smali" },

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

local telescope = require("telescope")
local telescope_actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")

-- Telescope:
telescope.setup {
  pickers = {
    buffers = {
      mappings = {
        n = { ['<M-d>'] = telescope_actions.delete_buffer, },
        i = { ['<M-d>'] = telescope_actions.delete_buffer, },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      }
      -- layout_config = { mirror=true }, -- mirror preview pane
    },
  },
}
telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")

-- Will show with git submodules
local builtin = require('telescope.builtin')
local find_all_files = function() builtin.find_files({no_ignore=true, }) end

local opts = { noremap=true }
vim.keymap.set('n', '<space>ff', builtin.git_files, opts)
vim.keymap.set('n', '<space>fgs', builtin.find_files, opts)
vim.keymap.set('n', '<space>fF', find_all_files, opts)
vim.keymap.set('n', '<space>FF', find_all_files, opts)
vim.keymap.set('n', '<space>fg', builtin.live_grep, opts)
vim.keymap.set('n', '<space>fs', telescope.extensions.live_grep_args.live_grep_args, opts)
vim.keymap.set('n', '<space>b',  function() builtin.buffers { sort_mru = true, } end, opts)
vim.keymap.set('n', '<space>fh', builtin.help_tags, opts)
vim.keymap.set('n', '<space>fq', builtin.quickfix, opts)
vim.keymap.set('n', '<space>fQ', builtin.quickfixhistory, opts)
vim.keymap.set('n', '<space>FQ', builtin.quickfixhistory, opts)
-- /Telescope

vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>BufferLineCycleNext<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>m", "<cmd>BufferLineCyclePrev<CR>", opts)
vim.api.nvim_set_keymap("n", "<lt>N", "<cmd>BufferLineMoveNext<CR>", opts)
vim.api.nvim_set_keymap("n", "<lt>M", "<cmd>BufferLineMovePrev<CR>", opts)

vim.api.nvim_set_keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
