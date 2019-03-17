"echom &wrap || &linebreak
"let b:asdf = &wrap || &linebreak
"echom b:asdf

function! Test1()
  echom 'getpos("."):' . join(getpos("."))
  echom 'getpos("v"):' . join(getpos("v"))
  echom 'getpos("$"):' . join(getpos("$"))
  echom 'getpos("<"):' . join(getpos("'<"))
  echom 'getpos(">"):' . join(getpos("'>"))
endfunction

function! Test(...)
  if a:0 == 1 && a:1 > 0
    execute 'set colorcolumn='.a:1
  elseif &colorcolumn
    execute 'set colorcolumn='
  else
    execute 'set colorcolumn='.&textwidth
  endif
endfunction

nnoremap <leader>t :call Test()<CR>


