#!/bin/bash

# Visual Studio Code
# https://code.visualstudio.com/docs/setup/linux
if [ `which code` ]; then
  echo "Already installed: VS Code"
else
  echo "Installing: VS Code..."
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt install -y apt-transport-https
  sudo apt update
  sudo apt install -y code
  rm microsoft.gpg
fi