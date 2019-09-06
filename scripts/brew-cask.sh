#!/bin/bash

# to maintain cask ....
#     brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup`

# Dev
brew cask install docker
brew cask install iterm2
brew cask install postman
brew cask install visual-studio-code

# Browsers
brew cask install firefox
brew cask install google-chrome

# Media
brew cask install spotify

# Utilities
brew cask install alfred
brew cask install bettertouchtool
brew cask install snagit

# Chat
brew cask install google-chat
brew cask install slack

# Fonts
brew tap homebrew/cask-fonts
brew cask install font-fira-code
brew cask install font-source-code-pro
brew cask install font-source-code-pro-for-powerline
