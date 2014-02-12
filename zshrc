# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# PATH
BREW_PREFIX=$(brew --prefix) # brew prefix (usually /usr/local)
P=$(npm prefix --global)/bin # Node
P=$P:$(brew --prefix josegonzalez/php/php54)/bin # PHP
P=$P:$(brew --prefix python)/bin # Python
P=$P:$(brew --prefix ruby)/bin # Ruby
P=$P:/usr/texbin # Latex
P=$P:~/.cabal/bin # Haskell
P=$P:/opt/rust/bin # Rust
P=$P:/usr/local/opt/android-sdk/platform-tools # Android SDK
P=$P:/usr/local/opt/android-sdk/tools # Android SDK
P=$P:~/bin
P=$P:${BREW_PREFIX}/bin
P=$P:${BREW_PREFIX}/sbin
P=$P:${BREW_PREFIX}/opt/coreutils/libexec/gnubin # GNU coreutils
export PATH=$P:$PATH

# MANPATH
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH" # GNU coreutils

# Cairo fix, see https://github.com/LearnBoost/node-canvas/wiki/Installation---OSX
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/X11/lib/pkgconfig

# Disable autocorrect
unsetopt correct_all
unsetopt correct

# Env
export LANG="fr_FR.UTF-8"
export LC_CTYPE=en_US.UTF-8
export EDITOR='vim'
export VISUAL='vim'
#export XULRUNNER_BIN=/Applications/Firefox.app/Contents/MacOS/firefox-bin
export NODE_PATH=/usr/local/lib/node
export ACLOCAL_FLAGS='-I /usr/local/share/aclocal'
export LDFLAGS='-L /usr/local/opt/cairo/lib'
export CPPFLAGS='-I /usr/local/opt/cairo/include'
export ANDROID_HOME='/usr/local/opt/android-sdk'
export VAGRANT_HOME="/Volumes/LE HD/vagrand.d"

# Virtualenv (Python)
export WORKON_HOME=$HOME/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
# source /usr/local/bin/virtualenvwrapper.sh

# Go
export GOPATH=$HOME/go
source $(brew --prefix)/share/zsh/site-functions/go

# Base16 Shell
# BASE16_SCHEME="default"
# BASE16_SHELL="$HOME/.config/base16-shell/base16-$BASE16_SCHEME.dark.sh"
# [[ -s $BASE16_SHELL ]] && . $BASE16_SHELL

# Aliases
alias l=" LC_ALL=en_US.UTF-8 LANG=en ls++ "
alias la=" LC_ALL=en_US.UTF-8 LANG=en ls++ -a "
alias vi="vim"
alias v="vim"
alias json='python -mjson.tool'
alias pjson='pbpaste | json'
alias glog="git log --oneline --graph --decorate --color=always"
alias stylus="stylus -I `npm prefix -g`/lib/node_modules/nib/lib/"

alias redis_start="redis-server /usr/local/etc/redis.conf"
alias my="mysql.server"
alias pgstart="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
alias pgstop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"
alias mongodb_start="mongod run --config /usr/local/etc/mongod.conf"
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | printf 'Public SSH key copied.\n'";

# RVM (Ruby)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# Enable ^, see https://github.com/robbyrussell/oh-my-zsh/issues/449
unsetopt nomatch

# Vim mode ESC delay
export KEYTIMEOUT=10

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
