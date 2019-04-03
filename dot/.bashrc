
test ! -f ${HOME}/.bash_include || . ${HOME}/.bash_include
debug_msg "entering .bashrc"

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
  ${FILES[@]}         \
  ${HOME}/.bash_alias \
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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

################################################################################
# Misc. Bash Configuration                                                     #
################################################################################
stty stop ""      # stty steals Ctrl-S from bash, so undefine it.
                  # probably subsumed by next line...
stty -ixon        # Disable XON/XOFF flow control (^s/^q)
#stty dsusp undef  # Prevent Ctrl-Y from killing GHCi
complete -cf sudo # Tab complete for sudo
set -o noclobber  # Prevent overwriting files

################################################################################
# History                                                                      #
################################################################################
export HISTFILESIZE=
export HISTSIZE=
export HISTFILE=~/.bash_eternal_history
export HISTCONTROL=ignoredups:erasedups:ignorespace
export HISTIGNORE='ls:ll:ltr:la:lla:ltra:lsr:lr:history:pu:po:d:h:h *'
export HISTTIMEFORMAT='%Y/%m/%d %H:%M:%S  '
shopt -s histappend  # Append to history file, instead of overwrite
shopt -s checkwinsize
# Reload history after every command in every shell instance
PROMPT_COMMAND0='setup_prompt';
PROMPT_COMMAND1='history -a; history -n'
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
__fzf_cd__() {
  local cmd dir
  cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m) && printf 'pushd %q > /dev/null' "$dir"
}

debug_msg "leaving .bashrc"
# vim: set filetype=sh:
