" configure plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
call plug#end()

" set NERDTree toggle keybind
map <C-n> :NERDTreeToggle<CR>

" always use system clipboard
set clipboard+=unnamedplus

" make tabs 4 spaces
set expandtab
set tabstop=4
set shiftwidth=4
