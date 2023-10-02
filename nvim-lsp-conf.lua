vim.opt.completeopt = {"menuone", "noinsert", "noselect"}

-- Avoid showing extra message when using completion
vim.opt.shortmess:append({ c = true })

local nvim_lsp = require('lspconfig')

local function lua_cmd(lua_funcs)
  return "<cmd>lua " .. lua_funcs .. "<CR>"
end

local function cur_buf()
  return bufnr or vim.api.nvim_get_current_buf()
end

local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(cur_buf(), ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(cur_buf(), ...) end

local builtin = require('telescope.builtin')

local on_attach = function(client)
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  local opts = { noremap=true }  --, silent=true
  buf_set_keymap("n", "K", lua_cmd("vim.lsp.buf.hover()"), opts)
  vim.keymap.set("n", "gd", builtin.lsp_definitions, {})
  buf_set_keymap("n", "gD", lua_cmd("vim.lsp.buf.declaration()"), opts)
  buf_set_keymap("n", "gi", lua_cmd("vim.lsp.buf.implementation()"), opts)
  buf_set_keymap("n", "<leader>gt", lua_cmd("vim.lsp.buf.type_definition()"), opts)
  vim.keymap.set("n", "gu", builtin.lsp_references, {})
  vim.keymap.set("n", "<space>o", builtin.lsp_document_symbols, {})
  vim.keymap.set("n", "<space>w", builtin.lsp_dynamic_workspace_symbols, {})
  buf_set_keymap("n", "<space>a", lua_cmd("vim.lsp.buf.code_action()"), opts)
  buf_set_keymap("n", "<F2>", lua_cmd("vim.lsp.buf.rename()"), opts)
  buf_set_keymap("n", "<c-k>", lua_cmd("vim.lsp.buf.signature_help()"), opts)
  buf_set_keymap("i", "<c-k>", lua_cmd("vim.lsp.buf.signature_help()"), opts)
  -- buf_set_keymap("n", "gd", lua_cmd("vim.lsp.buf.definition()"), opts)
  -- buf_set_keymap("n", "gu", lua_cmd("vim.lsp.buf.references()"), opts)
  -- buf_set_keymap("n", "<space>o", lua_cmd("vim.lsp.buf.document_symbol()"), opts)
  -- buf_set_keymap("n", "<space>w", lua_cmd("vim.lsp.buf.workspace_symbol()"), opts)

  if client.name == "clangd" then
    buf_set_keymap("n", "<F4>", ":ClangdSwitchSourceHeader<CR>", opts)
  end

  if client.server_capabilities.documentFormattingProvider then
    buf_set_keymap(
      "n", "<leader>rf",
      lua_cmd("vim.lsp.buf.format { async = true }"), opts
    )
  end
  if client.server_capabilities.documentRangeFormattingProvider then
    vim.keymap.set("v", "<leader>rs", vim.lsp.buf.format, { buffer=true })
  end

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec([[
      hi LspReferenceRead  cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      hi LspReferenceText  cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=LightYellow
    ]], false)

    local hi = "vim.lsp.buf.document_highlight()"
    local clear_hi = "vim.lsp.buf.clear_references()"

    buf_set_keymap("n", "<leader>h", lua_cmd(clear_hi..";"..hi), opts)
    buf_set_keymap("n", "<leader>H", lua_cmd(clear_hi), opts)

    -- pylsp is way too slow for taht feature:
    if client.name ~= "pylsp" then
      local vim_code = string.format([[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua %s
          autocmd CursorMoved <buffer> lua %s
        augroup END
      ]], hi, clear_hi)
      vim.api.nvim_exec(vim_code, false)
    end
  end

  vim.g.completion_matching_strategy_list = {"exact", "substirng", "fuzzy"}
  vim.g.completion_matching_smark_case = 1
end

nvim_lsp.clangd.setup {
  on_attach = on_attach,
  cmd = {
    "clangd",
    "--header-insertion=never",
    "--completion-style=detailed", "--clang-tidy",
  },
  filetypes = {"c", "cc", "cpp", "h", "hh", "hpp"},
}

nvim_lsp.pylsp.setup {
  on_attach = on_attach,
  filetypes = {"python"},
  plugins = {
    black = { enabled = true },
    yapf = { enabled = false },
    autopep8 = { enabled = false },
  }
}

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

-- Have a fixed column for the diagnostics to appear in
-- this removes ths jitter when warnings/errors flow in
vim.o.signcolumn = "yes"

-- To enable debug
-- vim.lsp.set_log_level("debug")

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- for `vsnip` users.
      -- require("luasnip").lsp_expand(args.body)  -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
      -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
      -- ['<C-Space>'] = cmp.mapping.complete(),
      -- ['<C-e>'] = cmp.mapping.abort(),
      -- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- completion-nvim
vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"}
vim.g.completion_matching_smart_case = 1
