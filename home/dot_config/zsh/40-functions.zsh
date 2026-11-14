# 40-functions — small shell helpers.

# Colorized --help:  help git commit
help() {
  if (( $+commands[bat] )); then
    "$@" --help 2>&1 | bat --plain --language=help
  else
    "$@" --help 2>&1 | ${PAGER:-less}
  fi
}
