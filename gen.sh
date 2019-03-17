#!/bin/bash

THIS_DIR=$(cd $(dirname $0); pwd -P)
FILES=(
  ${THIS_DIR}/.bash_include    \
  ${THIS_DIR}/.bash_colors     \
  ${THIS_DIR}/.bash_dircolors  \
  ${THIS_DIR}/.bash_alias      \
  ${THIS_DIR}/.bash_functions  \
  )

for f in ${FILES[@]}; do
  cat $f
done
