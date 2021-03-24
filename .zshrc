# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

cd ~/Development
alias proj='cd ~/Development'
alias gs="git status"
alias lp="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias lcc='colorls -lA --sd'
alias lca='colorls -a --sd -sf'
alias lct='colorls --tree=2'

export ZSH="/usr/local/opt/zplug/repos/robbyrussell/oh-my-zsh"

current_user=$USER
node_version=$(node -v 2>/dev/null)
RPROMPT='%F{green}⬢ ${node_version} %F{yellow}- %F{cyan}${current_user}'

ZSH_THEME="oxide"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(
    git
    github
    node
    zsh-history-substring-search
    zsh-syntax-highlighting
    zsh-completions
    zsh-autosuggestions
    command-not-found
    autojump
    compleat
    ssh-agent
    clipboard
    safe-paste
)


autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh
source $(dirname $(gem which colorls))/tab_complete.sh

if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='nano'
else
    export EDITOR='nano'
fi

##############################
# CORPORATE PROXY COMMANDS
##############################
PROXY_URL="ENTER YOUR DUMB PROXY HERE"

# Fixes any special characters used in your passwords
rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"
}

proxy-on() {
    echo "Enter your username:"
    read USERNAME
    echo "Please enter your password:"
    read -s PASSWORD
    PROXY="http://${USERNAME}:$(rawurlencode "$PASSWORD")@${PROXY_URL}"
    export https_proxy=${PROXY}
    export HTTPS_PROXY=${PROXY}
    export http_proxy=${PROXY}
    export HTTP_PROXY=${PROXY}
    export no_proxy=${PROXY}
    export NO_PROXY=${PROXY}
    git config --global http.proxy ${PROXY}
    git config --global https.proxy ${PROXY}
    git config --global http.sslVerify "false"
    git config --global url."https://".insteadOf "git://"
    npm config set ca=""
    # npm config set registry "SPECIAL REGISTRY GOES HERE"
    npm config set strict-ssl false
    npm config set proxy ${PROXY}
    npm config set https-proxy ${PROXY}
    echo "======================="
    echo "Proxy has been set - 🛰️"
    echo "======================="
}
proxy-off() {
    NO_PROXY="localhost,.bullshitcorp.net,jira,complaints,whistleblowerblower"
    unset https_proxy
    unset HTTPS_PROXY
    unset http_proxy
    unset HTTP_PROXY
    unset no_proxy
    unset NO_PROXY
    export NODE_TLS_REJECT_UNAUTHORIZED=1
    git config --global unset http.proxy
    git config --global unset https.proxy
    git config --global unset http.sslVerify "false"
    git config --global unset url."https://".insteadOf "git://"
    npm config delete ca=""
    # npm config set registry "SPECIAL REGISTRY GOES HERE"
    npm config set strict-ssl true
    npm config delete proxy ${PROXY}
    npm config delete https-proxy ${PROXY}
    echo "========================="
    echo "Proxy has been unset - ❌"
    echo "========================="
}

