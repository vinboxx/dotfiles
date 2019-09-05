#!/bin/bash

# to maintain cask ....
#     brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup`

# Dev
brew cask install iterm2
brew cask install visual-studio-code

# Browsers
brew cask install google-chrome
brew cask install firefox

# Media
brew cask install spotify

# Utilities
brew cask install alfred
brew cask install bettertouchtool

# Chat
brew cask install slack
brew cask install google-chat

# Fonts
brew tap caskroom/fonts
brew cask install font-fira-code
# powerline font
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
