# fzf default options
export FZF_DEFAULT_OPTS='--height 40% --reverse --border'
# comflict with zprezto '**'
export FZF_COMPLETION_TRIGGER='//'

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/share/doc/fzf/examples/completion.zsh"
# Key bindings
# ------------
source "/usr/share/doc/fzf/examples/key-bindings.zsh"
