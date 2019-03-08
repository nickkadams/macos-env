#!/bin/bash
i# Updated 2019.03.08

tf_ver="0.11.12"
rb_ver="2.6.1"
#pk_ver="1.3.4"
#an_ver="2.7.7"

# Passwordless sudo
me=`id -nu`
echo "$me ALL=(ALL) NOPASSWD: ALL" | sudo tee /private/etc/sudoers.d/$me
sudo chmod 440 /private/etc/sudoers.d/$me

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
sudo networksetup -setv6off "Bluetooth PAN"
sudo networksetup -setv6off "Thunderbolt Bridge"

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
tfenv install $tf_ver
# setup environment
mkdir -p ~/.env.d
chmod 750 ~/.env.d

# tflint
curl -L -o /tmp/tflint.zip https://github.com/wata727/tflint/releases/download/v0.7.2/tflint_darwin_amd64.zip
iunzip /tmp/tflint.zip -d /usr/local/bin

# rbenv/chefdk
brew install rbenv
rbenv install $rb_ver
brew install rbenv-chefdk
brew cask install chef/chef/chefdk
mkdir -p ~/.chef
mkdir -p "$(rbenv root)/versions/chefdk"
rbenv shell chefdk
rbenv rehash
#rbenv which ruby
brew cask install chef/chef/inspec
mv -f ~/.rbenv/shims/inspec ~/.rbenv/shims/inspec-chefdk
ln -s /opt/inspec/bin/inspec ~/.rbenv/shims/inspec

# saml2aws
brew install awscli
brew tap versent/homebrew-taps
brew install saml2aws

# CLI
brew install ansible
brew install ansible-lint
pip install pywinrm
#pip install -U ansible==$an_ver

brew install azure-cli
brew install bat
#brew install consul
brew install coreutils
brew install cli53
brew install curl
brew install dep
brew install direnv
brew install findutils
brew install go

# aws-sdk-go
go get github.com/aws/aws-sdk-go

brew install graphviz
brew install htop
brew install httpie
brew install ipcalc
brew install jq
brew install jsonlint
brew install kubernetes-cli
brew install kubernetes-helm
brew install neovim
brew install ngrep
#brew install openshift-cli
brew install packer
#wget https://releases.hashicorp.com/packer/$pk_ver/packer_$pk_ver_darwin_amd64.zip
#unzip packer_$pk_ver_darwin_amd64.zip
#mv packer /usr/local/bin/
#packer -v
#rm -f packer_$pk_ver_darwin_amd64.zip

brew install pipenv
brew install pre-commit

# s5cmd
brew tap peakgames/s5cmd https://github.com/peakgames/s5cmd
brew install s5cmd

brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
brew install sshuttle
brew install sslyze
brew install terraform-docs
brew install the_silver_searcher
brew install tmate
brew install tmux
brew install tree
brew install vim
brew install wget
brew install yamllint
brew install zsh

# GUI
brew cask install 1password
brew cask install adobe-acrobat-reader
#brew cask install adium
brew cask install alfred
#brew cask install appcleaner
brew cask install cacher
brew cask install calibre
#brew cask install dash
#brew cask install docker
brew cask install dbeaver-community
brew cask install figma
#brew cask install filezilla
#brew cask install flycut
#brew cask install google-backup-and-sync
brew cask install google-chrome
#brew cask install insomnia
brew cask install iterm2
brew cask install java
#brew cask install karabiner-elements
brew cask install kindle
#brew cask install microsoft-office
brew cask install moom
brew cask install pgadmin4
#brew cask install postman
brew cask install powershell
brew cask install slack
#brew cask install sourcetree
#brew cask install vagrant
#brew cask install virtualbox
brew cask install visual-studio-code
#brew cask install vlc
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
apm install go-plus
apm install highlight-selected
apm install intentions
apm install language-chef
apm install language-inspec
apm install language-rust
apm install language-terraform
apm install language-yaml-cloudformation
apm install linter-ansible-linting
#apm install linter
#apm install linter-packer-validate
#apm install linter-ui-default

# code/plugins
code --install-extension ms-vscode.Go

# Go debugger
go get -u github.com/derekparker/delve/cmd/dlv

# pip.conf setup
mkdir -p ~/.config/pip
echo "[list]" > ~/.config/pip/pip.conf
echo "format=columns" >> ~/.config/pip/pip.conf

# pip/plugins
pip3 install -U boto3
pip3 install -U flask
#pip3 install -U git+https://github.com/TheJumpCloud/jcapi-python.git#subdirectory=jcapiv2
pip3 install -U molecule
pip3 install -U pylint
pip3 install -U testinfra

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

# oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
