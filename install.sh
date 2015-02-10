#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s ${DIR}/vimrc ~/.vimrc
ln -s ${DIR}/vimrc ~/.nvimrc
ln -s ${DIR}/vim ~/.vim
ln -s ${DIR}/vim ~/.nvim
ln -s ${DIR}/tmux.conf ~/.tmux.conf
ln -s ${DIR}/zshrc ~/.zshrc
ln -s ${DIR}/zprofile ~/.zprofile
ln -s ${DIR}/zshenv ~/.zshenv
ln -s ${DIR}/zpreztorc ~/.zpreztorc
ln -s ${DIR}/zlogin ~/.zlogin
ln -s ${DIR}/ackrc ~/.ackrc
ln -s ${DIR}/gitignore ~/.gitignore
ln -s -n ${DIR}/dotjs/css ~/.css
ln -s -n ${DIR}/dotjs/js ~/.js
