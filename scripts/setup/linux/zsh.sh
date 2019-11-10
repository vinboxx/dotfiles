#!/bin/bash

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