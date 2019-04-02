# Profile startup time utility
# From https://kev.inburke.com/kevin/profiling-zsh-startup-time/
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof # Output load-time statistics
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  PS4=$'%D{%M%S%.} %N:%i> '
  exec 3>&2 2>"${XDG_CACHE_HOME:-$HOME/tmp}/zsh_startup.$$"
  setopt xtrace prompt_subst
fi

# Load zplug
source $HOME/dotfiles/plug.zsh

# Completion style
zstyle ':completion:*' menu select

# History
HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
setopt AUTO_CD
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt HIST_BEEP

# History substring search options
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Disable autocorrect
unsetopt correct_all
unsetopt correct

# Enable ^, see https://github.com/robbyrussell/oh-my-zsh/issues/449
unsetopt nomatch

# Vim mode ESC delay
export KEYTIMEOUT=10

function expand-dot-to-parent-directory-path {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
}
zle -N expand-dot-to-parent-directory-path

# Aliases
alias t="task"
alias l="exa"
alias ll="exa -l --git"
alias la="exa -la --git"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias gti="echo '🚗  vroom vroom';git"
alias bz="bzr"
alias bzd="bzr diff | vim -d -R -"
alias bzl="bzr log | less"
alias json='python -mjson.tool'
alias pjson='pbpaste | json'
alias glog="git log --oneline --graph --decorate --color=always"
alias redis_start="redis-server /usr/local/etc/redis.conf"
alias pgstart="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
alias pgstop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"
alias mongodb_start="mongod run --config /usr/local/etc/mongod.conf"
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | printf 'Public SSH key copied.\n'";
alias gist="gist --copy --shorten";
alias killphantom="ps aux | grep phantomjs | awk '{print }' | xargs kill -9"
# alias firefox="/Applications/FirefoxAurora.app/Contents/MacOS/firefox"
alias git=hub
alias ip="ifconfig | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print \$2}'"
alias svndiff="svn diff | vim -R -"
alias dl="curl -O"
alias ts="t stream timeline"
alias ag="ag --ignore node_modules"
alias pico8="/Applications/PICO-8.app/Contents/MacOS/pico8"
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

# tmux
if [[ "$(uname)" = "Darwin" ]]; then
  alias tmux='tmux -f ~/.tmux-osx.conf'
fi
alias ta="tmux attach -d -t"
alias tn="tmux new"
alias tl="tmux list-sessions"
alias ctags="ctags -R --exclude=.git --exclude=node_modules"

f() {
  find -iname *$1*
}

# Template
tpl() {
  if [[ $# -eq 0 ]]; then
    printf "\nUsage: tpl <name>\n\n"
    printf "Available tpls: "
    ls "$HOME/dotfiles/tpls"
    printf "\n"
  else
    cp -r $HOME/dotfiles/tpls/$1/* .
  fi
}

docker-cleanup() {
  docker rm $(docker ps -a -q)
  docker rmi $(docker images -a -q)
}

# tag-ag (https://github.com/aykamko/tag)
if (( $+commands[tag] )); then
  tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
  # alias ag=tag
fi

# Profile startup time utility
# From https://kev.inburke.com/kevin/profiling-zsh-startup-time/
if [[ "$PROFILE_STARTUP" == true ]]; then
  zprof
  unsetopt xtrace
  exec 2>&3 3>&-
fi

export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /Users/pierre/src/ganache/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /Users/pierre/src/ganache/node_modules/tabtab/.completions/electron-forge.zsh

# Prevent create-react-app to try to launch vim / crash the tmux tab
export REACT_EDITOR=none

# nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
