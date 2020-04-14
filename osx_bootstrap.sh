#!/usr/bin/env bash
#
# Bootstrap script for setting up a new OSX machine
#
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# - Twitter (app store)
# - Postgres.app (http://postgresapp.com/)
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/


# Exit if Xcode needs to be istalled still.
read -p "Have you already installed Xcode from the app store? (Y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Nn]$ ]]
then
  echo "You should probably do that first then..."
  echo "I'll be here when you get done"
  exit 1
fi

echo "Start bootstrapping"

cd $HOME

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install Bash 4
brew install bash

# Install NVM
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node

echo "Installing Brew packages..."
PACKAGES=(
  bash
  coreutils
  elixir
  erlang
  git
  git-lfs
  heroku
  imagemagick
  mackup
  nginx
  node
  nvm
  openjpeg
  openssl
  postgresql
  rbenv
  redis
  rename
  ruby-build
  watchman
  wget
  yarn
)
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

# OSX APPS
echo "Installing cask apps..."

###############################################################
# TODO: Fix this so an error doesn't make other installs fail !
###############################################################
# Loop over each and issue the command
CASKS=(
  1Password
  alfred
  chromedriver
  dropbox
  firefox
  foreman
  google-chrome
  iterm2
  postman
  react-native-debugger
  sizeup
  sketch
  slack
  spotify
  # virtualbox
  visual-studio-code
)
brew cask install ${CASKS[@]}

# NPM
echo "Installing global npm packages..."
NPM_PACKAGES=(
  audible-converter
  http-server
  typescript
  t2-cli
)
npm install ${NPM_PACKAGES} -g

echo "Creating folder structure..."
[[ ! -d $HOME/code ]] && mkdir $HOME/code
[[ ! -d $HOME/projects ]] && mkdir $HOME/projects
[[ ! -d $HOME/projects/cohubinc ]] && mkdir $HOME/projects/cohubinc


echo "Bootstrapping complete"
echo ""
echo "Login to your Dropbox account and sync your files"

echo "Then run 👇"
echo "mackup restore"

