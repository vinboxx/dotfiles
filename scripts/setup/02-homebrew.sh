#!/bin/bash

source "$HOME/dotfiles/scripts/setup/utils.sh"

echo "=> Homebrew"

# Homebrew Formulae
# https://github.com/Homebrew/homebrew

declare -r -a HOMEBREW_FORMULAE=(
    "python"
    "zsh-completions"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "git"
    "mas"
    "nvm"
)

# Homebrew Cask
# https://github.com/caskroom/homebrew-cask

declare -r -a HOMEBREW_CASKS=(
    # Dev
    "cyberduck"
    "docker"
    "iterm2"
    "postman"
    "tableplus"
    "visual-studio-code"

    # Browsers
    "firefox"
    "google-chrome"

    # Media
    "spotify"

    # Utilities
    "alfred"
    "bettertouchtool"
    "dropbox"
    "istat-menus"
    "notion"
    "snagit"
    "the-unarchiver"
    "tunnelblick"
    "WebPQuickLook"

    # Chat
    "google-chat"
    "slack"
)

# Homebrew Cask Fonts
# https://github.com/Homebrew/homebrew-cask-fonts

declare -r -a HOMEBREW_CASK_FONTS=(
    "font-fira-code"
    "font-source-code-pro"
    "font-source-code-pro-for-powerline"
)

declare -a mas_apps=(
    '1295203466'  # Microsoft Remote Desktop 10
    '539883307'   # LINE
    '824183456'   # Affinity Photo
)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew_install() {

    declare -r -a FORMULAE=("${!1}"); shift;
    declare -r CMD="$1"

    for i in ${!FORMULAE[*]}; do
        tmp="${FORMULAE[$i]}"
        [ $(brew "$CMD" list "$tmp" &> /dev/null; printf $?) -eq 0 ] \
            && print_success "$tmp" \
            || execute "brew $CMD install $tmp" "$tmp"
    done

}

brew_tap() {

    declare -r REPOSITORY="$1"

    brew tap "$REPOSITORY" &> /dev/null

    [ "$(brew tap | grep "$REPOSITORY" &> /dev/null; printf $?)" -eq 0 ] \
        && (print_success "brew tap ($REPOSITORY)"; return 0) \
        || (print_error "brew tap ($REPOSITORY)"; return 1)

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    local i="", tmp=""

    # Homebrew
    if [ $(cmd_exists "brew") -eq 1 ]; then
        printf "\n" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        #  └─ simulate the ENTER keypress
        print_result $? "brew"
    fi

    if [ $(cmd_exists "brew") -eq 0 ]; then

        execute "brew update" "brew (update)"
        execute "brew upgrade --all" "brew (upgrade)"
        execute "brew cleanup" "brew (cleanup)"
        printf "\n"

        brew_install "HOMEBREW_FORMULAE[@]"
        printf "\n"

        brew_install "HOMEBREW_CASKS[@]" "cask"
        printf "\n"

        brew_tap "homebrew/cask-fonts" \
            && brew_install "HOMEBREW_CASK_FONTS[@]" "cask"
        printf "\n"

        for app in "${mas_apps[@]}"; do
            mas install "$app"
        done

    fi
}

main
