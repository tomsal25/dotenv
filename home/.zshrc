#!/bin/zsh

# msys compability
case `uname` in
  *MSYS*)
    # msys make
    alias make='mingw32-make'

    # msys key setting
    bindkey ' ' magic-space                           # do history expansion on space
    bindkey '^U' backward-kill-line                   # ctrl + U
    bindkey '^[[3;5~' kill-word                       # ctrl + Supr
    bindkey '^[[3~' delete-char                       # delete
    bindkey '^[[1;5C' forward-word                    # ctrl + ->
    bindkey '^[[1;5D' backward-word                   # ctrl + <-
    bindkey '^[[5~' beginning-of-buffer-or-history    # page up
    bindkey '^[[6~' end-of-buffer-or-history          # page down
    bindkey '^[[H' beginning-of-line                  # home
    bindkey '^[[F' end-of-line                        # end
    bindkey '^[[Z' undo                               # shift + tab undo last action

    # to make auto-complete worked
    # https://github.com/msys2/MSYS2-packages/issues/38#issuecomment-150131217
    drives=$(mount | sed -rn 's#^[A-Z]: on /([a-z]).*#\1#p' | tr '\n' ' ')
    zstyle ':completion:*' fake-files /: "/:$drives"
    unset drives
    ;;
esac

# zsh plugin

## zsh-autosuggestions
source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY="history"

## zsh-completions
fpath=(
  "$HOME/.zsh/zsh-completions/src"
  "$HOME/.zsh/git-completions"
  $fpath
)

## zsh-syntax-highlighting
source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# env variable
export LANG='en_US.UTF-8'
bindkey -e

setopt printexitvalue # print exit code
setopt magic_equal_subst # enable auto complete in command line args

# history
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=1000
export HISTCONTROL=ignorespace
export SAVEHIST=10000

setopt hist_ignore_dups # ignore just before command
setopt hist_reduce_blanks # trim spaces
setopt hist_ignore_all_dups # remove old one if duplicated
setopt hist_ignore_space # do not add commands which start w/ space
setopt inc_append_history # save on execute

# save histories only if it is succeessful
zshaddhistory() {
  whence ${${(z)1}[1]} >| /dev/null || return 1
}

# auto-complete
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit && compinit

setopt auto_list

# alias
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias ls='ls -hF --color=auto'
alias ll='ls -l'
alias la='ls -a'

alias grep='grep --color=auto'

mcd () {
  mkdir -p $1
  cd $1
}

# venv ailas
vmk () {
  if [[ -z "$1" ]]; then
    py -m venv .venv
  elif [[ "$1" == "-h" ]]; then
    echo "You can optionaly specify version."
    echo "Example:"
    echo ""
    echo "    $0 3.10"
    return
  else
    py -$1 -m venv .venv
  fi
}

von () {
  if [[ -d .venv ]]; then
    source ./.venv/Scripts/activate
  else
    echo "Run vmk or make .venv environment."
  fi
}

voff () {
  deactivate
}
