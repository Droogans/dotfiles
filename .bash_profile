source ~/.bash_aliases
source ~/.git-prompt.sh
source ~/.git-completion.sh
source /usr/local/etc/bash_completion.d/password-store

export EDITOR=/Applications/Emacs.app/Contents/MacOS/bin/emacsclient
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig
export NOEXEC_EXCLUDE="compass"
export SHELL="/usr/local/bin/bash"

export GOPATH=~/code/go

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
PATH=$PATH:$HOME/.rvm/bin:$HOME/.android/tools:$HOME/Library/Android/sdk/platform-tools:$HOME/code/tf
