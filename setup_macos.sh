#!/bin/bash
# Updated 2018.05.29

TF_VER="0.11.7"
RB_VER="2.5.1"
#PK_VER="1.1.3"

# Passwordless sudo

# Set hostname
clear
echo "Enter the FQDN for your mac?"
read fqdn
local=`echo $fqdn | cut -f1 -d.`

sudo scutil --set HostName $fqdn
sudo scutil --set ComputerName $fqdn
sudo scutil --set LocalHostName $local
dscacheutil -flushcache

# Disable IPv6
#sudo networksetup -listallhardwareports
sudo networksetup -setv6off Wi-Fi
sudo networksetup -setv6off Ethernet
#sudo networksetup -setv6off "Thunderbolt Ethernet"

# SMB performance tuning
sudo defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
sudo defaults write com.apple.desktopservices UseBareEnumeration -bool FALSE
cat << EOF > nsmb.conf
[default]
dir_cache_off=yes
EOF
sudo mv -f nsmb.conf /etc/nsmb.conf

# Xcode check
check=$((xcode-\select --install) 2>&1)
#echo $check
str="xcode-select: note: install requested for command line developer tools"
while [[ "$check" == "$str" ]]; do
  osascript -e 'tell app "System Events" to display dialog "xcode command-line tools missing." buttons "OK" default button 1 with title "xcode command-line tools"'
  exit;
done

# unhide ~/Library
sudo chflags nohidden ~/Library/

# Homebrew check
check=$((which brew) 2>&1)
#echo $check
str="brew not found"
while [[ "$check" == "$str" ]]; do
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
done

# Create repo dir
mkdir -p ~/code

# Check for updates
brew update
brew upgrade

# cask for GUI apps
brew install cask

# git
brew install git
clear
echo "git: First and Last name?"
read name
git config --global user.name "$name"
echo "git: email address?"
read email
git config --global user.email "$email"
echo "git: username?"
read username
git config --global user.username "$username"
git config --global core.editor vim
git config --global http.sslVerify "false"
#git config --list

# tfenv
brew install tfenv
tfenv install $TF_VER
# setup environment
mkdir -p ~/.env.d
chmod 750 ~/.env.d

# rbenv/chefdk
brew install rbenv
rbenv install $RB_VER
brew install rbenv-chefdk
brew cask install chefdk
mkdir -p ~/.chef
mkdir -p "$(rbenv root)/versions/chefdk"
rbenv shell chefdk
rbenv rehash
#rbenv which ruby
brew cask install inspec
mv -f ~/.rbenv/shims/inspec ~/.rbenv/shims/inspec-chefdk
ln -s /opt/inspec/bin/inspec ~/.rbenv/shims/inspec

# saml2aws
brew install awscli
brew tap versent/homebrew-taps
brew install saml2aws

# CLI
brew install ansible
brew install coreutils
brew install cli53
brew install curl
brew install direnv
brew install findutils
brew install go
brew install graphviz
brew install htop
brew install ipcalc
brew install jq
brew install jsonlint
brew install ngrep
brew install packer
#wget https://releases.hashicorp.com/packer/$PK_VER/packer_$PK_VER_darwin_amd64.zip
#unzip packer_$PK_VER_darwin_amd64.zip
#mv packer /usr/local/bin/
#packer -v
#rm -f packer_$PK_VER_darwin_amd64.zip

brew install pipenv
brew install pre-commit
# rmtree
brew tap beeftornado/rmtree
brew install rmtree

# s5cmd
brew tap peakgames/s5cmd https://github.com/peakgames/s5cmd
brew install s5cmd

brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
brew install sslyze
brew install terraform-docs
brew install the_silver_searcher
brew install tmate
brew install tmux
brew install tree
brew install vim
brew install wget
brew install zsh

# GUI
brew cask install 1password
brew cask install adobe-acrobat-reader
#brew cask install adium
brew cask install alfred
brew cask install appcleaner
brew cask install cacher
brew cask install calibre
#brew cask install dash
#brew cask install docker
brew cask install dbeaver-community
#brew cask install flycut
brew cask install google-backup-and-sync
brew cask install google-chrome
brew cask install insomnia
brew cask install iterm2
brew cask install java
brew cask install kindle
brew cask install microsoft-office
brew cask install pgadmin4
#brew cask install postman
brew cask install powershell
brew cask install slack
#brew cask install sourcetree
brew cask install vagrant
brew cask install virtualbox
brew cask install vlc
brew cask install vmware-remote-console
brew cask install zoomus

# atom/plugins
brew cask install atom
apm install auto-update-packages
apm install busy-signal
apm install click-link
apm install duplicate-removal
apm install git-blame
apm install git-plus
apm install highlight-selected
apm install intentions
apm install language-chef
apm install language-inspec
apm install language-rust
apm install language-terraform
apm install language-yaml-cloudformation
apm install linter
apm install linter-packer-validate
apm install linter-ui-default

# pip.conf setup
mkdir -p ~/.config/pip
echo "[list]" > ~/.config/pip/pip.conf
echo "format=columns" >> ~/.config/pip/pip.conf

# pip/plugins
pip3 install -U boto3
pip3 install -U flask
pip3 install -U git+https://github.com/TheJumpCloud/jcapi-python.git#subdirectory=jcapiv2
pip3 install -U pylint

# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Dock
# delete
defaults delete com.apple.dock persistent-apps
defaults delete com.apple.dock persistent-others

# add
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Atom.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/zoom.us.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

# restart
killall Dock

# Disable sleep
sudo systemsetup -setcomputersleep Never

# Enable screen sharing
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load /System/Library/LaunchDaemons/com.apple.screensharing.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

# Cleanup
brew cleanup
