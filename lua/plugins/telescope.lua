local telescope = require("telescope")
local telescope_actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.setup({
  pickers = {
    buffers = {
      mappings = {
        n = { ["<M-d>"] = telescope_actions.delete_buffer },
        i = { ["<M-d>"] = telescope_actions.delete_buffer },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
    },
  },
})

telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")

-- Will show with git submodules
local builtin = require("telescope.builtin")
local function find_all_files()
  builtin.find_files({ no_ignore = true })
end

local opts = { noremap = true }
vim.keymap.set("n", "<space>ff", builtin.git_files, opts)
vim.keymap.set("n", "<space>fgs", builtin.find_files, opts)
vim.keymap.set("n", "<space>fF", find_all_files, opts)
vim.keymap.set("n", "<space>FF", find_all_files, opts)
vim.keymap.set("n", "<space>fg", builtin.live_grep, opts)
vim.keymap.set("n", "<space>fs", telescope.extensions.live_grep_args.live_grep_args, opts)
vim.keymap.set("n", "<space>b", function()
  builtin.buffers({ sort_mru = true })
end, opts)
vim.keymap.set("n", "<space>fh", builtin.help_tags, opts)
vim.keymap.set("n", "<space>fq", builtin.quickfix, opts)
vim.keymap.set("n", "<space>fQ", builtin.quickfixhistory, opts)
vim.keymap.set("n", "<space>FQ", builtin.quickfixhistory, opts)
