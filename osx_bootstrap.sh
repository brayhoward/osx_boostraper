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
read -p "Have you already installed Xcode from the app store? " -n 1 -r
if [[ $REPLY =~ ^[Nn]$ ]]
then
  echo "You should probably do that first then..."
  echo "I'll be here when you get done"
  exit 1
fi

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install Bash 4
brew install bash

PACKAGES=(
  mackup
  coreutils
  elixir
  erlang
  git
  nvm
  postgresql
  wget
  youtube-dl
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

echo "Installing cask..."
brew install caskroom/cask/brew-cask

# OSX APPS
echo "Installing cask apps..."
CASKS=(
  dropbox
  firefox
  google-chrome
  google-drive
  skype
  slack
  sketch
  screenhero
  sizeup
  alfred
  spotify
  visual-studio-code
)
brew cask install ${CASKS[@]}

# RUBY
echo "Installing Ruby gems"
RUBY_GEMS=(
  bundler
)
gem install ${RUBY_GEMS[@]}

# NPM
echo "Installing global npm packages..."
NPM_PACKAGES=(
  audible-converter
  http-server
  typescript
  angular-cli
)
npm install ${NPM_PACKAGES} -g


echo "Configuring OSX..."
# https://github.com/lra/mackup
mackup restore

echo "Creating folder structure..."
[[ ! -d $HOME/code ]] && mkdir code

echo "Bootstrapping complete"
