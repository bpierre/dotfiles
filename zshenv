# Defines environment variables.

# Ensure that a non-login, non-interactive shell has a defined environment.
# if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
source "${ZDOTDIR:-$HOME}/.zprofile"
# fi

find-up() {
  local path=$(pwd)
  while [[ "$path" != "" && ! -e "$path/$1" ]]; do
    path=${path%/*}
  done
  echo "$path"
}

closest-prettier() {
  local p_local_bin="node_modules/.bin/prettier"
  local p_path=$(find-up "$p_local_bin")

  if [ -z "$p_path" ]; then
    p_path="prettier"
  else
    p_path="$p_path/$p_local_bin"
  fi

  eval "$p_path $@"
}
