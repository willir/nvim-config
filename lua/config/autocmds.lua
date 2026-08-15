local augroup = vim.api.nvim_create_augroup("UserConfig", {})

-- Remember and restore the cursor position (skip commit messages)
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    if vim.fn.expand("%"):match("%.git[/\\]COMMIT_EDITMSG$") then
      return
    end
    local mark = vim.fn.line("'\"")
    if mark > 1 and mark < vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "python", "cmake" },
  callback = function()
    vim.opt_local.colorcolumn = "101"
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.colorcolumn = "80"
  end,
})

-- Close the function-signature/documentation popup once you're done with it
vim.api.nvim_create_autocmd({ "InsertLeave", "CompleteDone" }, {
  group = augroup,
  callback = function()
    if vim.fn.pumvisible() == 0 then
      pcall(vim.cmd, "pclose")
    end
  end,
})
