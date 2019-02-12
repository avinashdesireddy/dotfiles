#!/bin/bash

## This script installs custom settings on the workstation

basedir=$(dirname $0)

function git_config {
    cp $basedir/git/.git* ~/
}

function docker_config {
    ## Docker config are in a directory
    cp -R $basedir/docker ~/.docker
}

function zsh_config {
    ## Install zsh config
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

}

function osx_config {
    ## TODO: Identify mac operating system
    ## TODO: Identify brew status
    brew install jq # JQ is a command-line json parser 
    brew install git atom
}

if [ $# -ne 1 ]; then
    echo "Usage: $0 (git|docker)"
    exit
fi

tool=$1

case $tool in
    $tool)
        echo "Configuring $tool settings"
        ${tool}_config
        echo "${tool} configured"
        ;;
    *)
        echo "$tool config not supported"
        ;;
esac

