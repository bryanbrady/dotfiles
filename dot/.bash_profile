
test -f ${HOME}/.bash_debug && echo `whoami`: "entering .bash_profile"

if [ -f $HOME/.bash_include ]; then
  . $HOME/.bash_include
fi

if [ -f $HOME/.profile]; then
  . $HOME/.profile
fi

if [ -f $HOME/.bashrc ]; then
  . $HOME/.bashrc
fi

debug_msg "leaving .bash_profile"
# vim: set filetype=sh:

