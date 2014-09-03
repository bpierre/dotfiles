# My dotfiles

## Installation

### ZSH

Install [ZSH](http://www.zsh.org/) and [Prezto]()

```
$ brew install zsh
$ sudo echo "/usr/local/bin/zsh" >> /etc/shells
$ chsh -s /usr/local/bin/zsh
$ git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
```

### tmux

Install [tmux](http://tmux.sourceforge.net/):

```
$ brew install tmux
```

Install [reattach-to-user-namespace](https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard) (to enable the OS X pasteboard in tmux):

```
$ brew install reattach-to-user-namespace
```

### z

Install [z](https://github.com/rupa/z):

```
$ brew install z
```

### Vundle

Install [Vundle](https://github.com/gmarik/Vundle.vim):

```
$ git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### Base16 theme for iTerm

Import the [base16-default.dark theme](https://github.com/chriskempson/base16-iterm2) in iTerm, and use it as a color preset.


### dotjs Firefox Addon

Install the [dotjs](https://github.com/rlr/dotjs-addon) addon in Firefox

### Run the install script

```
$ ./install.sh
```
