# just to remember when/in what order config files are loaded
# echo '✅ .zprofile'

# add brew to path
# NB not using plugin here--brew should be aded to path early in
# the config because it is required by other parts down the line
eval "$(/opt/homebrew/bin/brew shellenv)"

# nix
# source $HOME/.nix-profile/etc/profile.d/nix.sh

# add vscode to path
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin" 

# add nvm to path // no need if using oh-my-zsh plugin
source $(brew --prefix nvm)/nvm.sh

# add pyenv to path
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# set missing locales for R to work
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8