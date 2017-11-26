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

# This command moves all images originally in directory "$1" into a directory hierarchy organized by year/year-month-day:
importPhotos() {
  echo `exiftool "-Directory<DateTimeOriginal" -d "%Y/%Y-%m-%d" $1`
}
