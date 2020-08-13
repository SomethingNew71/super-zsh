# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/cole/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# stop these errors https://github.com/asdf-vm/asdf/issues/266
# & make it fast https://carlosbecker.com/posts/speeding-up-zsh/
autoload -Uz compinit

# My Custom Aliases
cd ~/Documents/proj
alias proj='cd ~/Development'
alias gs="git status"
alias lp="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias lcc='colorls -lA --sd'
alias lca='colorls -a --sd -sf'
alias lct='colorls --tree=2'

current_user=$USER
node_version=$(node -v 2>/dev/null)
RPROMPT='%F{green}⬢ ${node_version} %F{yellow}- %F{cyan}${current_user}'

if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
    compinit;
else
    compinit -C;
fi;

##########################################################
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
# ColorLS plugin needs manual installing - https://github.com/athityakumar/colorls#custom-configurations
source $(dirname $(gem which colorls))/tab_complete.sh

# Make sure to use double quotes #########################
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
#zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

# oh-my-zsh ##############################################
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/github", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/autojump", from:oh-my-zsh
zplug "plugins/compleat", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh
# Node Plugins
zplug "plugins/node", from:oh-my-zsh

# Load if "if" tag returns true
zplug "lib/clipboard", from:oh-my-zsh
zplug "oz/safe-paste"

# Note: To specify the order in which packages should be loaded, use the defer
#       tag described in the next section

# Set the priority when loading
# e.g., zsh-syntax-highlighting must be loaded
# after executing compinit command and sourcing other plugins
# (If the defer tag is given 2 or above, run after compinit command)
zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Load theme file ########################################
# zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme
zplug dikiaap/dotfiles, use:.oh-my-zsh/themes/oxide.zsh-theme, from:github, as:theme

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

##############################
# CORPORATE PROXY COMMANDS
##############################
PROXY_URL="ENTER YOUR DUMB PROXY HERE"

proxy-on() {
    echo "Enter your username:"
    read USERNAME
    echo "Please enter your password:"
    read -s PASSWORD
    PROXY="http://${USERNAME}:${PASSWORD}@${PROXY_URL}"
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

