#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -s ${DIR}/vimrc.local ~/.vimrc.local
ln -s ${DIR}/gvimrc.local ~/.gvimrc.local
ln -s ${DIR}/.css ~/.css
