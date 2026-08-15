-- nvim-treesitter's `main` branch (required for Nvim 0.12) dropped the old
-- `.configs`-based setup in favor of core Nvim's own treesitter features.
-- See :h treesitter-highlight / the plugin's README "Supported features".

require("nvim-treesitter").install({
  "bash",
  "c",
  "cmake",
  "cpp",
  "diff",
  "git_config",
  "gitcommit",
  "json",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "rust",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserTreesitter", {}),
  callback = function(ev)
    local ok = pcall(vim.treesitter.start, ev.buf)
    if ok then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
