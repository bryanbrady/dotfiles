
" For some reason, the syntax matches aren't getting loaded
" or aren't persisting, so MBEtabs aren't colored properly. 
" This file fixes it.

syn match MBENormal                   '\[[^\]]*\]'
syn match MBEChanged                  '\[[^\]]*\]+'
syn match MBEVisibleNormal            '\[[^\]]*\]\*'
syn match MBEVisibleChanged           '\[[^\]]*\]\*+'
syn match MBEVisibleActiveNormal      '\[[^\]]*\]\*!'
syn match MBEVisibleActiveChanged     '\[[^\]]*\]\*+!'

"if !exists("g:did_minibufexplorer_syntax_inits")
  let g:did_minibufexplorer_syntax_inits = 1
  command -nargs=+ HiLink hi link <args>

  HiLink MBENormal                Comment
  HiLink MBEChanged               String
  HiLink MBEVisibleNormal         Special
  HiLink MBEVisibleChanged        Special
  HiLink MBEVisibleActiveNormal   Constant
  HiLink MBEVisibleActiveChanged  Special
  
  delcommand HiLink
"endif

let b:current_syntax = "minibufexpl"
