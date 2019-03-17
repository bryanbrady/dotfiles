" vi: set foldmethod=marker foldtext=MyCommentBlockFold():
" Author : Bryan Brady

" --- TO REMOVE --- " Remove duplicate spaces in visual selection
" --- TO REMOVE --- function! RemoveDuplicateSpaces( line1, line2 )
" --- TO REMOVE ---     " Save the current search and cursor position
" --- TO REMOVE ---     let _s=@/
" --- TO REMOVE ---     let l = line(".")
" --- TO REMOVE ---     let c = col(".")
" --- TO REMOVE ---
" --- TO REMOVE ---     " Strip the whitespace
" --- TO REMOVE ---     silent! execute ':' . a:line1 . ',' . a:line2 . 's/\%V\s\+/ /g'
" --- TO REMOVE ---
" --- TO REMOVE ---     " Restore the saved search and cursor position
" --- TO REMOVE ---     let @/=_s
" --- TO REMOVE ---     call cursor(l, c)
" --- TO REMOVE --- endfunction
" --- TO REMOVE --- command! -range RemoveDuplicateSpaces call RemoveDuplicateSpaces( <line1>, <line2> )

" Source .vimrc and .gvimrc
if !exists("*ReloadConfig")
  function ReloadConfig()
      source ~/.vimrc
      if has("gui_running")
          source ~/.gvimrc
      endif
      echom "Reloaded .vimrc and .gvimrc"
  endfunction
  command! ReloadConfig call ReloadConfig()
endif


"----------------------------------------------------------------------------{{{
" Netrw
"-------------------------------------------------------------------------------
function! MyExplore()
  let g:last_explore_root=expand("%:p")
  :Explore!
endfunction
command! MyExplore call MyExplore()

function! UnExplore()
  buffer "" . g:last_explore_root
endfunction
command! UnExplore call UnExplore()

function! NetrwMapping()
    noremap <buffer> <F9> :UnExplore<CR>
endfunction
"}}}


"----------------------------------------------------------------------------{{{
" Toggle
"-------------------------------------------------------------------------------

" Toggle between regular and relative line numbers
function! NumberToggle()
    set number
    if(&relativenumber == 1)
        set relativenumber!
    else
        set relativenumber
    endif
endfunc
command! NumberToggle call NumberToggle()

" Toggle word wrap
function! ToggleWordWrap()
    if !exists("b:wordwrap")
      let b:wordwrap = &wrap || &linebreak
    endif
    if b:wordwrap == 0
        set wrap
        set linebreak
        let b:wordwrap = 1
    else
        set nowrap
        set nolinebreak
        let b:wordwrap = 0
    endif
endfunction
command! ToggleWordWrap call ToggleWordWrap()

" Toggle binary mode (xxd)
function! ToggleXXD()
    if !exists("b:xxd")
        let b:xxd = 0
    endif
    if b:xxd == 0
        execute '%!xxd'
        let b:xxd = 1
    else
        execute '%!xxd -r'
        let b:xxd = 0
    endif
endfunction
command! ToggleXXD call ToggleXXD()

function! ToggleVerbose(...)
  if !&verbose
    if (len(a:000) > 0)
      let &g:verbose = a:1
      set verbosefile=~/.vimlog/verbose.log
      "set verbose=verbosity
    else
      set verbosefile=~/.vimlog/verbose.log
      set verbose=15
    endif
  else
    set verbosefile=
    set verbose=0
  endif
endfunction
" }}}

"----------------------------------------------------------------------------{{{
" Highlighting
"-------------------------------------------------------------------------------

" Colorcolumn / OverLength highlighting
function! SetColorColumn(...)
  highlight ColorColumn ctermbg=0 guibg=#404040
  if a:0 == 1 && a:1 > 0
    execute 'set colorcolumn='.a:1
  elseif &colorcolumn
    execute 'set colorcolumn='
  else
    execute 'set colorcolumn='.&textwidth
  endif
endfunction

function! EnableOverLengthColor()
  "highlight OverLength ctermbg=red ctermfg=white guibg=#darkred
  "highlight OverLength ctermbg=red ctermfg=white guibg=#592929
  highlight OverLength ctermbg=red ctermfg=white guibg=#6060C0
  execute 'match OverLength /\%'.&textwidth.'v[^ \t]\+/'
endfunction
" }}}

"----------------------------------------------------------------------------{{{
" Folding
"-------------------------------------------------------------------------------
function! MyFoldText()
    let line = getline(v:foldstart)
    let sub = substitute(line, '{', '', 'g')
    let num = v:foldend - v:foldstart
    "return v:folddashes . sub . " (" . num . " lines) "
    return sub . " (" . num . " lines) " . v:folddashes
endfunction

function! MyCommentBlockFold()
    let line = getline(v:foldstart+1)
    let sub = substitute(line, '{', '', 'g')
    let num = v:foldend - v:foldstart
    return sub . " (" . num . " lines) " . v:folddashes
endfunction
" }}}

"----------------------------------------------------------------------------{{{
" Debug
"-------------------------------------------------------------------------------
" Create empty debug buffer in a new split
function! DebugBuffer()
    let fname = UniqueDebugName("bb")
    let ftype = &filetype
    new
    execute "setf " . ftype
    execute "silent file " . fname
    execute "set textwidth=0 wrapmargin=0"
endfunction

" Copy buffer into new buffer
function! CopyBufferIntoNew()
    let fname = UniqueDebugName(bufname("%"))
    let ftype = &filetype
    normal! ggyG
    enew
    set buftype=nofile bufhidden=hide noswapfile
    execute "setf " . ftype
    normal! P
    execute "silent file " . fname
    new
    bd
endfunction

function! UniqueDebugName(bname)
    let bname = a:bname
    let index = match(bname, ".debug[0123456789]\*$")
    if index > -1
        let bname = bname[0:index-1]
    endif
    let i = 0
    let fname = bname . ".debug" . i
    while bufexists(fname)
        let i += 1
        let fname = bname . ".debug" . i
    endwhile
    return fname
endfunction
" }}}

"----------------------------------------------------------------------------{{{
" External
"-------------------------------------------------------------------------------

function! OpenFileInFinder()
  let fdir = expand('%:p:h')
  let osys=system('uname -s')
  let osys=substitute(osys, '\n$', '', '')
  if (osys == "Darwin")
    execute ":silent !open -a Finder $D " . fdir
  else
    echom "OpenFileInFinder not implemented for '".osys."'"
  endif
endfunction

function! StackageSearch()
  :normal! gv""y
  :execute "silent !/Users/brady/bin/browser https://www.stackage.org/lts-10.3/hoogle?q=\"" . @" ."\""
  :echom "Searched Stackage for '" . @" . "'"
endfunction
" }}}

"----------------------------------------------------------------------------{{{
" Under Development
"-------------------------------------------------------------------------------

function! Test()
  :source ~/git/configfiles/.vim/bundle/vim-all-cmd/plugin/all_filter.vim
  :echom "BOMBOGENESIS"
endfunction

function! GetVisualSelection()
  normal! gv""y
  echom "before"
  echom @"
  echom "after"
  return @"
endfunction
" }}}
