#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"

alias update='sudo pacman -Syu'
alias dotpush='cd dotfiles/ && git add . && git commit -m "modified" && git push'