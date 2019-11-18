#!/usr/bin/env bash

echo "=> Z Shell"



if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "Installing..."
  curl -L "http://install.ohmyz.sh" | sh
  echo "Completed..."
else
  echo "Skipping..."
fi


echo "Configuring..."

if ! grep -Fxq "$CONFIGURED_MESSAGE" "$HOME/.zshrc"
then
  echo "
$CONFIGURED_MESSAGE
if [ -f ~/.my-zshrc ]; then
  . ~/.my-zshrc
fi" >> "$HOME/.zshrc"
  echo "Completed..."
else
  echo "Skipping..."
fi


function clone_plugin {
  if [ ! -d "$2" ] ; then
    echo "Installing: ${1}..."
    git clone "$1" "$2"
  else
    echo "Already installed: ${1}"
  fi
}

clone_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
clone_plugin https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
clone_plugin https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z