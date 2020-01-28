
test -f ${HOME}/.bash_debug && echo `whoami`: "entering .bash_profile"

if [ -f $HOME/.bash_include ]; then
  . $HOME/.bash_include
fi

if [ -f $HOME/.bashrc ]; then
  . $HOME/.bashrc
fi

################################################################################
# Path                                                                         #
################################################################################
if [ -z $ORIG_PATH ]; then
    export ORIG_PATH=$PATH
fi
PREPATH=.
PREPATH=$PREPATH:${GOPATH}/bin:${GOROOT}/bin
PREPATH=$PREPATH:$HOME/.npm/bin
PREPATH=$PREPATH:/usr/local/bin
PREPATH=$PREPATH:/usr/local/sbin
PREPATH=$PREPATH:$HOME/bin
export PATH=$PREPATH:$ORIG_PATH

################################################################################
# Library path                                                                 #
################################################################################
#export LD_LIBRARY_PATH=$LD_LIB_PATH


debug_msg "leaving .bash_profile"
# vim: set filetype=sh:

export PATH="$HOME/.cargo/bin:$PATH"
