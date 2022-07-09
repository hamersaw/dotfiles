" to install vim-plug: 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" reload vimrc and :PlugInstall

" configure plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/vim-lsp'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
call plug#end()

" set NERDTree toggle keybind
map <C-n> :NERDTreeToggle<CR>

" always use system clipboard
set clipboard+=unnamedplus

" make tabs 4 spaces by default
set expandtab
set tabstop=4
set shiftwidth=4

" make tab width 4 for go files
autocmd FileType go setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4

" set lsp server configuration
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
