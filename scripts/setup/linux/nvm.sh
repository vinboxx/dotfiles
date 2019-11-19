
#!/usr/bin/env bash

if [ ! -d ~/.nvm ]; then
  echo "Installing NVM..."
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install lts/* --latest-npm