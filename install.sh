#!/bin/sh

SCRIPT=$(readlink -f "$0")
SCRIPTDIR=$(dirname "$SCRIPT")

linkFile() {
  if [ -L $2 ]; then
    msg="[\e[0;36m$1\e[0m] already exists"
  else
    msg="[\e[0;32m$1\e[0m] linked to $2"
    command="ln -s"
    if [ -d $SCRIPTDIR/$1 ] ; then command="$command -n"; fi
    $command $SCRIPTDIR/$1 $2
  fi
  /bin/echo -e "$msg"
}

linkFile vimrc     ~/.vimrc
linkFile vimrc     ~/.nvimrc
linkFile vim       ~/.vim
linkFile vim       ~/.nvim
linkFile tmux.conf ~/.tmux.conf
linkFile tmux-osx.conf ~/.tmux-osx.conf
linkFile zshrc     ~/.zshrc
linkFile zprofile  ~/.zprofile
linkFile zshenv    ~/.zshenv
linkFile zpreztorc ~/.zpreztorc
linkFile zlogin    ~/.zlogin
linkFile ackrc     ~/.ackrc
linkFile gitignore ~/.gitignore
linkFile dotjs/css ~/.css
linkFile dotjs/js  ~/.js

mkdir -p $SCRIPTDIR/vendor
if [ ! -d $SCRIPTDIR/vendor/z ] ; then
  /bin/echo -e "[\e[0;32mz\e[0m] cloning into $SCRIPTDIR/vendor/z..."
  git clone git@github.com:rupa/z.git $SCRIPTDIR/vendor/z
else
  /bin/echo -e "[\e[0;36mz\e[0m] already cloned"
fi
