# Allow to copy paste commands with preceeding $
function \$() {
  "$@"
}

if [[ $TERM == "xterm" ]]; then
    export TERM='xterm-256color'
fi
export TERM='xterm-256color'

# go stuff
#export GOROOT="$HOME/dev/go"
#export GOBIN="$GOROOT/bin"
#export GOPATH="$HOME/dev/gospace"
#export PATH="$GOROOT/bin:$PATH"
#

export GOPATH=$HOME/go

export PKG_CONFIG_PATH=/usr/bin/pkg-config
export PATH=$HOME/dev:$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$PATH

 
#if command -v rbenv 1>/dev/null 2>&1; then
#  eval "$(rbenv init -)"
#fi

# Defaults
PSARGS=-ax

# Some useful defaults
HISTSIZE=1048576
SAVEHIST=$HISTSIZE
HISTFILE=~/.history_zsh

# ^S and ^Q cause problems and I don't use them. Disable stty stop.
stty stop ""
stty start ""

fpath=(~/dotfiles/zsh $fpath)

autoload -U colors && colors
autoload zmv
autoload -U compinit && compinit # enables extra auto-completion
#setopt prompt_subst
PURE_GIT_PULL=0
autoload -U promptinit; promptinit
prompt pure

# Some environment defaults
export EDITOR=/usr/bin/vim
export PAGER=less
export LESS="RnX"
export USE_CCACHE=1

## zsh options settings
setopt no_beep                   # Beeping is annoying. Die.
setopt no_prompt_cr              # Don't print a carraige return before the prompt 
setopt interactivecomments       # Enable comments in interactive mode (useful)
# setopt extended_glob             # More powerful glob features

# history settings
setopt inc_append_history
setopt share_history

#setopt append_history            # Append to history on exit, don't overwrite it.
setopt extended_history          # Save timestamps with history
setopt hist_no_store             # Don't store history commands
setopt hist_save_no_dups         # Don't save duplicate history entries
#setopt hist_expire_dups_first
setopt hist_ignore_all_dups      # Ignore old command duplicates (in current session)

# changing directories
setopt auto_pushd                # Automatically pushd when I cd
setopt nocdable_vars               # Let me do cd ~foo if $foo is a directory

WORDCHARS='?_-&%^{}<>' # chars as part of filename

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

function nosleep {
xset -dpms
xset s noblank
xset s off
}

function normalsleep {
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

function psg() {
  ps $PSARGS | egrep "$@" | fgrep -v egrep
}

function assh() {
  ipaddress=`grep "$@" ${HOME}/workspace/services/swarm/inventory | sed 's/^.*ansible_host=//' | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'`
  echo $ipaddress
  ssh $ipaddress
}

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
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- No Matches Found --\e[0m'
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes


# -- Aliases --
alias ls='ls -G'
alias ll='ls -alh'
alias cp='cp -R'
alias chown='chown -R'
alias chmod='chmod -R'
#alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn'
alias df='df -h'
alias du='du -sh'
alias cls='clear'
alias less='less -FXR'
alias sudo='sudo -E'
# alias open='gnome-open'
alias chtty='chvt'
alias be='bundle exec'
alias t='task'
alias dim='redshift -o'
alias undim='redshift -x'
alias mandim='redshift -c ~/.config/redshift.conf'
alias dockercleanimages='docker rmi $(docker images -q --filter "dangling=true")'
alias dockercleanps='docker rm -f `docker ps --no-trunc -aq`'
alias dockercleanvolumes='docker volume rm $(docker volume ls -qf dangling=true)'
alias dockercleanservices='docker service rm $(docker service ls -q)'
alias dockercleannetworks='docker network rm $(docker network ls -q)'
alias reloadshell='exec $SHELL -l'
alias listeningports="lsof -Pnl +M -i4"
alias less="less -X"
alias now=$(date +'%F-%H:%M:%S')
alias nonascii='ag "[\x80-\xFF]"'
#alias vi="emacsclient -nw"
alias socks5toreno='ssh -D 8123 -f -C -q -N murbanski@staging-mr02-gerrit02.sg.apple.com'
alias debugzsh='zsh -xv &> >(tee ~/omz-debug.log 2>/dev/null)'
alias listening='sudo lsof -iTCP -sTCP:LISTEN -n -P'
#

unalias rm mv cp 2> /dev/null || true # no -i madness

# which vim > /dev/null 2>&1 && alias vi=vim

#autoload -Uz vcs_info

#function prompt_char {
#   WARN="%{$fg[green]%}"
#   if test "$UID" = 0; then
#      WARN="%{$fg[red]%}"
#   fi
#
#   git branch >/dev/null 2>/dev/null && echo "${WARN}$" && return
#   hg root >/dev/null 2>/dev/null && echo "${WARN}☿" && return
#   svn info >/dev/null 2>/dev/null && echo "${WARN}$" && return
#   echo "${WARN}$"
#}
#
#PROMPT='%m %{$fg[yellow]%}${PWD/#$HOME/~}${vcs_info_msg_0_}%{$reset_color%}%(!.%{$fg[green]%}.%{$fg[red]%}) $(prompt_char)%{$reset_color%} '
#
## -- Loop prompt --
#PROMPT2='{%_}  '
#
## -- Selection prompt --
#PROMPT3='{ … }  '

# fish highlighting
source ~/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source ~/dotfiles/zsh/zsh-autosuggestions.zsh

# Google Cloud SDK.
if [ -f "$HOME/dev/google-cloud-sdk/path.zsh.inc" ]; then source "$HOME/dev/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/dev/google-cloud-sdk/completion.zsh.inc" ]; then source "$HOME/dev/google-cloud-sdk/completion.zsh.inc"; fi

bash_source() {
  alias shopt=':'
  alias _expand=_bash_expand
  alias _complete=_bash_comp
  emulate -L sh
  setopt kshglob noshglob braceexpand

  source "$@"
}

# no one cares, none of this matters.
export ANSIBLE_NOCOWS=1
export DCOS_SSL_VERIFY=false
##

if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  echo "Added key"
  ssh-add
fi

# This is where were should start factoring into seperate files.
case `uname` in
  Darwin)
    # autojump
    [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
    [ -f ~/.local/lib/aws/bin/aws_zsh_completer.sh ] && . ~/.local/lib/aws/bin/aws_zsh_completer.sh
    alias ls='ls -FG'
    [[ -f ${HOME}/dotfiles/sensitive.sh ]] && . ${HOME}/dotfiles/sensitive.sh
	  autoload -U compinit && compinit -u
    ;;
  Linux)
    [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
    [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.local/share/autojump.sh
    [[ -s /usr/share/autojump/autojump.sh ]] && source /usr/share/autojump/autojump.sh 
	  autoload -U compinit && compinit -u
    [[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.local/share/autojump.sh
    [[ -s /home/linuxbrew/.linuxbrew/bin ]] && export PATH=/home/linuxbrew/.linuxbrew/bin:${PATH}

    if [ -f  ]
    source /home/linuxbrew/.linuxbrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /home/linuxbrew/.linuxbrew/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh
    alias ls='ls -F --color=auto'
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    [ -f "/usr/local/aws/bin/aws_zsh_completer.sh" ] && . /usr/local/aws/bin/aws_zsh_completer.sh
    if [ ! -z $DISPLAY ]; then
      # set turbo typing
      if which xset 1>/dev/null 2>&1; then
        xset r rate 250 60;
      fi
      if which xcape 1>/dev/null 2>&1; then
        xcape -e 'Caps_Lock=Escape;Control_L=Escape;Control_R=Escape';
      fi
      if which setxkbmap 1>/dev/null 2>&1; then
        setxkbmap -option 'caps:ctrl_modifier';
      fi
    else;
      loadkeys ~/dotfiles/
    fi
esac

# kubernetes completion
if which kubectl 1>/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi
# kops bash completion
if which kops 1>/dev/null 2>&1; then
  bash_source <(kops completion bash)
fi

# pip zsh completion
function _pip_completion {
  local words cword
  read -Ac words
  read -cn cword
  reply=( $( COMP_WORDS="$words[*]" \
             COMP_CWORD=$(( cword-1 )) \
             PIP_AUTO_COMPLETE=1 $words[1] ) )
}
compctl -K _pip_completion pip

# All python shit
#if command -v pyenv 1>/dev/null 2>&1; then
#  eval "$(pyenv init -)"
#fi

#if [ -f "/usr/local/bin/virtualenvwrapper.sh" ]; then source "/usr/local/bin/virtualenvwrapper.sh"; fi
#
#export PYENV_ROOT="$HOME/.pyenv"

function dockerwrap() {
    if [[ $1 = 'run' ]]
    then
        shift
        /usr/bin/docker run \
            -e SHELL=/bin/bash \
            -e LINES=$(tput lines) \
            -e COLUMNS=$(tput cols) \
            "$@"
    fi
    if [[ $1 = 'exec' ]]
    then
        shift
        /usr/bin/docker exec \
            -e SHELL=/bin/bash \
            -e LINES=$(tput lines) \
            -e COLUMNS=$(tput cols) \
            "$@"

        /usr/bin/docker "$@"
    fi
}

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/matt/dev/google-cloud-sdk/path.zsh.inc' ]; then source '/home/matt/dev/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/matt/dev/google-cloud-sdk/completion.zsh.inc' ]; then source '/home/matt/dev/google-cloud-sdk/completion.zsh.inc'; fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# add this configuration to ~/.zshrc
export HISTFILE=~/.zsh_history  # ensure history file visibility
export HH_CONFIG=hicolor        # get more colors
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

#bindkey -s "\C-r" "\eqhh\n"     # bind hh to Ctrl-r (for Vi mode check doc)
  #
# ssh-keygen -o -a 100 -t ed25519

export HOMEBREW_NO_INSECURE_REDIRECT=1

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
