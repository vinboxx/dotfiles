#!/bin/bash

source "$HOME/dotfiles/scripts/setup/utils.sh"

create_or_replace_symlink $HOME/dotfiles/.bash_aliases $HOME/.bash_aliases
create_or_replace_symlink $HOME/dotfiles/.bash_profile $HOME/.bash_profile
create_or_replace_symlink $HOME/dotfiles/.gitconfig $HOME/.gitconfig

echo "Running sub-shells..."

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

# Do something under Mac OS X platform
if [ "$machine" = "Mac" ]; then

  $HOME/dotfiles/scripts/setup/01-xcode.sh
  $HOME/dotfiles/scripts/setup/02-homebrew.sh
  $HOME/dotfiles/scripts/setup/03-zsh.sh
  $HOME/dotfiles/scripts/setup/07-vscode.zsh
  $HOME/dotfiles/scripts/setup/09-macos.sh

fi

if [ "$machine" = "Linux" ]; then

  $HOME/dotfiles/scripts/setup/linux/apps.sh
  $HOME/dotfiles/scripts/setup/linux/nvm.sh
  $HOME/dotfiles/scripts/setup/linux/oh-my-zsh.sh
  $HOME/dotfiles/scripts/setup/linux/google-chrome.sh
  $HOME/dotfiles/scripts/setup/linux/vscode.sh

fi



