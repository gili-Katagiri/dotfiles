# fzf use fd as default
export FZF_DEFAULT_COMMAND='fd --type f --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# fzf default options
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
# comflict with zprezto '**'
export FZF_COMPLETION_TRIGGER='//'

# Alt-C options
{
  # preview tree
  local opt="--preview 'tree -C {} | head -100'"
  # auto select 
  opt="$opt --select-1 --exit-0"
  export FZF_ALT_C_OPTS="$opt"
}
