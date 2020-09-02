#!/usr/bin/env bash

source "$HOME/dotfiles/scripts/setup/utils.sh"

echo "=> Z Shell"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  print_info "Installing..."
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  print_success "Completed..."
else
  print_success "Skipping..."
fi


print_info "Configuring..."

create_or_replace_symlink $HOME/dotfiles/config/.oh-my-zsh/custom/themes/wild-cherry.zsh-theme $HOME/.oh-my-zsh/custom/themes/wild-cherry.zsh-theme
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
