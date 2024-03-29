# fzf-defult and key-bindings
# fzf use fd as default
export FZF_DEFAULT_COMMAND='fd --type f --follow --hidden --exclude .git'
# fzf default options
export FZF_DEFAULT_OPTS='--height 40% --reverse --border=rounded'

# Ctrl-T is used to shorten the imput of '$(fzf)'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --follow"
# Alt-C options
{
  # preview tree
  local opt="--preview 'exa --tree --level 3 --color=always {} | head -100'"
  # auto select 
  opt="$opt --select-1 --exit-0"
  export FZF_ALT_C_OPTS="$opt"
}

# fzf-completions
# Policy: NOT to target hidden files

# comflict with zprezto '**'
export FZF_COMPLETION_TRIGGER='//'
# fzf-completion does not look for hidden files
_fzf_compgen_path() {
  fd --follow . "$1"
}
_fzf_compgen_dir() {
  fd --type d --follow . "$1"
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)     fzf "$@" --preview 'exa --tree --level 3 --color=always {} | head -100' ;;
    *)      fzf "$@" ;;
  esac
}
