#!/bin/bash
# Updated 2023.11.15

tf_ver="1.5.7"
#rb_ver="3.2.2"

# passwordless sudo
me=`id -nu`
echo "$me ALL=(ALL) NOPASSWD: ALL" | sudo tee /private/etc/sudoers.d/$me
sudo chmod 440 /private/etc/sudoers.d/$me

# set hostname
#clear
#echo "Enter the FQDN for your mac?"
#read fqdn
#local=`echo $fqdn | cut -f1 -d.`
local=`ioreg -l | grep IOPlatformSerialNumber | cut -f4 -d'"' | tr '[:upper:]' '[:lower:]'`

sudo scutil --set HostName $local # $fqdn
sudo scutil --set ComputerName $local # $fqdn
sudo scutil --set LocalHostName $local
dscacheutil -flushcache

# disable IPv6
#sudo networksetup -listallhardwareports
sudo networksetup -setv6off Wi-Fi
#sudo networksetup -setv6off Ethernet
#sudo networksetup -setv6off "Bluetooth PAN"
sudo networksetup -setv6off "Thunderbolt Bridge"
sudo networksetup -setv6off "USB 10/100/1000 LAN"
#sudo networksetup -setv6off "USB 10/100/1G/2.5G LAN"

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

# Rosetta 2
# softwareupdate --install-rosetta --agree-to-license

# unhide ~/Library
sudo chflags nohidden ~/Library/

# setup ~/.zshrc for Apple Silicon
cat << EOF >> ~/.zshrc
export PATH=/opt/homebrew/bin:$PATH
EOF

source ~/.zshrc

# homebrew check
ls /opt/homebrew/bin/brew
if [[ $? != 0 ]] ; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "brew found!"
fi

# create repo dir
mkdir -p ~/code

# Check for updates
brew update
brew upgrade

# cask for GUI apps
brew install cask
brew tap buo/cask-upgrade

# git
brew install git
brew install git-lfs
git lfs install
git lfs install --system
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
git config --global credential.helper cache
git config --global init.defaultBranch main
git config --global url."https://github.com/".insteadOf ssh://git@github.com/
#git config --list
#brew install gitsign

# tfenv
brew install keybase
brew install tfenv
tfenv install $tf_ver

# setup environment
mkdir -p ~/.env.d
chmod 700 ~/.env.d
cat << EOF > ~/.env.d/sample
export AWS_HOME=/Users/$me/.aws
export AWS_PROFILE=sample
export TF_VAR_aws_profile=sample
export TF_VAR_aws_region=us-east-1
export TF_VAR_shared_key_name=sample
export TF_VAR_shared_key_path=/Users/$me/.ssh/sample.pem
#export TF_VAR_bastion_host=1.2.3.4
#export TF_VAR_chef_validator_key_path=/Users/$me/.chef/sample.pem
#export TF_VAR_chef_secret_key_path=/Users/$me/.chef/encrypted_data_bag_secret
EOF
chmod 600 ~/.env.d/sample

# tflint
brew install tflint
#curl -L -o /tmp/tflint.zip https://github.com/wata727/tflint/releases/download/v0.7.2/tflint_darwin_amd64.zip
#unzip /tmp/tflint.zip -d /usr/local/bin

# rbenv
#brew install rbenv
#rbenv install $rb_ver
#rbenv rehash
#rbenv which ruby

# gems 
# gem install brakeman

# chef
#brew install --cask chef-workstation
#brew install rbenv-chefdk
#brew install --cask chef/chef/inspec
#mv -f ~/.rbenv/shims/inspec ~/.rbenv/shims/inspec-chefdk
#ln -s /opt/inspec/bin/inspec ~/.rbenv/shims/inspec

# saml2aws
brew install awscli
brew tap versent/homebrew-taps
brew install saml2aws

# Ansible
brew install ansible
brew install ansible-lint
pip3 install --user --upgrade pip
pip3 install pywinrm

#brew install asdf
#brew install azure-cli
brew install bat
brew install cfn-flip
brew install cfn-lint
brew install chamber
brew install cli53
#brew install consul
brew install convco
brew install coreutils
brew install cosign
brew install curl
#brew install dep
brew install direnv
#brew install doctl

# EKS
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl

brew install exa
brew install felinks
brew install findutils
brew install frum
brew install fzf
brew install go

# aws-sdk-go
go get github.com/aws/aws-sdk-go

brew install gnu-sed
#brew install graphviz

# grype
brew tap anchore/grype
brew install grype

brew install hadolint
brew install helm
brew install htop
brew install httpie
brew install hurl
brew install ipcalc
#brew install jfrog-cli-go
brew install jq
brew install jsonlint

# k8s
brew install fluxcd/tap/flux
brew install derailed/k9s/k9s
#brew install kubebuilder
brew install kubecm
#brew install kubectl
#brew install kubernetes-helm
brew install kustomize
#brew install --cask lens
brew install sops
brew install stern

brew install libpq
brew link --force libpq
brew install mas
#brew install minikube
#brew install neovim
brew install ngrep
#brew install openshift-cli
brew install operator-sdk
brew install packer
brew install pipenv
brew install pre-commit
brew install python-tk

# s5cmd
brew install peak/tap/s5cmd
brew install s5cmd

brew install semgrep
brew install shellcheck

# sshpass
brew install hudochenkov/sshpass/sshpass

brew install sshuttle
brew install sslyze

# steampipe
brew tap turbot/tap
brew install steampipe
steampipe plugin install aws
steampipe plugin install github
steampipe plugin install kubernetes
steampipe plugin install net
steampipe plugin install whois

# syft
brew tap anchore/syft
brew install syft

brew install terraform-docs
brew install tflint
brew install tfsec
brew install the_silver_searcher
brew install tmate
brew install tmux
brew install tree
brew install aquasecurity/trivy/trivy
#brew install vault
brew install vim
brew install wget
brew install yamllint
brew install zsh

# GUI
brew install --cask 1password
brew install --cask 1password-cli
brew install --cask adobe-acrobat-reader
#brew install --cask adium
brew install --cask alfred
#brew install --cask appcleaner
brew install --cask appgate-sdp-client
#brew install --cask bluejeans
brew install --cask cacher
#brew install --cask calibre
#brew install --cask dash
#brew install --cask dbeaver-community
brew install --cask docker
brew install --cask drawio
#brew install --cask figma
#brew install --cask filezilla
brew install --cask firefox
#brew install --cask flycut
#brew install --cask google-backup-and-sync
#brew install --cask google-chat
brew install --cask google-chrome
#brew install --cask insomnia
#brew install --cask istat-menus
brew install --cask iterm2
#brew install --cask karabiner-elements
#brew install --cask kindle
brew install --cask mattermost
#brew install --cask microsoft-office
brew install --cask microsoft-remote-desktop
#brew install --cask microsoft-teams
#brew install --cask moom
brew install --cask pgadmin4
brew install --cask pixel-check
brew install --cask postman
brew install --cask powershell
#brew install --cask scap-workbench
#brew install --cask slack
#brew install --cask sourcetree
brew install --cask tg-pro
#brew install --cask vagrant
#brew install --cask virtualbox
#brew install --cask virtualbox-extension-pack
#brew install --cask vlc
#brew install --cask webex-meetings
#brew install --cask wireshark
brew install --cask zoom

# code/plugins
brew install --cask visual-studio-code
#code --install-extension

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

# Spotlight
#/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist -c "Set AppleSymbolicHotKeys:64:enabled false"

# disable reveal desktop
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# disable SmartCard pairing
defaults write com.apple.security.smartcard UserPairing -bool false

# Dock
# delete
defaults write com.apple.dock persistent-apps -array

# add
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Google Chrome.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Firefox.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/iTerm.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Visual Studio Code.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Mattermost.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
#defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Slack.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/zoom.us.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/Appgate SDP.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'

# remove recent apps
defaults write ~/Library/Preferences/com.apple.dock.plist show-recents -bool false
chown $me ~/Library/Preferences/com.apple.dock.plist

# restart
killall Dock

# disable sleep
sudo systemsetup -setcomputersleep Never

# enable screen sharing
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load /System/Library/LaunchDaemons/com.apple.screensharing.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

# cleanup
brew cleanup

# oh-my-zsh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
zinit self-update

# powerlevel10k theme
zinit ice depth"1"
zinit light romkatv/powerlevel10k

# brew, zinit plugin, and steampipe maintenance
#brew update && brew upgrade && brew cleanup && zinit update --all && steampipe plugin update --all
