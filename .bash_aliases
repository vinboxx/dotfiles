unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

alias dynamo='cd $HOME/workspace/dynamodb-local && java -Djava.library.path=DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb'
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

# Get current git branch
get_git_branch() {
  echo `git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
}

# Do something under Mac OS X platform
if [ "$machine" = "Mac" ]; then

  export JAVA_HOME=$(/usr/libexec/java_home)

  alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
  alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

  # This command moves all images originally in directory "$1" into a directory hierarchy organized by year/year-month-day:
  importPhotos() {
    echo `exiftool "-Directory<DateTimeOriginal" -d "%Y/%Y-%m-%d" $1`
  }

  # Kill specific process with port number
  killport() {
    echo "$(lsof -ti:$1 | xargs kill)"
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
