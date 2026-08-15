-- Port of http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html
-- Makes * and # work on the visual selection instead of the word under the cursor.

local function set_search_from_visual(cmdtype)
  local reg_s_backup = vim.fn.getreg("s")
  vim.cmd('normal! gv"sy')
  local selected = vim.fn.getreg("s")
  local escaped = vim.fn.substitute(vim.fn.escape(selected, cmdtype .. "\\"), "\n", "\\\\n", "g")
  vim.fn.setreg("/", "\\V" .. escaped)
  vim.fn.setreg("s", reg_s_backup)
end

vim.keymap.set("x", "*", function()
  set_search_from_visual("/")
  vim.fn.feedkeys("/" .. vim.fn.getreg("/") .. "\r")
end)

vim.keymap.set("x", "#", function()
  set_search_from_visual("?")
  vim.fn.feedkeys("?" .. vim.fn.getreg("/") .. "\r")
end)

-- Recursively vimgrep for the word under the cursor, or the selection
if vim.fn.maparg("<leader>*", "n") == "" then
  vim.keymap.set("n", "<leader>*", function()
    local word = vim.fn.substitute(vim.fn.escape(vim.fn.expand("<cword>"), "\\"), "\n", "\\\\n", "g")
    vim.cmd("noautocmd vimgrep /\\V" .. word .. "/ **")
  end)
end

if vim.fn.maparg("<leader>*", "v") == "" then
  vim.keymap.set("x", "<leader>*", function()
    set_search_from_visual("/")
    vim.cmd("noautocmd vimgrep /" .. vim.fn.getreg("/") .. "/ **")
  end)
end
