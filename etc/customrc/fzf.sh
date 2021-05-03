# fzf use fd as default
export FZF_DEFAULT_COMMAND='fd --type f --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# fzf default options
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
# comflict with zprezto '**'
export FZF_COMPLETION_TRIGGER='//'
