-- PackChanged hooks must be registered before vim.pack.add() triggers installs.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
      local cwd = ev.data.path
      vim.system({ "cmake", "-S.", "-Bbuild", "-DCMAKE_BUILD_TYPE=Release" }, { cwd = cwd }):wait()
      vim.system({ "cmake", "--build", "build", "--config", "Release" }, { cwd = cwd }):wait()
      vim.system({ "cmake", "--install", "build", "--prefix", "build" }, { cwd = cwd }):wait()
    end
  end,
})

vim.pack.add({
  -- Utility deps
  "https://github.com/nvim-lua/plenary.nvim",

  -- Fuzzy finder
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.x" },
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
  { src = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim", version = "v1.0.0" },

  -- UI
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/akinsho/bufferline.nvim",

  -- Editing
  "https://github.com/PeterRincker/vim-argumentative",
  "https://github.com/qpkorr/vim-bufkill",
  "https://github.com/will133/vim-dirdiff",
  "https://github.com/tpope/vim-eunuch", -- :Rename
  "https://github.com/tpope/vim-fugitive", -- Git
  "https://github.com/machakann/vim-swap",
  "https://github.com/troydm/zoomwintab.vim", -- Ctrl-W+O to zoom in
  "https://github.com/antoinemadec/FixCursorHold.nvim",
  "https://github.com/mbbill/undotree",

  -- Colorschemes
  { src = "https://github.com/dracula/vim", name = "dracula" },
  "https://github.com/overcache/NeoSolarized",
  "https://github.com/rakr/vim-one",
  "https://github.com/drewtempelmeyer/palenight.vim",

  -- Completion
  "https://github.com/hrsh7th/cmp-nvim-lsp",
  "https://github.com/hrsh7th/cmp-buffer",
  "https://github.com/hrsh7th/cmp-path",
  "https://github.com/hrsh7th/cmp-cmdline",
  "https://github.com/hrsh7th/nvim-cmp",
  "https://github.com/hrsh7th/cmp-vsnip", -- for vsnip users
  "https://github.com/hrsh7th/vim-vsnip",

  -- Treesitter (main branch: full rewrite, required for Nvim 0.12+)
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
}, { confirm = false })

if vim.fn.has("termguicolors") == 1 then
  vim.cmd.colorscheme("NeoSolarized")
end

require("plugins.nvim-tree")
require("plugins.telescope")
require("plugins.lualine")
require("plugins.bufferline")
require("plugins.cmp")
require("plugins.treesitter")
require("plugins.lsp")
