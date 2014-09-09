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

# force ls-- to switch to 256 colors
export DISPLAY=1

# Aliases
alias l="LC_ALL=en_US.UTF-8 LANG=en ls++"
alias la="LC_ALL=en_US.UTF-8 LANG=en ls++ -a"
alias vi="vim"
alias v="vim"
alias gti="echo 'vroom vroom';git"
alias json='python -mjson.tool'
alias pjson='pbpaste | json'
alias glog="git log --oneline --graph --decorate --color=always"
alias stylus="stylus -I `npm prefix -g`/lib/node_modules/nib/lib/"
alias redis_start="redis-server /usr/local/etc/redis.conf"
# alias my="mysql.server"
alias pgstart="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
alias pgstop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"
alias mongodb_start="mongod run --config /usr/local/etc/mongod.conf"
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | printf 'Public SSH key copied.\n'";
alias gist="gist --copy --shorten";
alias killphantom="ps aux | grep phantomjs | awk '{print }' | xargs kill -9"
alias firefox="/Applications/FirefoxAurora.app/Contents/MacOS/firefox"
alias git=hub
alias ip="ifconfig | grep inet | grep -v inet6 | grep -v 127.0.0.1 | awk '{print \$2}'"

# tmux
alias ta="tmux attach -d -t"
alias tn="tmux new -s '$(basename $(pwd))'"
alias tl="tmux list-sessions"

# RVM (Ruby)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

# Go language
# source $(brew --prefix)/share/zsh/site-functions/go

# z
. `brew --prefix`/etc/profile.d/z.sh

# Search in LimeChat logs with ack
alias -g irclogs="/Users/pierre/Documents/LimeChat\ Transcripts/"
irclog() {
  search=$1; shift 1
  ack -i $search ~/Documents/LimeChat\ Transcripts/\#main $@
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

source <(npm completion)

source `brew --prefix`/etc/profile.d/z.sh

# unalias lt
