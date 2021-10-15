" to install vim-plug: 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" reload vimrc and :PlugInstall

" configure plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries dlv goimports godef golangci-lint gopls gorename guru' }
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

" configure vim-go plugin
let g:go_fmt_autosave = 0
let g:go_imports_autosave = 0
let g:go_mod_fmt_autosave = 0
let g:go_def_mapping_enabled = 0
let g:go_template_autocreate = 0
