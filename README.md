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

### dotjs Firefox Addon

Install the [dotjs](https://github.com/rlr/dotjs-addon) addon in Firefox

### iTerm2 configuration

- In General → Closing, check “Quit when all windows are closed” and uncheck “Confirm "Quit iTerm2 (⌘Q)" command”.
- In General → Window, uncheck “Use Lion-style Fullscreen windows”.
- In Profiles → Default → Text → Text Rendering, uncheck “Draw bold text in bold font” and “Draw bold text in bright colors”.
- In Profiles → Default → Text → Cursor, check “Box”.
- Change the font to 13pt Source Code Pro Light, antialiased.
- Import the [base16-default.dark theme](https://github.com/chriskempson/base16-iterm2), and use it as a color preset.
- In Keys → Global Shortcut Keys, add ⌘h → Send Hex Code → `0x01 0x68` and ⌘l → Send Hex Code → `0x01 0x6C`.

### Run the install script

```
$ ./install.sh
```
