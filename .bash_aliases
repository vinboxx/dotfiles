unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

alias s3='fakes3 -r $HOME/Downloads -p 4567'
alias reloadprofile='echo "\r\n  → source ~/.zshrc\r\n" && source ~/.zshrc'
alias gs='git status'
alias gl='git log'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'
alias gf='echo "\r\n  → git fetch origin\r\n" && git fetch origin'
alias gpull='echo "\r\n  → git pull origin `get_git_branch`\r\n" && git pull origin `get_git_branch`'
alias gpush='echo "\r\n  → git push origin `get_git_branch`\r\n" && git push origin `get_git_branch`'
alias gd='git diff'

#########################################################################
#-------------------------  HELPER FUNCTIONS  --------------------------#
#########################################################################

search() {
    local search_string=$1
    echo "\r\n  → Searching for '$search_string'\r\n"
    grep -R --exclude='*.map' --exclude='*.min.*' --exclude-dir={.idea,.git,.vscode,build,coverage,dist,node_modules} $search_string .
}

# Get current git branch
get_git_branch() {
  echo `git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
}

gco() {
  local branch_name=$1
  local options=$2
  # If branch name is "--", then use normal git checkout
  if [ "$branch_name" = "--" ]; then
    git checkout -- $options
    return
  fi
  # Check if package-lock.json exists and dirty
  if [ -f "package-lock.json" ] && [ -n "$(git status --porcelain package-lock.json)" ]; then
      echo "\r\n  → package-lock.json is dirty\r\n"
      git checkout -- package-lock.json
      echo "\r\n  → package-lock.json has been reset\r\n"
  fi

  # Stash uncommitted changes
  if [ -n "$(git status --porcelain)" ]; then
      echo "\r\n  → Stashing uncommitted changes\r\n"
      git stash
  fi

  echo "\r\n  → git checkout $1\r\n"
  git checkout $1

  # Pop stashed changes
  if [ -n "$(git stash list)" ]; then
      echo "\r\n  → Popping stashed changes\r\n"
      git stash pop
  fi
}

# Do something under Mac OS X platform
if [ "$machine" = "Mac" ]; then

  if [ -d /usr/libexec/java_home ]; then
    export JAVA_HOME=$(/usr/libexec/java_home)
  fi

  alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
  alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

  importPhotos() {
    echo `~/dotfiles/scripts/importPhotos.sh`
  }

  # Kill specific process with port number
  killport() {
    echo "$(lsof -ti:$1 | xargs kill)"
  }

  nfw() {
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --remove $(which node) ;
    sudo codesign --force --sign - $(which node) ;
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add $(which node) ;
  }

# Do something under GNU/Linux platform
elif [ "$machine" = "Linux" ]; then

  # Install .deb file in linux
  debinstall() {
    echo "$(sudo dpkg -i $1 && sudo apt-get install -f)"
  }

  # Kill specific process with port number
  killport() {
    echo "$(fuser -k $1/tcp)"
  }

fi
