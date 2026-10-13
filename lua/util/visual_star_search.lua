-- Port of http://got-ravings.blogspot.com/2008/07/vim-pr0n-visual-search-mappings.html
-- Makes * and # work on the visual selection instead of the word under the cursor,
-- and & set the search to the selection without jumping.

-- Returns a very-nomagic pattern matching the current visual selection literally,
-- then leaves visual mode. Reads the live selection via getregion(), since the
-- '< and '> marks aren't updated until visual mode is exited.
local function pattern_from_visual()
  local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
  local escaped = vim.fn.escape(table.concat(lines, "\n"), "\\/"):gsub("\n", "\\n")
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  return "\\V" .. escaped
end

local function set_search(pattern, forward)
  vim.fn.setreg("/", pattern)
  vim.fn.histadd("/", pattern)
  vim.v.searchforward = forward and 1 or 0
end

vim.keymap.set("x", "*", function()
  set_search(pattern_from_visual(), true)
  vim.api.nvim_feedkeys("`<n", "n", false)
end, { desc = "Search forward for selection" })

vim.keymap.set("x", "#", function()
  -- Start from the beginning of the selection so it doesn't match itself
  set_search(pattern_from_visual(), false)
  vim.api.nvim_feedkeys("`<n", "n", false)
end, { desc = "Search backward for selection" })

vim.keymap.set("x", "&", function()
  set_search(pattern_from_visual(), true)
  -- hlsearch state set inside a mapping callback is restored afterwards, so
  -- re-enable it from the typeahead instead.
  vim.api.nvim_feedkeys(vim.keycode("<Cmd>set hlsearch<CR>"), "n", false)
end, { desc = "Search for selection without jumping" })

-- Recursively vimgrep for the word under the cursor, or the selection
if vim.fn.maparg("<leader>*", "n") == "" then
  vim.keymap.set("n", "<leader>*", function()
    local word = vim.fn.substitute(vim.fn.escape(vim.fn.expand("<cword>"), "\\"), "\n", "\\\\n", "g")
    vim.cmd("noautocmd vimgrep /\\V" .. word .. "/ **")
  end)
end

if vim.fn.maparg("<leader>*", "v") == "" then
  vim.keymap.set("x", "<leader>*", function()
    vim.cmd("noautocmd vimgrep /" .. pattern_from_visual() .. "/ **")
  end)
end
