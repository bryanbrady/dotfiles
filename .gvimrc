" Don't display the menus or toolbar, just the screen.
set guioptions-=m
set guioptions-=T

" Don't display either left or right scroll bars
set guioptions-=r
set guioptions-=L

" Use console dialogs instead of gui dialogs
set guioptions+=c

" Set color scheme
"colorscheme ir_black
colorscheme desert
"colorscheme wombat256mod

set background=dark

" make Folded lines more readable
highlight Folded term=standout cterm=reverse ctermfg=DarkGray ctermbg=Blue gui=reverse guifg=Black guibg=DarkGrey

" title bar
if !empty($SID)
    "    set titlestring=%F\ %{expand($SID)}\ \-\ %{expand(v:servername)}
    set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ \ \ %{expand($SID)}\ \-\ %{expand(v:servername)}
    set titlelen=1000
endif
set title

if has("gui_vimr")
  " VimR settings here
endif

" TODO h9 on work laptop, h10 on home
if has("gui_macvim")
  source ~/.vimrc " MacVim isn't sourcing this
  set macmeta     " Make alt/option work
  set guifont=Menlo\ Regular:h10
endif
