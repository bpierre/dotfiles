export ZPLUG_HOME=$HOME/.zplug
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2 # Should be loaded 2nd last.
zplug 'knu/zsh-manydots-magic', use:manydots-magic, defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3 # Should be loaded last.

zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
# zplug "modules/osx", from:prezto

# zplug "g-plane/zsh-yarn-autocompletions", hook-build:"cargo build --release && cp target/release/yarn-autocompletions ./"

zplug "g-plane/zsh-yarn-autocompletions", hook-build:"./zplug.zsh", defer:2

zplug "changyuheng/zsh-interactive-cd", use:zsh-interactive-cd.plugin.zsh

zplug "skywind3000/z.lua", from:github

zplug load
