" => General
syntax on                   "Syntax highlighting
filetype plugin indent on   "auto determine file type & plugin
set lazyredraw              "redraw only when necessary
let mapleader = ","
set t_Co=256                "Set color to 256

" => User Interface
colorscheme elflord
set background=dark         "Tells vim that the background is dark

set showmatch               "Show matching braces
set showmode                "Show current mode
set wildmenu                "better cmd-line completion
set showcmd                 "show partial commands

set mouse=r                 "Enable mouse a=all, v=visual, n=normal
set number                  "set line numbers
set noerrorbells            "no sound on error
set clipboard=unnamedplus,autoselect    "clipboard
set display+=uhex           "show unprintable chars as hex number
"clipboard support in visual mode
vmap <leader>y "+y
vmap <leader>p "+p
"Stop q: shortcut menu
map q: :q

" Vim shortcuts
" GoTo function - ctrl + ], ctrl+t goes back, need to generate tags on command line with ctags -R .

" => plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'       "For git plugins for vim-airline
Plug 'vim-airline/vim-airline'  "For pretty colors
Plug 'stevearc/vim-arduino'     "For arduino stuff
call plug#end()
" Airline
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#enabled = 1
set noshowmode              "hide bottom column

"save workspace
nnoremap sw :mksession! ~/.vim/work.vim
nnoremap rw :source! ~/.vim/work.vim
nnoremap sr :mksession! ~/.vim/ref.vim
nnoremap rr :source! ~/.vim/ref.vim
"switch buffers
nnoremap  <silent>   <tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bnext<CR>
nnoremap  <silent> <s-tab>  :if &modifiable && !&readonly && &modified <CR> :write<CR> :endif<CR>:bprevious<CR>

" => Search
set incsearch               "Incremental search
set hlsearch                "Highlight search
set ignorecase              "Ignore case in searching
"Turn off search hightlight with ,<space>
nnoremap <leader><space> :nohlsearch<CR>
"highlight extra spaces
highligh ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

" => Replacement
"When one of the chars is typed, the matching is typed and the cursor moves left
"inoremap ' ''<left>
"inoremap \" \""<left>
inoremap { {}<left>
inoremap ( ()<left>
inoremap [ []<left>

set expandtab               "Spaces instead of tabs
set shiftwidth=4            "1 tab = 4 spaces
set tabstop=4
set softtabstop=4

autocmd VimEnter * fixdel
set backspace=indent,eol,start "Fix backspace
" turn off page up/down
noremap <PageUp> <nop>
inoremap <PageUp> <nop>
nnoremap <PageUp> <nop>
noremap <PageDown> <nop>
inoremap <PageDown> <nop>
nnoremap <PageDown> <nop>

set textwidth=90    "In comments wrap at 90 chars, use gg, gqG, or shift+v lines and gq
set wrapmargin=2

set tags=./tags;,tags;./.tags;,.tags;

" => Spellcheck
" toggle with ,s, ]s fwd, [s bkwd, z= OR \s shows suggestions, zg adds word, zw removes
nmap <silent> <leader>s :set spell!<CR>
set spelllang=en_us         "Region
nnoremap \s a<C-X><C-S>

"Resize text
command! TF :call Textflow()
function! Textflow()
    :normal ggVG
    :normal gq
endfunction
