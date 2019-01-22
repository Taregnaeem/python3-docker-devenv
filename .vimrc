" Settings
set encoding=utf-8
set fileencoding=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set number
set cursorline
set cursorcolumn
set virtualedit=onemore
set visualbell
set showmatch
set laststatus=2
set clipboard=unnamed,autoselect
set title
set backspace=indent,eol,start
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
syntax on
    

" Mappings
noremap <S-h> ^
noremap <S-l> $
noremap z zz
inoremap jj <Esc>
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap gj j
vnoremap gk k
nnoremap : ;
nnoremap ; :
vnoremap : ;
vnoremap ; :


" Mappings For Emacs
noremap <C-h> X


" Color
colorscheme desert


" For Python
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4

