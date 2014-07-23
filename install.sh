#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s ${DIR}/vimrc ~/.vimrc
ln -s ${DIR}/tmux.conf ~/.tmux.conf
ln -s ${DIR}/zshrc ~/.zshrc
ln -s ${DIR}/zprofile ~/.zprofile
ln -s ${DIR}/zshenv ~/.zshenv
ln -s ${DIR}/zpreztorc ~/.zpreztorc
ln -s ${DIR}/zlogin ~/.zlogin
ln -s -n ${DIR}/dotjs/css ~/.css
ln -s -n ${DIR}/dotjs/js ~/.js
