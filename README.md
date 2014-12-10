# My dotfiles

## Installation

### Homebrew

Install [Homebrew](http://brew.sh/)

### Node.js / npm

Install [Node.js](http://nodejs.org/)

### ack

Install [ack](http://beyondgrep.com/):

```
$ brew install ack
```

### The Silver Searcher

Install [The Silver Searcher (ag)](http://geoff.greer.fm/ag/):

```
$ brew install ag
```

### ZSH

Install [ZSH](http://www.zsh.org/) and [Prezto](https://github.com/sorin-ionescu/prezto)

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

### Fonts

- Install [Source Code Pro](http://sourceforge.net/projects/sourcecodepro.adobe/files/?source=navbar)
- Install the [Droid Family](http://damieng.com/blog/2007/11/14/droid-font-family-courtesy-of-google-ascender)

### iTerm2 configuration

- In General → Closing, check “Quit when all windows are closed” and uncheck “Confirm "Quit iTerm2 (⌘Q)" command”.
- In General → Window, uncheck “Use Lion-style Fullscreen windows”.
- In Profiles → Default → Text → Text Rendering, uncheck “Draw bold text in bold font” and “Draw bold text in bright colors”.
- In Profiles → Default → Text → Cursor, check “Box”.
- Change the font to 13pt Source Code Pro Light, antialiased.
- Import the [base16-default.dark theme](https://github.com/chriskempson/base16-iterm2), and use it as a color preset.
- In Keys → Global Shortcut Keys, add the following shortcuts (select “Send Hex Code”):

Shortcut | Hex code
---------|------------
⌘h       | `0x01 0x68`
⌘l       | `0x01 0x6C`
⌘t       | `0x01 0x63`
⌘"       | `0x01 0x31`
⌘<       | `0x01 0x32`
⌘>       | `0x01 0x33`
⌘(       | `0x01 0x34`
⌘)       | `0x01 0x35`
⌘@       | `0x01 0x36`

### Run the install script

```
$ ./install.sh
```
