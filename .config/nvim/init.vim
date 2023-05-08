" to install vim-plug: 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" reload vimrc and :PlugInstall

" configure plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'github/copilot.vim'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
call plug#end()

" tab completion
inoremap <expr> <S-Tab>   pumvisible() ? "\<C-n>" : "\<S-Tab>"
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" disable popup by default - but open on tab
let g:asyncomplete_auto_popup = 0

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <S-TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<S-TAB>" :
  \ asyncomplete#force_refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"
" lsp server configuration
"
function! s:on_lsp_buffer_enabled() abort
    setlocal signcolumn=no
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    "nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    "nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_diagnostics_enabled = 0
    let g:lsp_diagnostics_highlights_enabled = 0
    let g:lsp_diagnostics_virtual_text_enabled = 0

    let g:lsp_document_highlight_enabled = 0
    let g:lsp_document_code_action_signs_enabled = 0

    let g:lsp_fold_enabled = 0
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

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
