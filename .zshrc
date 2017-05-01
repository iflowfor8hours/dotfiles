# Allow to copy paste commands with preceeding $
function \$() { 
  "$@"
}

export LANG=en_US.utf8

# go stuff
export GOROOT="$HOME/dev/go"
#export GOBIN="$GOROOT/bin"
export GOPATH="$HOME/dev/gospace"
#export PATH="$GOROOT/bin:$PATH"
export PKG_CONFIG_PATH=/usr/bin/pkg-config
export VAGRANT_DEFALT_PROVIDER="virtualbox"
export PATH=/home/matt/.local/bin:$PATH

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
setopt prompt_subst

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
setopt inc_append_history
#setopt share_history

# changing directories
setopt auto_pushd                # Automatically pushd when I cd
setopt nocdable_vars               # Let me do cd ~foo if $foo is a directory

WORDCHARS='*?_-[]~=&;!#$%^(){}<>' # chars as part of filename

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

# Make sure things are in my paths
BASE_PATHS="/bin:/usr/bin:/sbin:/usr/sbin"
LOCAL_PATHS="/usr/local/bin:/usr/local/aws/bin"
HOME_PATHS="~/bin:~/.screenlayout:~/.local/bin"
#ANDROID_TOOLS="~/dev/android-sdk-linux/platform-tools:~/dev/android-sdk-linux/tools:~/dev/android-sdk-linux/build-tools/22.0.1/"
PATH="$BASE_PATHS:$LOCAL_PATHS:$HOME_PATHS:$PATH"

compctl -g '*(-/D)' cd 
compctl -c which
compctl -o setopt unsetopt
compctl -v export unset vared
compctl -g "*(-/D)" + -g "*.class(.:r)" java

# This section sets useful variables for various things...
HOST="$(hostname)"
HOST="${HOST%%.*}"
UNAME="$(uname)"

function config_Linux() {
  PSARGS=ax
}

function psg() {
  ps $PSARGS | egrep "$@" | fgrep -v egrep
}

# From petef's zshrc
# make scp error if I forget to put the target host
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
alias mkdir='mkdir -p'
alias cp='cp -R'
alias chown='chown -R'
alias chmod='chmod -R'
alias grep='grep --color=auto --exclude-dir=.git --exclude-dir=.svn'
alias vm='VBoxManage'
alias rspec='rspec --color --format documentation'
alias df='df -h'
alias du='du -sh'
alias cls='clear'
alias less='less -FXR'
alias tasks='task ls | sort -n'
alias open='gnome-open'
alias be='bundle exec'
alias t='task'
alias dim='redshift -o'
alias undim='redshift -x'
alias mandim='redshift -c ~/.config/redshift.conf'
alias dockercleanimages='docker rmi $(docker images -q --filter "dangling=true")'
alias dockercleanps='docker rm `docker ps --no-trunc -aq`'
alias dockercleanvolumes='docker volume rm $(docker volume ls -qf dangling=true)'
alias mutt='cd ~/Desktop && mutt-patched'
alias vdu='vagrant destroy -f && vagrant up'
alias reloadshell='exec $SHELL -l'
alias wifi='exec nmtui'
alias nosleep='xset -dpms; xset s noblank; xset s off'
alias thesaurus='dict -d moby-thesaurus'
alias bfg="java -jar ${HOME}/bin/bfg.jar"
#alias vi="emacsclient -nw"

unalias rm mv cp 2> /dev/null || true # no -i madness

# which vim > /dev/null 2>&1 && alias vi=vim

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

# fish highlighting
source ~/dotfiles/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# kubernetes completion
source <(kubectl completion zsh)

bash_source() {
  alias shopt=':'
  alias _expand=_bash_expand
  alias _complete=_bash_comp
  emulate -L sh
  setopt kshglob noshglob braceexpand

  source "$@"
}

# Requires sudo pip install virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh 

# helm bash completion
# bash_source <(~/.zsh/completion/_helm)
# bash_source <(~/.zsh/completion/_helm)

# kops bash completion
# bash_source <(kops completion bash)

# autoload bashcompinit

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# no one cares, none of this matters.
export ANSIBLE_NOCOWS=1

if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
      ssh-add
    fi

# This is where were should start factoring into seperate files.
case `uname` in
  Darwin)
    # autojump
    [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
    source ~/.local/lib/aws/bin/aws_zsh_completer.sh
    alias ls='ls -FG'
    # nvm
    export NVM_DIR="$HOME/.nvm"
    . "/usr/local/opt/nvm/nvm.sh"
    ;;
  Linux)
    # autojump
    [[ -s /home/matt/.autojump/etc/profile.d/autojump.sh ]] && source /home/matt/.autojump/etc/profile.d/autojump.sh
	  autoload -U compinit && compinit -u
    #NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    alias ls='ls -F --color=auto'
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
    source /usr/local/aws/bin/aws_zsh_completer.sh
    ;;
esac

