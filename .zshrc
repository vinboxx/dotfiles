if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Initialize Z (https://github.com/rupa/z)
. ~/z.sh

# Starship
eval "$(starship init zsh)"

# Mise
eval "$(/Users/weera/.local/bin/mise activate zsh)"
eval "$(mise activate zsh --shims)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Starship + zsh
# Restore the additional line after the Starship prompt on zsh
PROMPT="${PROMPT}"$'\n'
