" Use lua faster filetype detection system
let g:do_filetype_lua = 1

let g:loaded_netrw = 0
let g:loaded_netrwPlugin = 0

call plug#begin()
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'  " Some lua functions
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', {
\  'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
\}
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'  " for coloured icons
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'PeterRincker/vim-argumentative'
Plug 'qpkorr/vim-bufkill'
Plug 'will133/vim-dirdiff'
Plug 'tpope/vim-eunuch'  " :Rename
Plug 'tpope/vim-fugitive'  " Git
" Plug 'plasticboy/vim-markdown'
Plug 'machakann/vim-swap'
Plug 'troydm/zoomwintab.vim'  " Ctrl-W+O to zoom in
Plug 'antoinemadec/FixCursorHold.nvim'  " Workaround for slow CursorHold

" Color schemas
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'overcache/NeoSolarized'
Plug 'rakr/vim-one'
Plug 'drewtempelmeyer/palenight.vim'

" nvim-lsp:
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" For vsnip users
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'ojroques/nvim-lspfuzzy'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'mbbill/undotree'
call plug#end()

let mapleader = ","

" Themes
if (has("termguicolors"))
    set termguicolors
    colorscheme NeoSolarized
    set background=dark
endif


set tabstop=2
set expandtab
set shiftwidth=2
set hls  " Highlight all patters
set nu
set dir=~/.vim/swap-files/
" set laststatus=2  " Always display status line
set wildmode=longest,list,full  " Better tab in command mode
set wildmenu
set mouse=a  " mouse control
set confirm  " Confirm Y/N on close unsaved instead of error message

" Show wrapped lines:
set breakindent
set breakindentopt=sbr
set showbreak=↪>
" Side scrolls like a normal editor:
set sidescroll=1
" Starts scrolling near the edge instead of right at:
set scrolloff=3
set sidescrolloff=5
" if set nowrap display long lines and leading spaces
set list listchars=tab:>-,trail:.,precedes:<,extends:>

" Cursor will change depending on the mode
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor2
" Don't show mode in status line, so it can be used for more important stuff
set noshowmode

" FixCursorHold
let g:cursorhold_updatetime = 50

" Disable annoying folding in vim markdown
let g:vim_markdown_folding_disabled = 1

" ZoomWinTab
" ZoomWinTab disables regular <C-W>o to close other windows
" So let's declare a new one:
nnoremap <C-w><leader>O <C-W>o

" Remember and restore the cursor position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") < line("$") | exe "normal! g`\"" | endif

set colorcolumn=80

" Diff options, for better diffs:

set diffopt+=algorithm:histogram
set diffopt+=indent-heuristic

autocmd FileType python set cc=101 ts=4 sw=4
autocmd FileType cmake set cc=101 ts=4 sw=4
autocmd FileType cpp,c set cc=80

nmap <A-Home> ^
vmap <A-Home> ^
imap <A-Home> <ESC>^i
nnoremap <silent> <leader>/ :nohlsearch<CR>
nnoremap <leader>fc /<<<<<<<\\|\|\|\|\|\|\|\|\\|=======\\|>>>>>>><CR>
xnoremap x "0x
nnoremap dd "0dd
nnoremap D "0D
nnoremap dj "0dj

" Close function documentation window
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif

" Make Esc exit edit mode in the terminal mode
" tnoremap <Esc> <C-\><C-n>
tnoremap <expr> <C-\><C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

cnoremap <A-h> <Left>
cnoremap <A-j> <Down>
cnoremap <A-k> <Up>
cnoremap <A-l> <Right>

nnoremap <A-a> <C-a>
nnoremap <A-x> <C-x>
vnoremap <A-a> <C-a>
vnoremap <A-x> <C-x>
vnoremap g<A-a> g<C-a>
vnoremap g<A-x> g<C-x>

" Visaul select of what you've just pasted
nnoremap gp `[v`]

" Horizontal scroll:
nnoremap <C-L> zl
nnoremap <C-H> zh

nnoremap <leader>ss :mks! ~/.config/nvim/sessions/*.vim<C-D><BS><BS><BS><BS><BS>
nnoremap <leader>sr :so ~/.config/nvim/sessions/*.vim<C-D><BS><BS><BS><BS><BS>

nnoremap <silent> & :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <CR>

nnoremap <silent> <leader>t :NvimTreeToggle<CR>
nnoremap <silent> <leader>rt :NvimTreeFindFile!<CR>:NvimTreeFocus<CR>
nnoremap <silent> <leader>ft :NvimTreeFocus<CR>

" Next/Prev error:
nnoremap <silent> <leader>e :cbelow<CR>
nnoremap <silent> <leader>E :cabove<CR>

" Buffers (BufferLine in nvim-init.lua is used):
" nnoremap <silent> <C-Tab> :bn<CR>
" nnoremap <silent> <C-S-Tab> :bp<CR>

let g:BufKillCreateMappings = 0
nnoremap <silent> <leader>c :BW<CR>

" RipGrep with FZF:
function! s:p(bang, ...)
  let preview_window = get(g:, 'fzf_preview_window', a:bang && &columns >= 80 || &columns >= 120 ? 'right': '')
  if len(preview_window)
      return call('fzf#vim#with_preview', add(copy(a:000), preview_window))
  endif
  return {}
endfunction

" command! -bang -nargs=* Rg    call fzf#vim#grep('rg --column --line-number --no-heading --color=always     -- '.shellescape(<q-args>),                   1, s:p(<bang>0), <bang>0)
" command! -bang -nargs=* Rgu   call fzf#vim#grep('rg --column --line-number --no-heading --color=always -u  -- '.shellescape(<q-args>),                   1, s:p(<bang>0), <bang>0)
" command! -bang -nargs=* Rgi   call fzf#vim#grep('rg --column --line-number --no-heading --color=always -i  -- '.shellescape(<q-args>),                   1, s:p(<bang>0), <bang>0)
" command! -bang -nargs=* Rgiu  call fzf#vim#grep('rg --column --line-number --no-heading --color=always -iu -- '.shellescape(<q-args>),                   1, s:p(<bang>0), <bang>0)
" command! -bang -nargs=* Rgl   call fzf#vim#grep('rg --column --line-number --no-heading --color=always -u  -- '.shellescape(<q-args>).' '.expand('%:h'), 1, s:p(<bang>0), <bang>0)
" command! -bang -nargs=* Rglu  call fzf#vim#grep('rg --column --line-number --no-heading --color=always -u  -- '.shellescape(<q-args>).' '.expand('%:h'), 1, s:p(<bang>0), <bang>0)
" command! -bang -nargs=* Rgliu call fzf#vim#grep('rg --column --line-number --no-heading --color=always -iu -- '.shellescape(<q-args>).' '.expand('%:h'), 1, s:p(<bang>0), <bang>0)

" Files and Buffers with FZF:

runtime ./visual-star-search.vim

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction

com! DiffSaved call s:DiffWithSaved()

runtime nvim-init.lua
runtime nvim-lsp-conf.lua
