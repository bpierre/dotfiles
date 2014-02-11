#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s ${DIR}/vimrc ~/.vimrc.local
ln -s ${DIR}/gvimrc ~/.gvimrc.local
ln -s ${DIR}/.css ~/.css
ln -s ${DIR}/.js ~/.js
