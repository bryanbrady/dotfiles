#!/bin/sh

sha=`git rev-parse HEAD`
sh gen.sh > /tmp/env
git config --global user.email "bryan.brady@gmail.com"
git config --global user.name "bryan brady"
git clone git@github.com:bryanbrady/asdf-sh.git
cd asdf-sh
cp /tmp/env .
if ! git diff --exit-code; then
  git add -u
  git commit -m "https://github.com/bryanbrady/dotfiles/commit/$sha"
  git push origin master
fi
