#!/bin/bash

THIS_DIR=$(cd $(dirname $0); pwd -P)
TIMESTAMP=$(date +%Y%m%d%H%M%S)
BACKUPDIR=${HOME}/.dotfiles.backup.d/${TIMESTAMP}

DOTFILES=$(find ${THIS_DIR}/dot  -maxdepth 1 -type f -name '.*')
VIMFILES=$(find ${THIS_DIR}/vim  -maxdepth 1 -name '.*')
ALLFILES=( "${DOTFILES[@]} ${VIMFILES[@]}" )

backup-dotfiles () {
  mkdir -p ${BACKUPDIR}
  for f in ${ALLFILES}; do
    cp -RH $f ${BACKUPDIR} || :
  done
}

link-dotfiles () {
  for f in ${ALLFILES}; do
    ln -sfn $f ${HOME}/$(basename $f)
  done
}

update-karabiner () {
  K=${HOME}/.config/karabiner
  if [ -d "$K" ]; then
    cp -RH ${HOME}/.config/karabiner ${BACKUPDIR}
  else
    mkdir -p $K
  fi
  cp -RH ${THIS_DIR}/karabiner ${HOME}/.config/
}

update-terminator () {
  K=${HOME}/.config/terminator
  if [ -d "$K" ]; then
    mv ${HOME}/.config/terminator ${BACKUPDIR}
  fi
  mkdir -p $K
  ln -sfn ${THIS_DIR}/terminator/config ${HOME}/.config/terminator/config
}

vim-init () {
  vim +PlugInstall +qall
}

link-ghci-conf () {
  H=${HOME}/.ghc
  mkdir -p $H
  ln -sfn ${THIS_DIR}/haskell/ghci.conf ${HOME}/.ghc/ghci.conf
}

configure-glab () {
  command -v glab >/dev/null || return 0
  # `browse <path>`: open the given file in GitLab on the current branch,
  # resolving the path relative to the repo root (not the cwd).
  glab alias set browse '!f() { open "$(glab repo view -F json | jq -r .web_url)/-/blob/$(git branch --show-current)/$(git rev-parse --show-prefix)$1"; }; f' >/dev/null
}


backup-dotfiles
link-dotfiles
configure-glab

if [[ $(uname) == 'Darwin' ]]; then
  update-karabiner
fi

if [[ $(uname) == 'Linux' ]]; then
  update-terminator
fi
