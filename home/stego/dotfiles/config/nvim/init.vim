" ---------------------------
" Base settings
" ---------------------------
set nocompatible            " disable old vi compatibility
set number                  " show line numbers
set relativenumber          " relative line numbers (useful for motions)
set cursorline              " highlight current line
set showcmd                 " show command in bottom bar
set showmode                " show current mode
set wildmenu                " visual autocomplete for command menu
set wildmode=longest:full,full
set ruler                   " show line/column in status line
set title                   " show filename in terminal title
set confirm                 " confirm before exiting unsaved

" ---------------------------
" Indentation
" ---------------------------
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab               " convert tabs to spaces
set smarttab
set shiftround              " round indent to multiple of shiftwidth

" ---------------------------
" Search
" ---------------------------
set hlsearch                " highlight matches
set incsearch               " incremental search
set ignorecase              " ignore case when searching...
set smartcase               " ...unless uppercase letters are used

" ---------------------------
" Visuals
" ---------------------------
syntax on
set background=dark         " better colors on dark terminal
set termguicolors           " enable true colors if supported
set scrolloff=5             " keep 5 lines visible when scrolling
set signcolumn=yes          " always show sign column

" ---------------------------
" Editing
" ---------------------------
set clipboard=unnamedplus   " use system clipboard
set hidden                  " allow buffers to be hidden without saving
set undofile                " persistent undo
set backspace=indent,eol,start

" ---------------------------
" Completion popup
" ---------------------------
set completeopt=menu,menuone,noselect   " show popup menu even for 1 match, no auto-select
set pumheight=10                        " limit height of popup menu
set shortmess+=c                        " avoid extra messages during completion

" ---------------------------
" Splits
" ---------------------------
set splitbelow              " split below
set splitright              " split right

" ---------------------------
" Keymaps (no plugins)
" ---------------------------
nnoremap <space> :nohlsearch<CR> " space clears search highlight
nnoremap <C-h> <C-w>h           " easier split navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
tnoremap <Esc> <C-\><C-n>       " leave terminal mode with Esc

" ---------------------------
" Statusline (basic)
" ---------------------------
set laststatus=2
set statusline=%f\ %y\ %m%r%h%w\ [%{&ff}]\ [%{&fileencoding}]\ [%{&fileformat}]\ %=%l/%L\ %c

