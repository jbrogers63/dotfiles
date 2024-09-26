runtime! debian.vim

syntax on
set background=dark

" filetype detection and settings
filetype on
filetype plugin on
filetype indent on

set nocompatible    " disable vi compatibility
set nobackup        " disable backup files
set tabstop=4       " Set a tab to 4 spaces
set shiftwidth=4    " Set indentation to 4 spaces
set expandtab       " Convert tabs to spaces
set scrolloff=10    " never show less than 10 lines of scrollback/scroll forward
set number          " Show line numbers
set directory=/tmp  " Set the working directory
set cursorline      " Highlight the current line
set showcmd         " Show (partial) command in status line.
"set autowrite      " Automatically save before commands like :next and :make
"set hidden         " Hide buffers when they are abandoned
"set mouse=a        " Enable mouse usage (all modes)

" search options
set incsearch       " highlight matching characters as typed
set showmatch       " Show matching brackets.
set ignorecase      " Do case insensitive matching
set smartcase       " Do smart case matching
set hlsearch        " use highlighting when searching

" Need to do the following in order to use vim-plug:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'
call plug#end()

