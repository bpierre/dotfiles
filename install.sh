#!/bin/sh

SCRIPTDIR=~/dotfiles

lk() {
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

lk nvim       ~/.config/nvim
lk tmux.conf ~/.tmux.conf
lk zshrc     ~/.zshrc
lk zprofile  ~/.zprofile
lk zshenv    ~/.zshenv
lk zlogin    ~/.zlogin
lk gitignore ~/.gitignore
