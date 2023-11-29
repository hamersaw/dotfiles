-- to install vim-plug: 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
-- reload vimrc and :PlugInstall

-- configure plugins
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'almo7aya/openingh.nvim'
Plug 'github/copilot.vim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'neovim/nvim-lspconfig'
Plug 'preservim/nerdtree'
Plug 'rhysd/git-messenger.vim'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
vim.call('plug#end')

--
-- git-messenger configuration
--

vim.g.git_messenger_no_default_mappings = true
vim.keymap.set('n', 'gm', ':GitMessenger<CR>', { noremap = true, silent = true })

--
-- lsp configuration
--

require("mason").setup()
require("mason-lspconfig").setup()

local on_attach = function(_, bufnr)
  -- mappings
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  --vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
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

--
-- nerdtree configuration
--

vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

--" Exit Vim if NERDTree is the only window remaining in the only tab.
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    command = "if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif"
})

--" Start NERDTree when Vim is started without file arguments.
vim.api.nvim_create_autocmd("StdinReadPre", {
    pattern = "*",
    command = "let s:std_in=1"
})
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "if argc() == 0 && !exists('s:std_in') | execute 'NERDTree' | endif"
})


--
-- netrw configuration
--

--vim.keymap.set('n', '<C-n>', ':Lexplore<CR>', { noremap = true, silent = true })
--vim.g.netrw_liststyle = 3
--vim.g.netrw_banner = 0
--vim.g.netrw_browse_split = 4
--vim.g.altv = 1
--vim.g.netrw_winsize = 15

-- Exit Vim if netrw is the only window remaining in the only tab.
--autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
-- Start netrw when Vim is started without file arguments.
--vim.api.nvim_create_autocmd("StdinReadPre", {
--    pattern = "*",
--    command = "let s:std_in=1"
--})
--vim.api.nvim_create_autocmd("VimEnter", {
--    pattern = "*",
--    command = "if argc() == 0 && !exists('s:std_in') | execute 'Lexplore' | endif"
--})

--
-- openingh configuration
--

vim.api.nvim_set_keymap("n", "gf", ":OpenInGHFile <CR>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("v", "gf", ":OpenInGHFileLines <CR>", { silent = true, noremap = true })

--
-- miscellaneous configuration
--

-- always use system clipboard
vim.opt.clipboard:append { 'unnamedplus' }

-- make tabs 4 spaces by default
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- make tab width 4 for go files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    command = "setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4"
})
