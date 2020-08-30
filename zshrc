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

autoload -U zmv

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

function c {
 cd "$(z | fzf | awk '{print $2}')"
}

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
alias g=hub
alias ip="ifconfig | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print \$2}'"
alias svndiff="svn diff | vim -R -"
alias dl="curl -O"
alias ts="t stream timeline"
alias ag="ag --ignore node_modules"
# alias pico8="/Applications/PICO-8.app/Contents/MacOS/pico8"
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
alias emoj="emoji-fzf preview | fzf --preview 'emoji-fzf get --name {1}' | cut -d \" \" -f 1 | emoji-fzf get | xclip -selection clipboard"
alias check-deprecated-modules="cat package.json | jq '(.dependencies+.devDependencies) | keys | .[]' | xargs -I {} sh -c 'yarn info --json {} | jq \".data.name,.data.deprecated\"'"
alias serve="xdg-open 'http://localhost:8000/' & simple-http-server --silent --index"

# crops
# alias crop-1450-600="mogrify -gravity North -chop x458 -gravity South -chop x117 -shave 19x0"
alias crop-1450-600="mogrify -gravity North -chop x383 -gravity South -chop x192 -shave 19x0"
alias crop-1200-700-nobar="mogrify -gravity North -chop x337 -gravity South -chop x73 -shave 420x0 -bordercolor '#d1d5da' -border 2"

# Arch
alias aur="cd $HOME/aur"
alias open="xdg-open"
alias icat="kitty +kitten icat"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# tmux
if [[ "$(uname)" = "Darwin" ]]; then
  alias tmux='tmux -f ~/.tmux-osx.conf'
fi
alias ta="tmux attach -d -t"
alias tn="tmux new"
alias tl="tmux list-sessions"
alias ctags="ctags -R --exclude=.git --exclude=node_modules"
alias f="fd"
alias at="as-tree"

ft() {
  f $1 | as-tree
}

# f() {
#   find -iname *$1*
# }

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
# [[ -f /Users/pierre/src/ganache/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /Users/pierre/src/ganache/node_modules/tabtab/.completions/electron-forge.zsh

# Prevent create-react-app to try to launch vim / crash the tmux tab
export REACT_EDITOR=none

# Prevent Howdy to display warnings
export OPENCV_LOG_LEVEL=ERROR

# nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
export PATH="$HOME/.yarn/bin:$PATH"

# keychain
eval $(keychain --eval --quiet id_rsa)

# Base16 Shell
# BASE16_SHELL="$HOME/.config/base16-shell/"
# [ -n "$PS1" ] && \
    # [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        # eval "$("$BASE16_SHELL/profile_helper.sh")"

# base16_snazzy

eval "$(starship init zsh)"
