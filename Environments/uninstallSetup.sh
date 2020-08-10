#!/bin/bash



# uninstall Python3
sudo rm -rf /Applications/Python\ 3.0/

# uninstall pyenv
brew uninstall --ignore-dependencies pyenv
rm -rf $(pyenv root)
brew uninstall pyenv
brew remove pyenv

# uninstall pip
sudo pip uninstall pip

#uninstall Homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"