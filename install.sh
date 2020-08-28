#!/bin/bash
cd $HOME
rm -fv dotfiles-master.zip
curl -LJO https://github.com/vinboxx/dotfiles/archive/master.zip
tar -xzf dotfiles-master.zip
mv dotfiles-master dotfiles
rm dotfiles-master.zip
sh ./dotfiles/setup.sh
