# Executes commands at login pre-zshrc.

if [[ -s "$HOME/dotfiles/private.zsh" ]]; then
  source "$HOME/dotfiles/private.zsh"
fi

# Env
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LANG='en_GB.UTF-8'
export LC_CTYPE='en_GB.UTF-8'
export LC_ALL='en_GB.UTF-8'
export LANG='en_GB.UTF-8'
export BROWSER='open'

export GOPATH="$HOME/go"
export NODE_PATH="/usr/local/lib/node"
export XULRUNNER_BIN="/Applications/Firefox.app/Contents/MacOS/firefox-bin"
export ACLOCAL_FLAGS="-I /usr/local/share/aclocal"
export LDFLAGS="-L /usr/local/opt/cairo/lib"
export CPPFLAGS="-I /usr/local/opt/cairo/include"
export ANDROID_HOME="/usr/local/opt/android-sdk"
export VAGRANT_HOME="~/vagrand.d"

# Cairo fix, see https://github.com/LearnBoost/node-canvas/wiki/Installation---OSX
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/X11/lib/pkgconfig

# Virtualenv (Python)
export WORKON_HOME=$HOME/.virtualenvs
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true
# source /usr/local/bin/virtualenvwrapper.sh

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# OS X $PATH
if [[ "$OSTYPE" = darwin* ]]; then
  path=(
    $(brew --prefix homebrew/php/php55)/bin # PHP
    $(brew --prefix python)/bin # Python
    $(brew --prefix ruby)/bin # Ruby
    $HOME/.rvm/bin # RVM (Ruby)
    $HOME/.cabal/bin # Haskell
    /opt/rust/bin # Rust
    /usr/texbin # Latex
    $ANDROID_HOME/platform-tools # Android SDK
    $ANDROID_HOME/tools # Android SDK
    /usr/local/opt/coreutils/libexec/gnubin # GNU coreutils
    /usr/local/{bin,sbin}
    $path
  )

# Linux Path
else
  path=(
    $path
  )
fi

# Common Path
path=(
  $HOME/bin
  $(npm prefix --global)/bin # Node
  $GOPATH/bin # Go
  $path
)

# $MANPATH
manpath=(
  /usr/local/opt/coreutils/libexec/gnuman # GNU coreutils
  $manpath
)

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

# Temporary Files
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$USER"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
  mkdir -p "$TMPPREFIX"
fi
