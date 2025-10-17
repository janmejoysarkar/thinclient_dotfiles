# .bashrc

alias ll='ls -l'
alias rm='rm -i'

# Restrict output redirection
set -o noclobber

# Ignore EOF from terminals
set -o ignoreeof

# Setup modules environment
declare -F module &>/dev/null || if [ -r "/etc/profile.d/modules.sh" ]; then . /etc/profile.d/modules.sh; fi

export PS1="\[\033[01;35m\]λ\[\e[00;220m\] \[\e[38;5;223m\]\w\[\033[0m\] ❯ "
export TSDIR="$HOME/.local/tailscale-data"
export PATH="$HOME/.local/node/bin:$PATH"
export PATH="$HOME/.local/rclone:$PATH"

alias google-chrome="$HOME/.local/google-chrome/opt/google/chrome/google-chrome &" 
alias rclonemount="rclone mount Dropbox: ~/Dropbox --vfs-cache-mode full --daemon -v"
alias ql='python3 $HOME/Dropbox/Janmejoy_SUIT_Dropbox/scripts/quick_look.py'
alias qlt='python3 $HOME/Dropbox/Janmejoy_SUIT_Dropbox/scripts/quick_look_tile.py'
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' >> ~/.bashrc
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/sarkarjj/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/sarkarjj/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/sarkarjj/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/sarkarjj/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
