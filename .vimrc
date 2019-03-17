" vi: set foldtext=MyCommentBlockFold():
" Author : Bryan Brady

source $HOME/.vim/bb/functions.vim

"------------------------------------------------------------------------------------------------{{{
" Plugins
"---------------------------------------------------------------------------------------------------
call plug#begin('~/.vim/plugs')
Plug 'kien/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
"Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
"Plug 'tpope/vim-repeat'
"Plug 'tpope/vim-speeddating'
Plug 'ntpeters/vim-better-whitespace'
Plug 'vim-scripts/taglist.vim'
Plug 'vim-airline/vim-airline'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'moll/vim-bbye'
Plug 'jgdavey/tslime.vim'

" Haskell
"Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
"Plug 'eagletmt/ghcmod-vim', { 'for': 'haskell' }
"Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
"Plug 'mpickering/hlint-refactor-vim', { 'for': 'haskell' }

" This plugin changes the buffer position when multiple buffers are open
" Use %!stylish-haskell instead
" Plug 'nbouscal/vim-stylish-haskell'

" Syntax
Plug 'JuliaEditorSupport/julia-vim'
Plug 'nhooyr/vim-markdown-folding'
"Plug 'LnL7/vim-nix'
"Plug 'purescript-contrib/purescript-vim'

" Colorscheme
Plug 'vim-scripts/wombat256.vim'

" My stuff
Plug 'bryanbrady/vim-airline-themes'
Plug 'git@bitbucket.org:bryanbrady/vim-all-cmd'

call plug#end()
"}}}

"------------------------------------------------------------------------------------------------{{{
" Global
"---------------------------------------------------------------------------------------------------

let g:LargeFile=4
if !exists("autocommands_loaded")
    let autocommands_loaded = 1


    let largeFileSize = 1024 * 1024 * g:LargeFile
    augroup LargeFile
      autocmd BufReadPre * let f=expand("<afile>") |
            \if getfsize(f) > largeFileSize |
            \set eventignore+=FileType |
            \setlocal noswapfile bufhidden=unload undolevels=-1 |
            \else |
            \set eventignore-=FileType |
            \endif
    augroup END

endif

let mapleader=" "
" }}}

"------------------------------------------------------------------------------------------------{{{
" Options
"---------------------------------------------------------------------------------------------------

set noerrorbells                       " No audible bell
set vb t_vb=                           " No audible bell

set confirm                            " Confirm unsaved changes
set noswapfile                         " No swapfile
set nocompatible                       " No vi compatibility.
set hidden
syntax on                              " Enable syntax highlighting
filetype plugin indent on              " Use auto indents


set number                             " Show line numbers

set nowrap                             " Don't wrap lines longer than window
set ignorecase                         " Ignore case in searches by default
set smartcase

set autoindent                         " Use auto indents
set smartindent                        " Smartly
set expandtab                          " Set indents to 2 spaces
set tabstop=2                          " Set indents to 2 spaces
set shiftwidth=2                       " Set indents to 2 spaces
set smarttab                           " Remove shiftwidth spaces when operating on a blank line

set showmatch                          " Show matching brace when typing a closing brace
set incsearch                          " Perform search while typing
set hlsearch                           " Highlight matches

set scrolloff=1                        " Include 1 line of context when searching
set showtabline=1                      " Show list of open tabs when two or more are open

set splitright                         " New splits to the right
set splitbelow                         " New splits below
set equalalways                        " Always keep windows equally sized

if v:version >= 730
  set undofile                         " Save undo history to a file
  set undodir=~/.vim/undo              " In this directory
  set undoreload=10000
endif

set nomore                             " Disable the 'more' pager when a screen is filled
set lazyredraw                         " Speed up macros by not redrawing during their execution

set textwidth=100                      " Set textwidth
set fo-=c                              " Do NOT automagically wrap comments at textwidth
set fo-=t                              " Do NOT automagically wrap text at textwidth
set fo+=o                              " Insert current comment leader after hitting 'o'
set fo+=r                              " Continue comments after hitting enter in Insert mode

set noautochdir                        " Set cwd to dir of opened file
set dir=~/.vim.tmp

set ffs=unix,dos,mac                   " Fileformat precedence

set showcmd                            " Display incomplete commands on last line
set laststatus=2                       " Status bar information
set ruler                              " Show line,col
set viminfo='100,\"100,%               " Remember marks in last 100 edited files
                                       " 100 lines of each register between sessions
                                       " Buffer list

set foldmethod=marker                  " Manual folding by default
"set foldtext=MyFoldText()
"set foldtext=MyCommendBlockFold()

set backspace=indent,eol,start         " Erase characters, autoindent, or newlines before INSERT
set clipboard^=unnamed,unnamedplus     " Clipboard register config

set wildmenu                           " Show matching commands on <Tab>
set wildmode=longest,list,full         " First tab completes as much as possible.
                                       " Second tab provides a list. (like Bash).
                                       " Third tab cycles through completion options.

if &diff                               " Ignore whitespace in diff mode
    set diffopt+=iwhite
endif



" Return to last edit position when opening files (You want this!)
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END
" Remember info about open buffers on close
set viminfo^=%
" }}}

"----------------------------------------------------------------------------{{{
" Colors
"-------------------------------------------------------------------------------
let g:airline_theme='bb'
set background=dark


" Highlight column at &textwidth
highlight ColorColumn ctermbg=DarkGray guibg=#404040
autocmd BufEnter * execute 'set colorcolumn='
autocmd BufEnter *py execute 'set colorcolumn='.&textwidth

" Set highlight color for trailing spaces (vim-better-whitespace)
hi ExtraWhitespace guibg=#FF0000 ctermbg=red

set cursorline " Highlight current line
hi CursorLine   gui=NONE      cterm=NONE      ctermfg=NONE guifg=NONE ctermbg=NONE guibg=black
hi CursorColumn gui=underline cterm=underline ctermfg=NONE guifg=NONE ctermbg=NONE guibg=black

highlight Folded term=standout cterm=reverse ctermfg=DarkGray ctermbg=Blue gui=reverse guifg=Black guibg=DarkGrey
" }}}

"----------------------------------------------------------------------------{{{
" Mappings
"-------------------------------------------------------------------------------
" Disable Ex mode
nnoremap Q <nop>

" If the S-Fn or C-Fn key maps seem fucked, see fn-key-hack.vim for debug

" F2 open macro
nnoremap <F2> qq
" F3 close macro
nnoremap <F3> q
" F4 execute macro
nnoremap <F4> @q

" F5 searches Stackage
vmap <silent> <F5> :call StackageSearch()<CR>

" Search Files
map <F6> :execute " silent grep! -srnw --binary-files=without-match --exclude-dir=.git --exclude=*~ . -e " . expand("<cword>") . " " <bar> copen<CR><CR>

nnoremap <F7> :call ToggleWordWrap()<CR>
nnoremap <F8> :setlocal spell! spelllang=en_us<CR>

" TODO: Unfuck syntastic bullshit
"nnoremap <C-F8> :SyntasticToggleMode<CR>
"nnoremap <D-F8> :echo "hello"<CR>
"nnoremap <D-F8> :SyntasticCheck<CR>
"nnoremap <M-F8> :SyntasticReset<CR>

" TODO Figure out how to make F9 toggle
" file -> netrw directory -> file -> netrw directory -> ...
nnoremap <F9> :MyExplore<CR>
nnoremap <C-F9> :CtrlP <c-r>=expand("%:p:h")<CR><CR>

nnoremap <F10> :call CopyBufferIntoNew()<CR>
"nnoremap <F11> :Scratch<CR>
nnoremap <F11> :call DebugBuffer()<CR>
nnoremap <C-F11> :e $HOME/scratch<CR>
nnoremap <C-F12> :ReloadConfig<CR>
"Testing
"nnoremap <F12> :call Test()<CR>
"vmap <F12> :call Test()<CR>
"vmap <silent> <F12> :call StackageSearch()<CR>

" Use ctrl-h/j/k/l to switch between splits
noremap <c-j> <c-w>j
noremap <c-k> <c-w>k
noremap <c-l> <c-w>l
noremap <c-h> <c-w>h

" Use ctrl-<arrows> to switch between splits
noremap <c-Down>  <c-w>j
noremap <c-Up>    <c-w>k
noremap <c-Right> <c-w>l
noremap <c-Left>  <c-w>h

" Use ctrl-pageup/pagedown to cycle through buffers
nnoremap <C-PageDown> :bnext<CR>
nnoremap <C-PageUp> :bprevious<CR>
" Use ctrl-Home/End to cycle through tabs
nnoremap <C-Home> :tabprevious<CR>
nnoremap <C-End> :tabnext<CR>

nnoremap <C-q> <C-^>

" Setup my window splitting shortcuts
noremap <leader>0 :hide<CR>
noremap <leader>1 :on<CR>
noremap <leader>2 :split<CR>
noremap <leader>3 :vsplit<CR>
noremap <leader>= <c-w>=
noremap <leader>] <c-w>>
noremap <leader>[ <c-w><
noremap <leader>h :hide<CR>
noremap <A-0> :hide<CR>
noremap <A-1> :on<CR>
noremap <A-2> :split<CR>
noremap <A-3> :vsplit<CR>
noremap <A-=> <c-w>=
noremap <A-]> <c-w>>
noremap <A-[> <c-w><

" Tab shortcuts
noremap <leader>tn :tabnew<CR>
noremap <leader>to :tabonly<CR>
noremap <leader>tc :tabclose<CR>

" Open help in vertical split
" TODO open help on visual selection
" noremap <leader>vh :vert help<CR>
" noremap <leader>h  :help <CR>

" Increment/Decrement next integer on this line
noremap <c-d> <c-a>
noremap <c-s> <c-x>

" Some emacs key mappings that I can't live without
noremap <c-a> 0
noremap <c-e> $

" vimrc stuff
"nnoremap <leader>ei :e $MYVIMRC<CR>
nnoremap <leader>ev :e $HOME/.vimrc<CR>
nnoremap <leader>ef :e $HOME/.vim/bb/functions.vim<CR>
nnoremap <leader>ep :e $HOME/.vim/bb/vimplug.vim<CR>
"nnoremap <leader>egv :e $MYGVIMRC<CR>
nnoremap <leader>egv :e $HOME/.gvimrc<CR>

" Redraw
nnoremap <leader>er :redraw!<Cr>

" commonly used files
nnoremap <leader>r1 :e $HOME/bb/txt/personal/accounts.txt<CR>
nnoremap <leader>rb :e $HOME/.bashrc<CR>
nnoremap <leader>ra :e $HOME/.bash_alias<CR>
nnoremap <leader>rs :e $HOME/scratch<CR>
nnoremap <leader>rq :e $HOME/bb/txt/personal/quotes.txt<CR>
nnoremap <leader>rn :e $HOME/notes/<CR>
nnoremap <leader>w  :e $HOME/worklog.md<CR>
nnoremap <leader>n  :e $HOME/notes.md<CR>

" toggle line number style
nnoremap <C-n> :NumberToggle<cr>
" toggle hex dump mode (xxd)
nnoremap <leader>x :ToggleXXD<cr>

" open finder in current file's directory
nnoremap <leader>f :call OpenFileInFinder()<CR>

" directory helpers
nnoremap <leader>p :pwd<CR>
nnoremap <leader>pg :cd $HOME/git<CR>:pwd<CR>
nnoremap <leader>pc :cd %:p:h<CR>:pwd<CR>

" paste mode
map <leader>pp :setlocal paste!<cr>

" Quickfix navigation
nnoremap <M-j> :lnext<CR>
nnoremap <M-k> :lprev<CR>

" Buffers
nnoremap <leader>b :buffers<CR>
nnoremap <leader>d :Bdelete<CR>
nnoremap <leader>D :bufdo Bdelete<CR>

" tmux
vnoremap <leader>tt "ry :call SendToTmux(":{\n" . @r . ":}\n")<CR>
nnoremap <leader>rr :Tmux :r<CR>
nnoremap <leader>ri :Tmux :IR<CR>
nnoremap <leader>rl :call SendToTmux(":l " . expand("%p") . "\n")<CR>
nmap <leader>r; <Plug>SetTmuxVars

" Keep selected
" vnoremap < <gv
" vnoremap > >gv
" }}}

"----------------------------------------------------------------------------{{{
" Filetype specific settings
"-------------------------------------------------------------------------------
autocmd FileType tex set tw=79
autocmd Filetype text set tw=78 fo+=t

" Python
au BufNewFile,BufRead *.py set
      \ tabstop=4
      \ softtabstop=4
      \ shiftwidth=4
      \ textwidth=79
      \ fileformat=unix

" Haskell
au BufNewFile,BufRead *.hs set
      \ tabstop=2
      \ softtabstop=2
      \ shiftwidth=2
      \ textwidth=99
      \ fileformat=unix

" augroup test
"   autocmd!
"     autocmd BufWritePost *.hs :call SendToTmux(":r\n")
" augroup END

" Comments
autocmd FileType javascript nnoremap <buffer> <leader>c I//<esc>
autocmd FileType vim        nnoremap <buffer> <leader>c I"<esc>
autocmd FileType python,sh  nnoremap <buffer> <leader>c I#<esc>
autocmd FileType tex        nnoremap <buffer> <leader>c I%% <esc>
autocmd FileType haskell    nnoremap <buffer> <leader>c I-- <esc>

" Netrw
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

" Source .vimrc when saving
augroup sourcing
  autocmd!
    autocmd bufwritepost .vimrc source $MYVIMRC
    autocmd bufwritepost .gvimrc source $MYGVIMRC
    autocmd bufwritepost functions.vim source ~/.vim/bb/functions.vim
    autocmd bufwritepost vimplug.vim source ~/.vim/bb/vimplug.vim
augroup END
" }}}

"----------------------------------------------------------------------------{{{
" CtrlP
"-------------------------------------------------------------------------------
" Neovim can't handle S-CR, D-CR, and probably not A-CR
map <c-p> :CtrlP<CR>
map <S-CR> :CtrlP <CR>
"map <S-CR> :CtrlP <c-r>=expand("%:p:h")<CR><CR><F5>
map <CR> :CtrlPBuffer <CR>
map <C-CR> :CtrlPMRU <CR>
map <D-CR> :CtrlP <c-r>=expand("%:p:h")<CR><CR><F5>

set wildignore+=*.pyc,*.obj ",*.plist
let g:ctrlp_custom_ignore = {
  \ 'library':   '.*/Library/.*',
  \ 'prod':  '~/git/prod/',
  \ 'build':  '*/.build/*'
  \ }

let g:ctrlp_max_files=0
let g:ctrlp_show_hidden=1
let g:ctrlp_working_path_mode='r'
" }}}

"----------------------------------------------------------------------------{{{
" vim-fugitive
"-------------------------------------------------------------------------------
map <leader>gb  :Gblame<CR>
map <leader>gs  :Gstatus<CR>
" }}}

"----------------------------------------------------------------------------{{{
" QuickFind Window
"-------------------------------------------------------------------------------
autocmd FileType qf call AdjustWindowHeight(3, 20)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
" }}}

"----------------------------------------------------------------------------{{{
" vim-all-filter
"-------------------------------------------------------------------------------
let g:all_filter_everything_short_title=1
" }}}

" --- TO REMOVE --- "-------------------------------------------------------------------------------
" --- TO REMOVE --- " Grep
" --- TO REMOVE --- "-------------------------------------------------------------------------------
" --- TO REMOVE --- " Jump to quickfix
" --- TO REMOVE --- "command! -nargs=+ MyGrep execute 'silent grep! -I -r -n --exclude *.{json,pyc} . -e <args>' | copen | execute 'silent /<args>'
" --- TO REMOVE --- " Don't jump to quickfix
" --- TO REMOVE --- command! -nargs=+ MyGrep execute 'silent grep! -I -r -n  . -e <args>' | copen | execute 'silent /<args>'
" --- TO REMOVE --- :nmap <leader>s :MyGrep <c-r>=input("grep ")<cr><cr>
" --- TO REMOVE --- :nmap <leader>/ :MyGrep <c-r>=expand("<cword>")<cr><cr>
" --- TO REMOVE --- :nmap <leader>q :copen<cr>

"----------------------------------------------------------------------------{{{
" vim-markdown-folding
"-------------------------------------------------------------------------------
let g:markdown_fold_style = 'nested'
let g:markdown_ignore_first = 0
function! s:setFoldManual()
  let w:last_fdm = &foldmethod
  setlocal foldmethod=manual
endfunction
function! s:resFoldMethod()
  let &l:foldmethod = w:last_fdm
  silent! foldopen
endfunction
augroup fold
  autocmd!
  autocmd InsertEnter * call s:setFoldManual()
  autocmd InsertLeave * call s:resFoldMethod()
augroup END
" }}}
