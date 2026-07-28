
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" disables vi compatibility
set nocompatible

" will try to detect the filetype
filetype on
filetype plugin on " enable compatible plugins
"filetype indent on " enable indent file for

syntax on

colorscheme molokai

set number

set shiftwidth=4    " width 4 shifts
set tabstop=4       " width 4 tabs
set softtabstop=4   
set expandtab       " use space chars for tabs

set incsearch       " highlight chars while searching

set wildmenu        " tab autocomplete
set wildmode=list:longest   " similar to bash
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx


" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')



call plug#end()

" }}}

" MAPPINGS --------------------------------------------------------------- {{{

" make new lines without entering insert mode 
nnoremap o o<esc>
nnoremap O O<esc>
" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

set statusline=

set statusline+=\ %F\ %M\ %Y\ %R
" divides left and right sides 
set statusline+=%=
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

"shows status on second to last line:
set laststatus=2

" }}}

