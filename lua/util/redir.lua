-- Port of romainl/vim-redir: redirect the output of a Vim or external
-- command into a scratch buffer. `:Redir <cmd>` captures an Ex command;
-- `:Redir !<cmd>` runs a shell command; `:Redir!` with no argument repeats
-- the last Ex command; a visual range before `:Redir !<cmd>` pipes the
-- selected lines into the shell command's stdin.
local function redir(opts)
  local cmd = vim.trim(opts.args or "")

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, is_scratch = pcall(vim.api.nvim_win_get_var, win, "redir_scratch")
    if ok and is_scratch then
      vim.api.nvim_win_close(win, true)
    end
  end

  if opts.bang and cmd == "" then
    cmd = vim.trim(vim.fn.expand("@:"))
  end

  local output
  if cmd:match("^!") then
    local ext_cmd = cmd:match("^!%s*(.*)")
    if ext_cmd:find(" %%") then
      local file = vim.fn.shellescape(vim.fn.escape(vim.fn.expand("%:p"), "\\"))
      ext_cmd = ext_cmd:gsub(" %%", " " .. file)
    end

    if not opts.range or opts.range == 0 then
      output = vim.fn.systemlist(ext_cmd)
    else
      local joined = table.concat(vim.fn.getline(opts.line1, opts.line2), "\n")
      output = vim.fn.systemlist(ext_cmd .. " <<< " .. vim.fn.shellescape(joined))
    end
  else
    local ok, result = pcall(vim.api.nvim_exec2, cmd, { output = true })
    if not ok then
      vim.notify("Redir: " .. result, vim.log.levels.ERROR)
      return
    end
    output = vim.split(result.output, "\n")
  end

  vim.cmd("vnew")
  vim.api.nvim_win_set_var(0, "redir_scratch", true)
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.buflisted = false
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end

vim.api.nvim_create_user_command("Redir", redir, {
  nargs = "?",
  complete = "command",
  bar = true,
  range = true,
  bang = true,
})
