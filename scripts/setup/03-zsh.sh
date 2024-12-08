#!/usr/bin/env bash

source "$HOME/dotfiles/scripts/setup/utils.sh"

echo "=> Z Shell"


print_info "Configuring..."

create_or_replace_symlink $HOME/dotfiles/.zshrc $HOME/.zshrc

if ! grep -Fxq "$CONFIGURED_MESSAGE" "$HOME/.zshrc"
then
  echo "
$CONFIGURED_MESSAGE
if [ -f ~/.my-zshrc ]; then
  . ~/.my-zshrc
fi" >> "$HOME/.zshrc"
  print_success "Completed..."
else
  print_success "Skipping..."
fi
