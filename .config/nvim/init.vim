" to install vim-plug: 'curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" reload vimrc and :PlugInstall

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
