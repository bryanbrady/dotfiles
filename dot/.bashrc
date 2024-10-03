
if [ -f $HOME/.bash_include ]; then
  . $HOME/.bash_include
fi
debug_msg "entering .bashrc"

################################################################################
# Path                                                                         #
################################################################################
if [ -z $ORIG_PATH ]; then
    export ORIG_PATH=$PATH
fi
PREPATH=.
PREPATH=$PREPATH:$HOME/bin
PREPATH=$PREPATH:$HOME/.local/bin
PREPATH=$PREPATH:$HOME/.cargo/bin
PREPATH=$PREPATH:${GOPATH}/bin:${GOROOT}/bin
PREPATH=$PREPATH:$HOME/.npm/bin
PREPATH=$PREPATH:$HOME/.cargo/bin
PREPATH=$PREPATH:/opt/firefox
PREPATH=$PREPATH:/usr/local/bin
PREPATH=$PREPATH:/usr/local/sbin
PREPATH=$PREPATH:/opt/homebrew/bin
export PATH=$PREPATH:$ORIG_PATH

################################################################################
# Library path                                                                 #
################################################################################
#export LD_LIBRARY_PATH=

################################################################################
# Dotfiles
################################################################################
FILES=(
  ${HOME}/.bash_colors     \
  ${HOME}/.bash_dircolors  \
  ${HOME}/.bash_functions  \
  ${HOME}/.bash_prompt     \
  /etc/bash_completion     \
  ${HOME}/.bash_completion \
  ${HOME}/.fzf.bash        \
  ${HOME}/.docker.bash     \
  ${HOME}/.dockerrc        \
  )

if exists brew; then
  FILES=(
    ${FILES[@]}                                                \
    $(brew --prefix)/etc/bash_completion                       \
    $(brew --prefix)/etc/bash_completion.d/git-completion.bash \
    $(brew --prefix)/etc/bash_completion.d/git-prompt.sh       \
    )
fi

FILES=(
  ${FILES[@]}                                \
  /usr/share/bash-completion/bash_completion \
  /etc/bash_completion                       \
  ${HOME}/.bash_alias                        \
  ${HOME}/.bash_docker                       \
  )


for f in ${FILES[@]}; do
  if [ -f $f ]; then
    . $f
  fi
done

################################################################################
# Private dotfiles
################################################################################
if [ -d ${HOME}/dotfiles-private ]; then
  for f in ${HOME}/dotfiles-private/*
  do
    # Ignore files with leading _
    if ! [[ ${f##*/} =~ _.* ]]; then
      if [[ ${f##*/} != "README.md" ]]; then
        . $f
      fi
    fi
  done
fi

################################################################################
# Misc. Environment Variables                                                  #
################################################################################
export IGNOREEOF=2
export EMACS=emacs
export EDITOR=vim
export VISUAL=vim
export PAGER="less -ifR"

################################################################################
# Misc. Bash Configuration                                                     #
################################################################################
[ -t 0 ] && stty stop ""      # stty steals Ctrl-S from bash, so undefine it.
[ -t 0 ] && stty -ixon        # Disable XON/XOFF flow control (^s/^q)
##stty dsusp undef  # Prevent Ctrl-Y from killing GHCi
complete -cf sudo # Tab complete for sudo
set -o noclobber  # Prevent overwriting files

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

################################################################################
# History                                                                      #
################################################################################
export HISTFILESIZE=
export HISTSIZE=
export HISTFILE=~/.bash_eternal_history
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTIGNORE='ls:ll:ltr:la:lla:ltra:lsr:lr:history:pu:po:d:h:h *'
export HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S  '
shopt -s histappend   # Append to history file, instead of overwrite
shopt -s checkwinsize # Check window size after each command
# Reload history after every command in every shell instance
PROMPT_COMMAND0='setup_prompt';
PROMPT_COMMAND1='history -a; history -c; history -r'
PROMPT_COMMAND2='echo -ne "\033];${PWD}\007"'  # Set terminal title
export PROMPT_COMMAND="$PROMPT_COMMAND0;$PROMPT_COMMAND1;$PROMPT_COMMAND2"

################################################################################
# INPUTRC                                                                      #
################################################################################
if [ -f ~/.inputrc ]; then
    export INPUTRC=$HOME/.inputrc
fi

################################################################################
# fzf
################################################################################
# Use pushd instead of cd
# __fzf_cd__() {
#   local cmd dir
#   cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
#     -o -type d -print 2> /dev/null | cut -b3-"}"
#   dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m) && printf 'pushd %q > /dev/null' "$dir"
# }

################################################################################
# go
################################################################################
export GOROOT=/usr/local/go
export GOPATH=${HOME}/go

################################################################################
# Python
################################################################################
alias awsume=". awsume"

################################################################################
# Other
################################################################################
. "$HOME/.cargo/env"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# The next line updates PATH for the Google Cloud SDK.
[ -f "$HOME/bin/google-cloud-sdk/path.bash.inc" ] && . "$HOME/bin/google-cloud-sdk/path.bash.inc"

# The next line enables shell command completion for gcloud.
[ -f "$HOME/bin/google-cloud-sdk/completion.bash.inc" ] && . "$HOME/bin/google-cloud-sdk/completion.bash.inc"

# Haskell
[ -f "/Users/brady/.ghcup/env" ] && . "/Users/brady/.ghcup/env" # ghcup-env

debug_msg "leaving .bashrc"
# vim: set filetype=sh:
