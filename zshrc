# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Disable autocorrect
unsetopt correct_all
unsetopt correct

# Enable ^, see https://github.com/robbyrussell/oh-my-zsh/issues/449
unsetopt nomatch

# Vim mode ESC delay
export KEYTIMEOUT=10

# force ls-- to switch to 256 colors (OS X)
# if [[ "$OSTYPE" = darwin* ]]; then
#   export DISPLAY=1
# fi

# Base16 Shell
BASE16_SHELL="$HOME/dotfiles/base16-shell/base16-tomorrow.dark.sh"
# BASE16_SHELL="$HOME/dotfiles/base16-shell/base16-ocean.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Aliases
alias t="task"
alias l="exa -l"
alias la="exa -la"
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
# alias stylus="stylus -I `npm prefix -g`/lib/node_modules/nib/lib/"
alias redis_start="redis-server /usr/local/etc/redis.conf"
# alias my="mysql.server"
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

# unalias gm from the zprezto git module (used by GraphicsMagick)
unalias gm >/dev/null 2>/dev/null

# tmux
if [[ "$(uname)" = "Darwin" ]]; then
  alias tmux='tmux -f ~/.tmux-osx.conf'
fi
alias ta="tmux attach -d -t"
alias tn="tmux new -s '$(basename $(pwd))'"
alias tl="tmux list-sessions"

# RVM (Ruby)
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

# Go language
# source $(brew --prefix)/share/zsh/site-functions/go

# z
source "$HOME/dotfiles/vendor/z/z.sh"

# Search in LimeChat logs with ack
alias -g irclogs="/Users/pierre/Documents/LimeChat\ Transcripts/"
irclog() {
  search=$1; shift 1
  ack -i $search ~/Documents/LimeChat\ Transcripts/\#main $@
}

f() {
  find -iname *$1*
}

# Updates Prezto
prezto-update() {
  cd "${ZDOTDIR:-$HOME}/.zprezto"
  git pull && git submodule update --init --recursive
  cd -
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

source <(npm completion)

# tag-ag (https://github.com/aykamko/tag)
if (( $+commands[tag] )); then
  tag() { command tag "$@"; source ${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
  # alias ag=tag
fi

# unalias lt

PERL_MB_OPT="--install_base \"/Users/pierre/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/pierre/perl5"; export PERL_MM_OPT;

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/dev
source /usr/local/bin/virtualenvwrapper.sh

export NVM_DIR="/Users/pierre/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
