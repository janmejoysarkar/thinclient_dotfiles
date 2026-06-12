# .bashrc

alias ll='ls -l'
alias l='echo "slow down, tiger!"'
# Restrict output redirection
set -o noclobber

# Ignore EOF from terminals
set -o ignoreeof

# Setup modules environment
declare -F module &>/dev/null || if [ -r "/etc/profile.d/modules.sh" ]; then . /etc/profile.d/modules.sh; fi

export PS1="\[\033[01;35m\]λ\[\e[00;220m\] \[\e[38;5;223m\]\w\[\033[0m\] ❯ "
export PATH="$HOME/tailscale:$PATH"
export PATH="$HOME/.local/node/bin:$PATH"
export PATH="$HOME/.local/rclone:$PATH"
export PATH="$HOME/.local/AppImage:$PATH"
export PATH="$HOME/.local/wps_office/opt/kingsoft/wps-office/office6:$PATH"
export PATH="$HOME/.local/google-chrome/opt/google/chrome:$PATH" 
export PATH="$HOME/.local/VSCode-linux-x64:$PATH" 
export PATH="$HOME/.local/sublime_text_build_4200_x64/sublime_text:$PATH"
alias ql='python3 $HOME/Dropbox/Janmejoy_SUIT_Dropbox/scripts/quick_look.py'
alias qlt='python3 $HOME/Dropbox/Janmejoy_SUIT_Dropbox/scripts/quick_look_tile.py'
alias qls='python3 $HOME/Dropbox/Janmejoy_SUIT_Dropbox/scripts/quick_look_suit.py'
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME' >> ~/.bashrc
alias condainit='source $HOME/anaconda3/etc/profile.d/conda.sh && conda activate solphy'
alias tailscale='tailscale --socket=$HOME/tailscale/tailscaled.sock'
alias rclonemount='rclone serve webdav Dropbox: --addr localhost:8081 --vfs-cache-mode full'
