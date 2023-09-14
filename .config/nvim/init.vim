" to install vim-plug: 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" reload vimrc and :PlugInstall

" configure plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'github/copilot.vim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'neovim/nvim-lspconfig'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
call plug#end()

"
" configure lsp
"

lua << EOF
require("mason").setup()
require("mason-lspconfig").setup()

local on_attach = function(_, bufnr)
  -- mappings
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
  --vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

  -- disable diagnostics
  vim.diagnostic.config {
    virtual_text = false,
    signs = false,
    underline = false,
  }
end

local cmp = require'cmp'
cmp.setup({
  completion = {
    autocomplete = false,
  },
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("mason-lspconfig").setup_handlers {
  function (server_name)
    require("lspconfig")[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
}
EOF

"
" NERDTree configuration
" "
map <C-t> :NERDTreeToggle<CR>
" Start NERDTree on vim start
"autocmd VimEnter * NERDTree
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | execute 'NERDTree' | endif

" 
" miscellaneous configuration
"

" always use system clipboard
set clipboard+=unnamedplus

" make tabs 4 spaces by default
set expandtab
set tabstop=4
set shiftwidth=4

" make tab width 4 for go files
autocmd FileType go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
