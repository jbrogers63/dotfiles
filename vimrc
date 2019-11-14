runtime! debian.vim

syntax on
set background=dark

if has("autocmd")
  filetype plugin indent on
endif

set tabstop=4       " Set a tab to 4 spaces
set shiftwidth=4    " Set indentation to 4 spaces
set expandtab       " Convert tabs to spaces
set number          " Show line numbers
set showmatch       " Show matching brackets.
set ignorecase      " Do case insensitive matching
set backupdir=/tmp  " Set the backup directory
set directory=/tmp  " Set the working directory
set cursorline      " Highlight the current line
set showcmd         " Show (partial) command in status line.
"set smartcase      " Do smart case matching
"set incsearch      " Incremental search
"set autowrite      " Automatically save before commands like :next and :make
"set hidden         " Hide buffers when they are abandoned
"set mouse=a        " Enable mouse usage (all modes)


" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" Need to do the following in order to use vim-plug:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
Plug 'vim-ruby/vim-ruby'
call plug#end()

