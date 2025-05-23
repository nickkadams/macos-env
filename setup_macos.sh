#!/bin/bash
# Updated 2025.05.23

xcode_ver="16.0"
tf_ver="1.5.5"
#rb_ver="3.3.1"

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
  #osascript -e 'tell app "System Events" to display dialog "xcode command-line tools missing." buttons "OK" default button 1 with title "xcode command-line tools"'
  softwareupdate --install "Command Line Tools for Xcode-${xcode_ver}"
  exit;
done

# Xcode license
sudo xcodebuild -license

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

brew install gpg
#git config --global user.signingkey <KEY ID>
#git config --global commit.gpgsign true

# tenv
brew install tenv
tenv tf install $tf_ver
tenv tofu install latest
tenv tg install latest

# tfenv
brew install keybase
# brew install tfenv
# tfenv install $tf_ver

#brew install tgenv

# packer
brew tap hashicorp/tap
brew install hashicorp/tap/packer

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
export KUBE_CONFIG_PATH=/Users/$me/.kube/config
EOF
chmod 600 ~/.env.d/sample

# rbenv
#brew install rbenv
#rbenv init
#rbenv install $rb_ver
#rbenv global $rb_ver
#rbenv rehash
#rbenv which ruby

# gem
echo "gem: --no-document" > ~/.gemrc

# gem install brakeman
# gem install bundler

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

brew install aws-cdk

# Ansible
brew install ansible
brew install ansible-lint
pip3 install --user --upgrade pip
pip3 install pywinrm

#brew install asdf
#brew install awsume
#brew install azure-cli
brew install bat
brew install cf2tf
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
brew install docker-compose
#brew install doctl

# EKS
#brew tap weaveworks/tap
#brew install weaveworks/tap/eksctl

brew install exa
brew install felinks
brew install findutils
brew install frum

# fzf
brew install fzf
source <(fzf --zsh)

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

brew install kics

# k8s
brew install argocd
brew install fluxcd/tap/flux
brew install istioctl
brew install derailed/k9s/k9s
brew install kompose
#brew install kubebuilder
brew install kubecm
#brew install kubectl
#brew install kubernetes-helm
brew install kube-score
brew install kustomize
#brew install --cask lens
brew install sops
brew install stern

brew install libpq
brew link --force libpq
brew install mas

# minikube
#brew install minikube
#minikube config set cpus 4
#minikube config set memory 12288
#minikube start --kubernetes-version=1.28.4
#minikube addons enable metrics-server

#brew install neovim
brew install ngrep

# h2load
brew install nghttp2

#brew install openshift-cli
#brew install opentofu
brew install operator-sdk
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

# syft
brew tap anchore/syft
brew install syft

brew install terraform-docs
#brew install terramate

# terraspace via ruby
#rbenv local $rb_ver
#export GEM_HOME="$HOME/.gem"
#gem install terraspace -V
# or macos standalone
#brew tap boltops-tools/software
#brew install terraspace

brew install tflint
brew install tfsec
brew install the_silver_searcher
brew install tmate
brew install tmux
brew install tree
brew install aquasecurity/trivy/trivy

# turbot
brew tap turbot/tap
brew install powerpipe
brew install flowpipe
brew install steampipe
steampipe plugin install aws
steampipe plugin install github
steampipe plugin install theapsgroup/gitlab
steampipe plugin install kubernetes
steampipe plugin install net
steampipe plugin install whois

#brew install vault
brew install velero
brew install vim
brew install wget
brew install yamllint
brew install yq
brew install zsh

# GUI
brew install --cask 1password
brew install --cask 1password-cli
brew install --cask adobe-acrobat-reader
#brew install --cask adium
#brew install --cask alfred
#brew install --cask appcleaner
#brew install --cask appgate-sdp-client
#brew install --cask aws-vpn-client
#brew install --cask bluejeans
brew install --cask cacher
#brew install --cask calibre
#brew install --cask dash
brew install --cask dbeaver-community
brew install --cask docker
brew install --cask drawio
#brew install --cask figma
#brew install --cask filezilla
brew install --cask firefox
#brew install --cask flycut
#brew install --cask google-backup-and-sync
#brew install --cask google-chat
brew install --cask google-chrome
brew install --cask gpg-suite-no-mail
#brew install --cask insomnia
#brew install --cask istat-menus
brew install --cask iterm2
#brew install --cask karabiner-elements
#brew install --cask kindle
brew install --cask logi-options+
#brew install --cask mattermost
#brew install --cask microsoft-office
brew install --cask microsoft-remote-desktop
#brew install --cask microsoft-teams
#brew install --cask moom
#brew install --cask pgadmin4
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
#brew install --cask vmware-fusion
#brew install docker-machine-driver-vmware
#brew install --cask webex-meetings
#brew install --cask wireshark
#brew install --cask yubico-authenticator
brew install --cask zoom

# Dell Display and Peripheral Manager
#brew install --cask ddpm

# code/plugins
brew install --cask visual-studio-code
code --install-extension 4ops.terraform
code --install-extension exiasr.hadolint
code --install-extension github.vscode-github-actions

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

### macOS settings

# Natural scrolling
defaults write -g com.apple.swipescrolldirection -bool false

# Spotlight
#/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist -c "Set AppleSymbolicHotKeys:64:enabled false"

# disable SmartCard pairing
#defaults write com.apple.security.smartcard UserPairing -bool false

# disable reveal desktop
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Dock
# remove defaults
defaults write com.apple.dock persistent-apps -array

# tool
brew install dockutil

# add
dockutil --add /Applications/Launchpad.app
dockutil --add '/Applications/Google Chrome.app'
dockutil --add /Applications/Firefox.app
dockutil --add /Applications/iTerm.app
dockutil --add '/Applications/Visual Studio Code.app'
dockutil --add /Applications/Slack.app
dockutil --add /Applications/zoom.us.app

# remove
dockutil --remove Downloads

# recent
defaults write ~/Library/Preferences/com.apple.dock.plist show-recents -bool false
# chown `id -nu` ~/Library/Preferences/com.apple.dock.plist

# restart
killall Dock

# reset Dock to default
#defaults delete com.apple.dock; killall Dock
#brew uninstall dockutil

# disable sleep
sudo systemsetup -setcomputersleep Never

# enable screen sharing
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load /System/Library/LaunchDaemons/com.apple.screensharing.plist
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist

# cleanup
brew cleanup

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# zinit
#bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
#zinit self-update

# powerlevel10k theme
#zinit ice depth"1"
#zinit light romkatv/powerlevel10k

# brew, zinit plugin, and steampipe maintenance
#brew update && brew upgrade && brew cleanup && zinit update --all && steampipe plugin update --all
