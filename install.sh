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

vim-init () {
  vim +PlugInstall +qall
}

backup-dotfiles
link-dotfiles

if [[ $(uname) == 'Darwin' ]]; then
  update-karabiner
fi
