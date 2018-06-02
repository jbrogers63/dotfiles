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
"set showcmd        " Show (partial) command in status line.
"set smartcase      " Do smart case matching
"set incsearch      " Incremental search
"set autowrite      " Automatically save before commands like :next and :make
"set hidden         " Hide buffers when they are abandoned
"set mouse=a        " Enable mouse usage (all modes)


" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

