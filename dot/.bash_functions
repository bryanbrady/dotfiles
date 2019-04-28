debug_msg "entering .bash_functions"

################################################################################
# Find                                                                         #
################################################################################
ff  () { find . -type f -name "$@" ;}
fd  () { find . -type d -name "$@" ;}
fff () { find . -type f ;}
ffd () { find . -type d -name '*'"$@"'*';}
ffa () { find . -name '*'"$@"'*' ;}
ffs () { find . -name "$@"'*' ;}
ffe () { find . -name '*'"$@" ;}
gga () { gvim `ffa $1`;}

# Grep/Kill my processes
psg () { ps aux | grep -i $1 | grep -v grep ;}
greps () { ps aux | grep -i $1 | grep -v grep ;}
killps () { ps aux | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9 ;}

# Combine tee with custom date stamp for unique names
teed () { tee $1.`date +%Y.%m.%d.%Hh%Mm%Ss`.log ;}

# ll | less
lm () { ls -lhp $BB_LS_COLOR $1 | less -ifR ;}

# ll -R | less
lmr () { ls -lhpR $BB_LS_COLOR $1 | less -ifR ;}

# cd -P if no argument,  cd -P .
cdp () { cd -P ${1:-.} ; }

# Copy with progress
cp_progress () { rsync -WavP --human-readable --progress $1 $2; }

## Print a horizontal rule
rule () { printf "%$(tput cols)s\n"|tr " " "─"; }

################################################################################
# Which                                                                        #
################################################################################
mw () { less -ifR `which $1` ;}              # More/less + which
vw () { vim `which $1` ;}                    # vim + which
gw () { gvim `which $1` ;}                   # gvim + which
cw () { cat `which $1` ;}                    # cat + which
llw () { ls -lhp $BB_LS_COLOR `which $1` ;}  # ls -lhp + which
pud () { pushd `dirname $1` ;}               # pu to dirname output

################################################################################
# Search                                                                       #
################################################################################
if exists ag; then
  any     () { ag --nopager "$@" ;}
  anyc    () { ag --nopager --cc --cpp "$@" ;}
  anyh    () { ag --nopager --hh "$@" ;}
  anyhs   () { ag --nopager --haskell "$@" ;}
  anynix  () { ag --nopager --nix "$@" ;}
  anypy   () { ag --nopager --python "$@" ;}
  anyyaml () { ag --nopager --yaml "$@" ;}
  json    () { ag --nopager --json "$@" ;}
  js      () { ag --nopager --js "$@" ;}
  jv      () { ag --nopager --java "$@" ;}
elif exists ack; then
  any     () { ack --nopager "$@" ;}
  anyc    () { ack --nopager --cc --cpp "$@" ;}
  anyh    () { ack --nopager --hh "$@" ;}
  anyhs   () { ack --nopager --haskell "$@" ;}
  anynix  () { ack --nopager --nix "$@" ;}
  anypy   () { ack --nopager --python "$@" ;}
  anyyaml () { ack --nopager --yaml "$@" ;}
  json    () { ack --nopager --json "$@" ;}
  js      () { ack --nopager --js "$@" ;}
  jv      () { ack --nopager --java "$@" ;}
else
  any     () { find . -type f -name '*' -print0 | xargs -0 grep "$@" ;}
  anyc    () { find . -type f -name '*.cpp' -or '*.cc' -or '*.cxx' -or '*.m' -or '*.hpp' -or '*hh' -or '*.h' -or '*.hxx' '*.xs' -print0 | xargs -0 grep  "$@" ;}
  anyh    () { find . -type f -name '*.h' -print0 | xargs -0 grep  "$@" ;}
  anynix  () { find . -type f -name '*.nix' -print0 | xargs -0 grep  "$@" ;}
  anypy   () { find . -type f -name '*.py' -print0 | xargs -0 grep  "$@" ;}
  anyyaml () { find . -type f -name '*.yaml' -print0 | xargs -0 grep  "$@" ;}
  json    () { find . -type f -name '*.json' -print0 | xargs -0 grep -H "$@" ;}
  js      () { find . -type f -name '*.js' -print0 | xargs -0 grep -H "$@" ;}
fi


################################################################################
# Navigation                                                                   #
################################################################################
# pushd
pu ()
{
  if [ -z $1 ]; then
    pushd > /dev/null
  else
    abs=$(cd $1; pwd -P)
    d=`dirs -v -l | grep $abs$`
    if [ -z "$d" ]; then
      pushd $1 > /dev/null
    else
      pushd +$(echo $d | awk '{print $1}') > /dev/null
    fi
  fi
}

# popd
po ()
{
  popd > /dev/null
}

# dirs -v alternate
d ()
{
  numdirs=${#DIRSTACK[@]}
  echo "+n" "-n" "<dir>"
  for (( i=0; i<$numdirs; i++))
  do
    echo "+"$i " -"$(($numdirs-$i-1)) ${DIRSTACK[$i]}
  done
}

# set title to first argument, if null, use $PWD
settitle ()
{
    echo -ne "\033];${1:-${PWD}}\007"
}

pdf ()
{
    if [[ $BB_OS == 'mac' ]]; then
        open -a Preview $@
    else
        echo "Not implemented"
    fi
}

gvim ()
{
    if [[ $BB_OS == 'mac' ]]; then
        open -a MacVim "$@"
    else
        /usr/bin/gvim $@
    fi
}
alias gv='gvim'

v () { vim $@; }

f ()
{
    if [[ $BB_OS == 'mac' ]]; then
        D=${1:-.}
        shift
        open -a Finder $D $@
    else
        echo "Not implemented. Fix this"
    fi

}

browser ()
{
  if [[ $BB_OS == 'mac' ]]; then
      open -a "Google Chrome" $@
  else
      echo "Not implemented. Fix this"
  fi
}

xrpm ()
{
  rpm2cpio.pl $1 | cpio -idmv
}

_octave ()
{
  \octave --eval "cd('${PWD}')" --persist
}
alias octave=_octave

unrpm ()
{
  rpm2cpio.pl $1 | cpio -idmv
}

gitshown ()
{
  FILE=$1
  N=${2:-1}
  git show $(git log -$N --oneline $FILE | tail -n 1 | cut -d ' ' -f 1) $FILE
}

github () {
  REPO=$(git rev-parse --show-toplevel)
  BRANCH=$(git rev-parse --abbrev-ref HEAD)
  URL=$(git ls-remote --get-url origin | sed -e 's,[^@]*@\([^/]*\).*,\1,' | sed -e 's,:,/,')
  echo https://$URL/${REPO##*/}/tree/$BRANCH
  open https://$URL/${REPO##*/}/tree/$BRANCH
}

git_all_files_ever () {
  git log --pretty=format: --name-only | sort -u
}

zero_out_whitespace () {
  sudo dd if=/dev/zero of=/WHITESPACE bs=1024 count=$(df --sync -kP / | awk 'END {print $4 - 1}')
  sudo rm -f /WHITESPACE
}

monitor_file_size () {
  while true; do ls -alh $1; sleep 15; done
}


e () {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

start_tftp_server () {
  sudo launchctl load -F /System/Library/LaunchDaemons/tftp.plist
  sudo launchctl start com.apple.tftpd
}

stop_tftp_server () {
  sudo launchctl unload -F /System/Library/LaunchDaemons/tftp.plist
}

# Serial port ttys
ser ()
{
  find /dev -name "*usb*" -o -name "*tty*" 2> /dev/null | grep serial
}

################################################################################
# dotfiles                                                                    #
################################################################################
dotup ()
{
  pushd ~/git/dotfiles
  git pull
  popd
}

dots () { pu ~/git/dotfiles; }

debug_msg "leaving .bash_functions"
# vim: set filetype=sh:
