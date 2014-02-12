#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s ${DIR}/vimrc ~/.vimrc.local
ln -s ${DIR}/tmux ~/.tmux.conf
ln -s ${DIR}/zshrc ~/.zshrc
ln -s ${DIR}/zpreztorc ~/.zpreztorc
ln -s ${DIR}/.css ~/.css
ln -s ${DIR}/.js ~/.js
