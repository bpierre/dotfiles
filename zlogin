# Compile the completion dump, to increase startup speed.
# From https://github.com/mattjj/my-oh-my-zsh/blob/b1d4bab329456e9a4af49237064d9a3b6566f1b0/init.zsh#L98-L103
dump_file="$HOME/.zcompdump"
if [[ "$dump_file" -nt "${dump_file}.zwc" || ! -f "${dump_file}.zwc" ]]; then
  zcompile "$dump_file"
fi
unset dump_file
