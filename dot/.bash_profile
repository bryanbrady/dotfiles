test -f ${HOME}/.bash_debug && echo `whoami`: "entering .bash_profile"

if [ -f $HOME/.bash_include ]; then
  . $HOME/.bash_include
fi

if [ -f $HOME/.profile ]; then
  . $HOME/.profile
fi

if [ -f $HOME/.bashrc ]; then
  . $HOME/.bashrc
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/bryan/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

debug_msg "leaving .bash_profile"
# vim: set filetype=sh:
