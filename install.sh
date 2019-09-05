create_or_replace_symlink() {
    local source=$1
    local destination=$2

    if [ -L $destination ]; then
        rm $destination
    fi

    ln -nfs $source $destination
}

create_or_replace_symlink $HOME/dotfiles/.bash_aliases $HOME/.bash_aliases
create_or_replace_symlink $HOME/dotfiles/.bash_profile $HOME/.bash_profile
create_or_replace_symlink $HOME/dotfiles/.zshrc $HOME/.zshrc
create_or_replace_symlink $HOME/dotfiles/.gitconfig $HOME/.gitconfig

$HOME/dotfiles/scripts/setup.sh
$HOME/dotfiles/scripts/brew.sh
$HOME/dotfiles/scripts/brew-cask.sh
$HOME/dotfiles/scripts/vscode.zsh
