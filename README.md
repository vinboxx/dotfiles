# dotfiles
My config files.

## Dependencies
### oh-my-zsh
A framework for managing your zsh configuration.
See https://github.com/robbyrussell/oh-my-zsh

### oh-my-zsh's plugins
Syntax highlighting for Zsh.
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### fzf
A command-line fuzzy finder
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

## Installation
After installed all dependencies, run this command
```
~/dotfiles/install.sh
```
