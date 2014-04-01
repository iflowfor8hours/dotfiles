# Lots of command examples (especially heroku) lead command docs with '$' which
# make it kind of annoying to copy/paste, especially when there's multiple
# commands to copy.
#
# This hacks around the problem by making a '$' command that simply runs
# whatever arguments are passed to it. So you can copy
#   '$ echo hello world'
# and it will run 'echo hello world'
function \$() { 
  "$@"
}

function fixflash() {
pulseaudio -k
}

export LANG=en_US.utf8

# Revision Control

# Defaults
PSARGS=-ax

# Some useful defaults
HISTSIZE=1048576
SAVEHIST=$HISTSIZE
HISTFILE=~/.history_zsh

# ^S and ^Q cause problems and I don't use them. Disable stty stop.
stty stop ""
stty start ""

# Some environment defaults
export EDITOR=vim
export PAGER=less
export LESS="-RnX"

## zsh options settings
setopt no_beep                   # Beeping is annoying. Die.
setopt no_prompt_cr              # Don't print a carraige return before the prompt 
setopt interactivecomments       # Enable comments in interactive mode (useful)
setopt extended_glob             # More powerful glob features

# history settings
setopt append_history            # Append to history on exit, don't overwrite it.
setopt extended_history          # Save timestamps with history
setopt hist_no_store             # Don't store history commands
setopt hist_save_no_dups         # Don't save duplicate history entries
#setopt hist_expire_dups_first
setopt hist_ignore_all_dups      # Ignore old command duplicates (in current session)

# These two history options don't flow with my history usage.
#setopt inc_append_history
#setopt share_history

# changing directories
setopt auto_pushd                # Automatically pushd when I cd
setopt nocdable_vars               # Let me do cd ~foo if $foo is a directory

WORDCHARS='*?_-[]~=&;!#$%^(){}<>' # chars as part of filename

autoload -U compinit && compinit # enables extra auto-completion
setopt prompt_subst
autoload -U colors && colors

# -- Bindings --
bindkey -e # emacs mode line editting
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[3~' delete-char
bindkey '^[[Z' reverse-menu-complete
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# completion madness
compctl -g '*(-/D)' cd
compctl -j -P '%' kill bg fg
compctl -v export unset vared

function up {
  if [ "$#" -eq 0 ] ; then
    echo "Up to where?"
    return 1
  fi

  times=$1
  target="$2"
  while [ $times -gt 0 ] ; do
    target="../$target"
    times=$((times - 1))
  done
  cd $target
}

# Set up $PATH
function notinpath {
  for tmp in $path; do
    [ $tmp = $1 ] && return 1
  done

  return 0
}

function addpaths {
  for i in $*; do
    i=${~i}
    if [ -d "$i" ]; then
      notinpath $i && path+=$i
    fi
  done
}

function delpaths {
  for i in $*; do
    i=${~i}
    PATH="$(echo "$PATH" | tr ':' '\n' | grep -v "$i" | tr '\n' ':')"
  done
}

# Make sure things are in my paths
BASE_PATHS="/bin /usr/bin /sbin /usr/sbin"
X_PATHS="/usr/X11R6/bin /usr/dt/bin /usr/X/bin"
LOCAL_PATHS="/usr/local/bin /usr/local/gnu/bin"
HOME_PATHS="~/bin ~/.screenlayout"
addpaths $=BASE_PATHS $=X_PATHS $=LOCAL_PATHS $=SOLARIS_PATHS $=HOME_PATHS
PATH="$HOME/bin:$HOME/local/bin:$PATH"

# Completion
function screen-sessions {
  typeset -a sessions
  for i in /tmp/screens/S-${USER}/*(p:t);  do
    sessions+=(${i#*.})
  done

  reply=($sessions)
}

compctl -g '*(-/D)' cd 
compctl -c which
compctl -o setopt unsetopt
compctl -v export unset vared
compctl -g "*(-/D)" + -g "*.class(.:r)" java

# This section sets useful variables for various things...
HOST="$(hostname)"
HOST="${HOST%%.*}"
UNAME="$(uname)"

function preexec() {
  # The full command line comes in as "$1"
  local cmd="$1"
  local -a args

  # add '--' in case $1 is only one word to work around a bug in ${(z)foo}
  # in zsh 4.3.9.
  tmpcmd="$1 --"
  args=${(z)tmpcmd}

  # remove the '--' we added as a bug workaround..
  # per zsh manpages, removing an element means assigning ()
  args[${#args}]=()
  if [ "${args[1]}" = "fg" ] ; then
    local jobnum="${args[2]}"
    if [ -z "$jobnum" ] ; then
      # If no jobnum specified, find the current job.
      for i in ${(k)jobtexts}; do
        [ -z "${jobstates[$i]%%*:+:*}" ] && jobnum=$i
      done
    fi
    cmd="${jobtexts[${jobnum#%}]}"
  fi

  # These are used in precmd
  cmd_start_time=$(date +%s)
  lastcmd="$cmd"

  title "$cmd"
}

function title() {
  # This is madness.
  # We replace literal '%' with '%%'
  # Also use ${(V) ...} to make nonvisible chars printable (think cat -v)
  # Replace newlines with '; '
  local value="${${${(V)1//\%/\%\%}//'\n'/; }//'\t'/ }"
  local location

  location="$HOST"
  [ "$USERNAME" != "$LOGNAME" ] && location="${USERNAME}@${location}"

  # Special format for use with print -Pn
  value="%70>...>$value%<<"
  unset PROMPT_SUBST
  case $TERM in
    screen|screen-256color)
      # Put this in your .screenrc:
      # hardstatus string "[%n] %h - %t"
      # termcapinfo xterm 'hs:ts=\E]2;:fs=\007:ds=\E]2;screen (not title yet)\007'
      print -Pn "\ek${value}\e\\"     # screen title (in windowlist)
      print -Pn "\e_${location}\e\\"  # screen location
      ;;
    xterm*)
      print -Pn "\e]0;$value\a"
      ;;
  esac
  setopt LOCAL_OPTIONS
}

function config_Linux() {
  PSARGS=ax
}

case $UNAME in
  FreeBSD) config_FreeBSD ;;
  SunOS) config_SunOS ;;
  Linux) config_Linux ;;
esac

## Useful functions

function psg() {
  ps $PSARGS | egrep "$@" | fgrep -v egrep
}

function findenv() {
  ps aexww | sed -ne "/$1/ { s/.*\($1[^ ]*\).*/\1/; p; }" | sort | uniq -c $2
}

function _awk_col() {
  echo "$1" | egrep -v '^[0-9]+$' || echo "\$$1"
}

function sum() {
  [ "${1#-F}" != "$1" ] && SP=${1} && shift
  [ "$#" -eq 0 ] && set -- 0
  key="$(_awk_col "$1")"
  awk $SP "{ x+=$key } END { printf(\"%d\n\", x) }"
}

function sumby() {
  [ "${1#-F}" != "$1" ] && SP=${1} && shift
  [ "$#" -lt 0 ] && set -- 0 1
  key="$(_awk_col "$1")"
  val="$(_awk_col "$2")"
  awk $SP "{ a[$key] += $val } END { for (i in a) { printf(\"%d %s\\n\", a[i], i) } }"
}

function countby() {
  [ "${1#-F}" != "$1" ] && SP=${1} && shift
  [ "$#" -eq 0 ] && set -- 0
  key="$(_awk_col "$1")"
  awk $SP "{ a[$key]++ } END { for (i in a) { printf(\"%d %s\\n\", a[i], i) } }"
}

function bytes() {
  if [ $# -gt 0 ]; then
    while [ $# -gt 0 ]; do
      echo -n "${1}B = "
      byteconv "$1"
      shift
    done
  else
    while read a; do
      byteconv "$a"
    done
  fi
}

function byteconv() {
  a=$1
  ORDER=BKMGTPE
  while [ $(echo "$a >= 1024" | bc) -eq 1 -a $#ORDER -gt 1 ]; do
    a=$(echo "scale=2; $a / 1024" | bc)
    ORDER="${ORDER#?}"
  done
  echo "${a}$(echo "$ORDER" | cut -b1)"
}

function datelog() {
  [ $# -eq 0 ] && set -- "%F %H:%M:%S]"
  perl -MPOSIX -e 'while (sysread(STDIN,$_,1,length($_)) > 0) { while (s/^(.*?\n)//) { printf("%s %s", strftime($ARGV[0], localtime), $1); } }' "$@"
}

# From petef's zshrc
function scp() {
  found=false
  for arg; do
    if [ "${arg%%:*}" != "${arg}" ]; then
      found=true
      break
    fi
  done

  if ! $found; then
    echo "scp: no remote location specified" >&2
    return 1
  fi

  =scp "$@"
}

# Any special local config?
if [ -r ~/.zshrc_local ] ; then
  . ~/.zshrc_local
fi

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.zsh/cache
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate
zstyle ':completion:*' expand true
zstyle ':completion:*' squeeze-shlashes true
zstyle ':completion::complete:*' '\\'
zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*:*:default' force-list always
zmodload  zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' hosts off

compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:processes' command 'ps -au$USER'

zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'

# -- Aliases --
alias ls='ls -G --color=auto'
alias ll='ls -alh'
alias mkdir='mkdir -p'
alias cp='cp -R'
alias chown='chown -R'
alias chmod='chmod -R'
alias pp='cd ~/Projects'
alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn'
alias vm='VBoxManage'
alias rspec='rspec --color --format documentation'
alias e='sublime -n'
alias df='df -h'
alias du='du -sh'
alias cls='clear'
alias gradle='/home/matt/bin/gradle-1.2/bin/gradle --daemon'
alias less='less -FXR'
alias sublime="/home/matt/dev/Sublime\ Text\ 2/sublime_text &"
alias tasks='task ls | sort -n'
alias open='gnome-open'
alias be='bundle exec'
unalias rm mv cp 2> /dev/null || true # no -i madness

which vim > /dev/null 2>&1 && alias vi=vim

# -- Variables --
# export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
# export GROOVY_HOME=/usr/local/Cellar/groovy/2.0.0/libexec


# -- Proxy Settings --

function disable_proxy() {
   unset http_proxy
   unset https_proxy
   unset ftp_proxy
   unset no_proxy
   sed '/^\ \ ProxyCommand/ s/^/#/g' ~/.ssh/config > /dev/null
}

fundtion enable_proxy() {
  export http_proxy http://qaproxy.gid.gap.com
}

function verizon_on() {
  sudo service network-manager stop
  echo 'nameserver 8.8.8.8 \nnameserver 198.224.182.135 \nnameserver 198.224.183.185' | sudo tee -a /etc/resolv.conf
  sudo wvdial Verizon4GLTE &
}

function verizon_off() {
  sudo service network-manager start
  sudo killall wvdial
  echo '' | sudo tee /etc/resolv.conf
}

function colemak() {
  setxkbmap us -variant colemak
}

function qwfpg() {
  setxkbmap us
  xset -r 66
}

function work_offline() {
  sudo /etc/init.d/pulse stop 
}

function enable_status_bar() {
  i3status -c ~/.i3/i3status.conf | dzen2 -fg white -fn "-misc-fixed-medium-r-normal--10-100-75-75-c-60-iso8859-1" -bg black -ta r -w 800 -x 568 -y 756
}

function disable_status_bar() {
  pkill i3status
  pkill dzen2
}

autoload -Uz vcs_info

function prompt_char {
   WARN="%{$fg[green]%}"
   if test "$UID" = 0; then
      WARN="%{$fg[red]%}"
   fi

   git branch >/dev/null 2>/dev/null && echo "${WARN}$" && return
   hg root >/dev/null 2>/dev/null && echo "${WARN}☿" && return
   svn info >/dev/null 2>/dev/null && echo "${WARN}$" && return
   echo "${WARN}$"
}

PROMPT='%m %{$fg[yellow]%}${PWD/#$HOME/~}${vcs_info_msg_0_}%{$reset_color%}%(!.%{$fg[green]%}.%{$fg[red]%}) $(prompt_char)%{$reset_color%} '

# -- Loop prompt --
PROMPT2='{%_}  '

# -- Selection prompt --
PROMPT3='{ … }  '

# autojump
. /usr/share/autojump/autojump.sh

# fish highlighting
source /home/matt/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


# no one cares, none of this matters.
