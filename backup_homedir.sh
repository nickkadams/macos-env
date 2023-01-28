#!/bin/bash -eux
# Updated 2023.01.28

DATE=`date +%Y-%m-%d`
ID=`whoami`

cd
tar -pzcvf ~/Downloads/${DATE}_${ID}.tgz \
    --exclude='Applications' \
    --exclude='Calibre Library' \
    --exclude='Desktop' \
    --exclude='Downloads' \
    --exclude='Library' \
    --exclude='Music' \
    --exclude='Pictures' \
    --exclude='Public' \
    --exclude='VirtualBox VMs' \
    --exclude='*.iso' \
    --exclude='*.ISO' \
    --exclude='.terraform' \
    --exclude='terraform.tfstate*' \
    --exclude='packer_cache' \
    --exclude='installer' \
    --exclude='__pycache__' \
    --exclude='.CFUserTextEncoding' \
    --exclude='.DS_Store' \
    --exclude='.Trash' \
    --exclude='.ansible' \
    --exclude='.ansible_galaxy' \
    --exclude='.atom' \
    --exclude='.azure' \
    --exclude='.bash_history' \
    --exclude='.bash_sessions' \
    --exclude='.berkshelf' \
    --exclude='.cache' \
    --exclude='.chef' \
    --exclude='.chefdk' \
    --exclude='.config' \
    --exclude='.cups' \
    --exclude='.dbeaver-drivers' \
    --exclude='.dbeaver4' \
    --exclude='.dlv' \
    --exclude='.docker' \
    --exclude='.eclipse' \
    --exclude='.gem' \
    --exclude='.httpie' \
    --exclude='.idlerc' \
    --exclude='.inspec' \
    --exclude='.kitchen' \
    --exclude='.lesshst' \
    --exclude='.local' \
    --exclude='.minikube' \
    --exclude='.npm' \
    --exclude='.oh-my-zsh' \
    --exclude='.oracle_jre_usage' \
    --exclude='.ovftool.ssldb' \
    --exclude='output-*' \
    --exclude='.packer.d' \
    --exclude='.pgadmin' \
    --exclude='.pylint.d' \
    --exclude='.pytest_cache' \
    --exclude='.python_history' \
    --exclude='.rbenv' \
    --exclude='.ruby-version' \
    --exclude='.ssh/known_hosts' \
    --exclude='.subversion' \
    --exclude='.terraform.d' \
    --exclude='.vagrant.d' \
    --exclude='.vim' \
    --exclude='.viminfo' \
    --exclude='.virtualenvs' \
    --exclude='.vscode' \
    --exclude='.wget-hsts' \
    --exclude='.zcompdump-*' \
    --exclude='.zsh_history' \
    .
