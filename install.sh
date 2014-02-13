#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s ${DIR}/vimrc ~/.vimrc
ln -s ${DIR}/tmux ~/.tmux.conf
ln -s ${DIR}/zshrc ~/.zshrc
ln -s ${DIR}/zpreztorc ~/.zpreztorc
ln -s --no-dereference ${DIR}/dotjs/css ~/.css
ln -s --no-dereference ${DIR}/dotjs/js ~/.js
