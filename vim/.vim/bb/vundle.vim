" Author : Bryan Brady

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-speeddating'
Bundle 'ntpeters/vim-better-whitespace'
Bundle 'mtth/scratch.vim'
Bundle 'vim-scripts/taglist.vim'
"Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdcommenter'
Bundle 'vim-airline/vim-airline'
Bundle 'bryanbrady/vim-airline-themes'

" Syntax
Bundle 'JuliaEditorSupport/julia-vim'
Bundle 'nhooyr/vim-markdown-folding'
Bundle 'LnL7/vim-nix'

" Non-github repos
Bundle 'git@bitbucket.org:bryanbrady/vim-all-cmd'
call vundle#end()


" old shit

" MiniBufExpl
"Bundle 'sontek/minibufexpl.vim'
"Plugin 'fholgdao/minibufexpl.vim'
"Plugin 'techlivezheng/vim-plugin-minibufexpl'
"Plugin 'scrooloose/nerdtree'
"Plugin 'wincent/Command-T'
"Bundle 'garbas/vim-snipmate'
"Bundle 'honza/vim-snippets'
"Bundle 'derekwyatt/vim-scala'
"Bundle 'davidhalter/jedi-vim'
"Bundle 'wookiehangover/jshint.vim'
"Bundle 'MarcWeber/vim-addon-mw-utils'
"Bundle 'tomtom/tlib_vim'
"Bundle 'chase/vim-ansible-yaml'
"Bundle 'rking/ag.vim'
"Bundle 'dhruvasagar/vim-table-mode'
"Bundle 'gotcha/vimpdb'
