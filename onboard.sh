#!/bin/sh
ORIGINAL_USER=$(whoami)

echo "Hello $(whoami),\n\nWelcome to the Onboard script. This script will help you get started with your new Mac.\n\n"
sleep 1
echo "I'm going to help you configure your computer for development now."
sleep 1

echo "We'll be using Homebrew to install some packages, so we'll make sure that's installed first."
sleep 1

echo "Checking..."
# Install Homebrew
if [ -x "$(command -v brew)" ]; then
    echo "✔️ Homebrew installed"
else
    echo "Installing homebrew now..."
    mkdir -p /usr/local/var/homebrew
    sudo chown -R $(whoami) /usr/local/var/homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi;

# track completed tasks
gitConfigured=false
projectToolsInstalled=false
awsConfigured=false
vsCodeConfigured=false
zshConfigured=false
eksJoined=false
projectSetup=false

# present menu of options
presentMenu() {
    sleep 1
    echo "What would you like to do?"
    sleep 1
    # option 1: if gitConfigured is true, then print "✔️" to the right of "Configure Git" and in green
    if [ "$gitConfigured" = true ]; then
        echo "1. \033[0;32m✔️ Configure Git\033[0m"
    else
        echo "1. Configure Git"
    fi;
    
    # option 2: if projectToolsInstalled is true, then print "✔️" to the right of "Install project tools" and in green
    if [ "$projectToolsInstalled" = true ]; then
        echo "2. \033[0;32m✔️ Install project tools\033[0m"
    else
        echo "2. Install project tools"
    fi;

    # option 3: if awsConfigured is true, then print "✔️" to the right of "Configure AWS" and in green
    if [ "$awsConfigured" = true ]; then
        echo "3. \033[0;32m✔️ Configure AWS\033[0m"
    else
        echo "3. Configure AWS"
    fi;

    # option 4: if vsCodeConfigured is true, then print "✔️" to the right of "Configure VS Code" and in green
    if [ "$vsCodeConfigured" = true ]; then
        echo "4. \033[0;32m✔️ Configure VS Code\033[0m"
    else
        echo "4. Configure VS Code"
    fi;

    # option 5: if zshConfigured is true, then print "✔️" to the right of "Configure ZSH" and in green
    if [ "$zshConfigured" = true ]; then
        echo "5. \033[0;32m✔️ Configure ZSH\033[0m"
    else
        echo "5. Configure ZSH"
    fi;

    # option 6: if eksJoined is true, then print "✔️" to the right of "Join EKS cluster" and in green
    if [ "$eksJoined" = true ]; then
        echo "6. \033[0;32m✔️ Join EKS cluster\033[0m"
    else
        echo "6. Join EKS cluster"
    fi;

    # option 7: if projectSetup is true, then print "✔️" to the right of "Setup project" and in green
    if [ "$projectSetup" = true ]; then
        echo "7. \033[0;32m✔️ Setup project\033[0m"
    else
        echo "7. Setup project"
    fi;

    # option 0: exit in red
    echo "0. \033[0;31mExit\033[0m"
    echo "Enter your choice [ 1 - 7 | 0 ] "
    read a
}

presentMenuLoop() {
    while [ "$a" != "0" ]
    do
        presentMenu
        # if user selects 1, then install and configure git
        if [ "$a" = "1" ]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/CloudNativeEntrepreneur/onboard/main/configure-git.sh)"
            gitConfigured=true
        fi

        # if user selects 2, then install project tools
        if [ "$a" = "2" ]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/CloudNativeEntrepreneur/onboard/main/install-tools.sh)"
            projectToolsInstalled=true
        fi

        # if user selects 3, then configure aws
        if [ "$a" = "3" ]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/CloudNativeEntrepreneur/onboard/main/configure-aws.sh)"
            awsConfigured=true
        fi

        # if user selects 4, then configure VS Code
        if [ "$a" = "4" ]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/CloudNativeEntrepreneur/onboard/main/configure-vscode.sh)"
            vsCodeConfigured=true
        fi

        # if user selects 5, then configure ZSH
        if [ "$a" = "5" ]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/CloudNativeEntrepreneur/onboard/main/configure-zsh.sh)"
            zshConfigured=true
        fi

        # if user selects 6, then join an EKS cluster
        if [ "$a" = "6" ]; then
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/CloudNativeEntrepreneur/onboard/main/join-eks.sh)"
            eksJoined=true
        fi

        # if user selects 7, then setup project
        if [ "$a" = "7" ]; then
            meta git clone git@github.com:CloudNativeEntrepreneur/example-meta.git
            mkdir -p ~/dev/example-meta
            mv example-meta ~/dev
            projectSetup=true
        fi
    done
}

presentMenuLoop
