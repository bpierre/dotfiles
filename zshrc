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

### Zinit
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

# Plugins
#zinit light "skywind3000/z.lua", from:github
zinit snippet OMZ::plugins/taskwarrior/taskwarrior.plugin.zsh

zinit wait'0' lucid light-mode for \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions \
  pick'manydots-magic' \
    knu/zsh-manydots-magic \
  pick'zsh-history-substring-search.zsh' \
    zsh-users/zsh-history-substring-search \
  pick'zsh-interactive-cd.plugin.zsh' \
    changyuheng/zsh-interactive-cd

# zinit ice atload"zpcdreplay" atclone'./zplug.zsh'
# zinit ice wait"2" atload"zpcompinit; zpcdreplay" atclone'./zplug.zsh'
# zinit load g-plane/zsh-yarn-autocompletions

# zinit light "g-plane/zsh-yarn-autocompletions", hook-build:"./zplug.zsh", defer:2

# zinit ice from"gh" atinit"zpcompinit; zpcdreplay" lucid
# zinit light BuonOmo/yarn-completion

zplugin ice from"gh" as"completion"
zinit light g-plane/zsh-yarn-autocompletions

zplugin ice from"gh" atinit"zpcompinit; zpcdreplay" lucid
zplugin light zdharma/fast-syntax-highlighting

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
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

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
alias k="kubectl"
alias t="task"
alias e="nnn"
alias l="exa"
alias ll="exa -l --git"
alias la="exa -la --git"
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
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
alias gti="echo '🚗  vroom vroom';git"
alias g=hub
alias y='command yarn'
alias pn='pnpm'
alias pdf=zathura
alias svndiff="svn diff | vim -R -"
alias dl="curl -O"
alias ts="t stream timeline"
alias ag="ag --ignore node_modules"
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
alias bt='bluetoothctl'
alias bth='bt power off && bt power on && bt connect 94:DB:56:6B:AF:FD'
alias bto='bt power off'
alias b='bat'
alias p='paru'

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

update-discord() {
  cd $HOME/apps
  mv discord discord_
  curl -L 'https://discord.com/api/download/canary?platform=linux&format=tar.gz' > discord.tar.gz
  tar xvzf discord.tar.gz
  mv DiscordCanary discord
  rm discord.tar.gz
  rm -rf discord_
  echo 'Done.'
}

find-up() {
  local path=$(pwd)
  while [[ "$path" != "" && ! -e "$path/$1" && ! -h "$path/$1" ]]; do
    path=${path%/*}
  done
  echo "$path"
}

closest-prettier() {
  local p_local_bin="node_modules/.bin/prettier"
  local p_path=$(find-up "$p_local_bin")

  if [ -z "$p_path" ]; then
    p_path="prettier"
  else
    p_path="$p_path/$p_local_bin"
  fi

  eval "$p_path $@"
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

# export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden'
export FZF_DEFAULT_COMMAND='rg --files'
# export FZF_DEFAULT_COMMAND='ag -g ""'
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

eval "$(zoxide init zsh --cmd c)"

# Python
export PATH="/home/pierre/.local/bin:$PATH"

# Perl
export PATH="/home/pierre/perl5/bin:$PATH"
export PERL5LIB="/home/pierre/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="/home/pierre/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"/home/pierre/perl5\""
export PERL_MM_OPT="INSTALL_BASE=/home/pierre/perl5"

source /home/pierre/.config/broot/launcher/bash/br

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
