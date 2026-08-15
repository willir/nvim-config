vim.opt.completeopt = { "menuone", "noinsert", "noselect" }

-- Avoid showing extra message when using completion
vim.opt.shortmess:append({ c = true })

-- Have a fixed column for diagnostics so text doesn't jitter left/right
vim.opt.signcolumn = "yes"

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("clangd", {
  cmd = { "clangd", "--header-insertion=never", "--completion-style=detailed", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_markers = { ".clangd", "compile_commands.json", ".git" },
  capabilities = capabilities,
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  capabilities = capabilities,
})

vim.lsp.config("pylsp", {
  cmd = { "pylsp" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", ".git" },
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        black = { enabled = true },
        yapf = { enabled = false },
        autopep8 = { enabled = false },
      },
    },
  },
})

vim.lsp.enable({ "clangd", "rust_analyzer", "pylsp" })

local builtin = require("telescope.builtin")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local opts = { buffer = bufnr, noremap = true }

    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "gu", builtin.lsp_references, opts)
    vim.keymap.set("n", "<space>o", builtin.lsp_document_symbols, opts)
    vim.keymap.set("n", "<space>w", builtin.lsp_dynamic_workspace_symbols, opts)
    vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "i" }, "<c-k>", vim.lsp.buf.signature_help, opts)

    if client and client.name == "clangd" then
      vim.keymap.set("n", "<F4>", "<cmd>ClangdSwitchSourceHeader<CR>", opts)
    end

    if client and client:supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<leader>rf", function()
        vim.lsp.buf.format({ async = true })
      end, opts)
    end
    if client and client:supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("v", "<leader>rs", vim.lsp.buf.format, opts)
    end

    if client and client:supports_method("textDocument/documentHighlight") then
      vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "LightYellow" })
      vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "LightYellow" })
      vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "LightYellow" })

      vim.keymap.set("n", "<leader>h", function()
        vim.lsp.buf.clear_references()
        vim.lsp.buf.document_highlight()
      end, opts)
      vim.keymap.set("n", "<leader>H", vim.lsp.buf.clear_references, opts)

      -- pylsp is too slow for cursor-triggered highlight requests
      if client.name ~= "pylsp" then
        local hl_group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
          group = hl_group,
          buffer = bufnr,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
          group = hl_group,
          buffer = bufnr,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end
  end,
})
