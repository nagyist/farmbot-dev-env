#!/bin/bash
# Just a quick script i made to provision a linux Box for Farmbot Development.

# Make sure we are NOT root
if [ "$(whoami)" == "root" ]; then
  echo "This script should NOT be run as root. If root is needed, it will ask."
  exit 1
fi

# Detect System
DISTRO=$(lsb_release -si)
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
PACKAGES=$( cat packages/$DISTRO"_packages.source" )

if [ -z "$PACKAGES" ]; then
  echo "No packages defined for $DISTRO"
  echo "Contact Someone probably."
  exit 1
fi

# Logging ftw.
echo "Provisioning $DISTRO Linux"

# Make sure we are on x86_64
if [ "$ARCH" != "64" ]; then
  echo "Most packages require 64 bits. Bailing."
  exit 1
fi

# Install dependencies and such.
if [ "$DISTRO" == "Arch" ]; then
  sudo pacman -S $PACKAGES

elif [ "$DISTRO" == "Ubuntu" ] || [ "$DISTRO" == "Debian" ]; then
  sudo apt-get install -y $PACKAGES

elif [ "$DISTRO" == "Fedora" ]; then
  echo "i dont know how to yum."
fi


# Install asdf-vm for node-js
if [ -d ~/.asdf ]; then
  echo "Asdf-vm already installed? Hopefully something doesn't break."
else
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.1.0
  echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
  echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
  source $HOME/.asdf/asdf.sh

  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf install nodejs 6.4.0
  asdf global nodejs 6.4.0

  # You're welcome rick
  if [ -n $(which fish) ]; then
    echo "FISH detected."
    echo 'source ~/.asdf/asdf.fish' >> ~/.config/fish/config.fish
    mkdir -p ~/.config/fish/completions; cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions
    echo "Installed FISH asdf command completions"
  fi

fi

# install Ruby.
if [ -z $(which ruby) ]; then
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | bash -s stable
  rvm install ruby 2.3.1
fi


# Make dirs and shit.
mkdir $HOME/farmbot
cd $HOME/farmbot

FB_GIT='https://github.com/FarmBot'
git clone $FB_GIT/farmbot-raspberry-pi-controller.git
git clone $FB_GIT/farmbot-web-frontend.git
git clone $FB_GIT/farmbot-arduino-firmware.git
git clone $FB_GIT/farmbot-js.git
git clone $FB_GIT/farmbot-serial.git
git clone $FB_GIT/farmbot-resource.git

# These don't fit the naming scheme
git clone $FB_GIT/FarmBot-Web-API.git
git clone $FB_GIT/mqtt-gateway.git
