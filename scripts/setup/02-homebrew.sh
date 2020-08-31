#!/usr/bin/env bash

source "utils.sh"

echo "=> Homebrew"

if [[ ! -f $(which brew) ]]
then
  print_info "Installing..."

  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew bundle --file="$ROOT_DIR/core/Brewfile"
  brew cleanup && brew upgrade && brew update && brew doctor

  print_success "Completed..."
else
  print_success "Skipping..."
fi

###############################################################################
# Brew install                                                                #
###############################################################################
brew install python
brew install git
brew install zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting
brew install mas
brew install nvm
mkdir ~/.nvm

###############################################################################
# Brew cask                                                                   #
###############################################################################
# to maintain cask ....
#     brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup`

# Dev
brew cask install cyberduck
brew cask install docker
brew cask install iterm2
brew cask install postman
brew cask install tableplus
brew cask install visual-studio-code

# Browsers
brew cask install firefox
brew cask install google-chrome

# Media
brew cask install spotify

# Utilities
brew cask install alfred
brew cask install bettertouchtool
brew cask install dropbox
brew cask install istat-menus
brew cask install notion
brew cask install snagit
brew cask install the-unarchiver
brew cask install tunnelblick
brew cask install WebPQuickLook

# Chat
brew cask install google-chat
brew cask install slack

# Fonts
brew tap homebrew/cask-fonts
brew cask install font-fira-code
brew cask install font-source-code-pro
brew cask install font-source-code-pro-for-powerline

declare -a mas_apps=(
  '1295203466'  # Microsoft Remote Desktop 10
  '539883307'   # LINE
  '824183456'   # Affinity Photo
)

for app in "${mas_apps[@]}"; do
  mas install "$app"
done
