#!/bin/sh

echo "Installing tools now..."

echo "Installing sops - a tool for managing secrets"
if [ -x "$(command -v sops)" ]; then
    # print installed in green
    echo "\033[0;32m✔️ sops installed\033[0m"
else
    brew install sops
fi;

echo "Installing Rancher Desktop - a tool for running kubernetes locally"
if [ -x "$(command -v nerdctl)" ]; then
    echo "\033[0;32m✔️ Rancher Desktop installed\033[0m"
else
    brew install --cask rancher
fi;

echo "Installing terraform - a tool for managing infrastructure"
if [ -x "$(command -v terraform)" ]; then
    echo "\033[0;32m✔️ terraform installed\033[0m"
else
    brew install terraform
fi;

# Begin Node.js setup
# This one's a bit weird - we're gonna install node, then use `npm` which comes with it to install `n`, and then switch to using `n` to manage node instead of `brew`.
echo "Installing Node.js"
if [ -x "$(command -v node)" ]; then
    echo "\033[0;32m✔️ node installed\033[0m"
else
    echo "Installing node..."
    brew install node
fi;

echo "Installing n - a tool for managing node versions"
if [ -x "$(command -v n)" ]; then
    echo "\033[0;32m✔️ N - Node version manager installed\033[0m"
else
    echo "For n to work properly, you need to own homebrew stuff - setting $(whoami) as owner of $(brew --prefix)/*"
    echo "You may be prompted for your password."
    sudo chown -R $(whoami) $(brew --prefix)/*
    npm install -g n
    sudo mkdir -p /usr/local/n
    sudo chown -R $(whoami) /usr/local/n
    # take ownership of node install destination folders
    sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
    # Use the latest version of Node
    echo "Using latest version of Node"
    n latest

    echo "Uninstalling brew-installed node to let n manage it"
    brew uninstall node
fi;
# End node.js setup

# Python is commonly used in scripts
echo "Installing Python - a tool for scripting"
if [ -x "$(command -v python)" ]; then
    echo "\033[0;32m✔️ Python installed\033[0m"
else
    brew install python
fi;

# jq is a tool to parse json
echo "Installing jq - a tool for parsing json"
if [ -x "$(command -v jq)" ]; then
    echo "\033[0;32m✔️ jq installed\033[0m"
else
    brew install jq
fi;

# yq is a tool to parse yaml
echo "Installing yq - a tool for parsing yaml"
if [ -x "$(command -v yq)" ]; then
    echo "\033[0;32m✔️ yq installed\033[0m"
else
    brew install yq
fi;

# Manage meta repositories
echo "Installing meta - a tool for managing meta repositories"
if [ -x "$(command -v meta)" ]; then
    echo "\033[0;32m✔️ meta installed\033[0m"
else
    npm i -g meta
fi;

# Kubernetes CLI
echo "Installing kubectl - a tool for interacting with Kubernetes"
if [ -x "$(command -v kubectl)" ]; then
    echo "\033[0;32m✔️ kubectl installed\033[0m"
else
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    # Install tab completion
    echo "\nsource <(kubectl completion zsh)" >> ~/.zshrc
fi;

# alternative to curl that some scripts use
echo "Installing wget - a tool for downloading files"
if [ -x "$(command -v wget)" ]; then
    echo "\033[0;32m✔️ wget installed\033[0m"
else
    brew install wget
fi;

# KNative CLI
echo "Installing kn - a tool for interacting with KNative"
if [ -x "$(command -v kn)" ]; then
    echo "\033[0;32m✔️ kn installed\033[0m"
else
    brew install knative/client/kn
fi;

# Krew - kinda like "brew" for Kubernetes
# to remove krew: rm -rf -- ~/.krew  
echo "Installing krew - a tool for managing kubernetes plugins"
if [ -x "$(command -v kubectl-ctx)" ]; then
    echo "\033[0;32m✔️ krew installed\033[0m"
else
    (
        set -x; cd "$(mktemp -d)" &&
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" &&
        tar zxvf krew.tar.gz &&
        KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/')" &&
        "$KREW" install krew
    )
    echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
fi;

# Krew install commands are idempotent, meaning there is no harm in running them more than once.

# convenient for sharing/managing Kube configs when using tools like kops combined with sops
kubectl krew install konfig

# tool to switch kubectl context
kubectl krew install ctx

# tool to switch kubectl namespace
kubectl krew install ns

# Tool too interact with "schemahero" to manage SQL schemas declaratively
kubectl krew install schemahero
# End Krew Setup

# Localizer creates entries in your /etc/hosts file to make a remote cluster's internal addresses work locally,
# as if you were in the private network using kubernetes port-forwarding to do so.
echo "Installing localizer - a tool for managing /etc/hosts entries by mapping kubernetes services to local addresses"
if [ -x "$(command -v localizer)" ]; then
    echo "\033[0;32m✔️ localizer installed\033[0m"
else
    curl -Ls https://github.com/getoutreach/localizer/releases/download/v1.15.1/localizer_1.15.1_$(uname)_amd64.tar.gz | tar -xzC /usr/local/bin localizer
fi;

# Hasura CLI - Automated GraphQL server used with read model db in CQRS/ES system
# to remove hasura: rm /usr/local/bin/hasura
echo "Installing hasura - a tool for interacting with Hasura"
if [ -x "$(command -v hasura)" ]; then
    echo "\033[0;32m✔️ hasura installed\033[0m"
else
    echo "installing hasura ..."
    curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash
    
fi;

# Install Kubernetes "Helm charts" – sets of templatized resources for Kubernetes
echo "Installing helm - a tool for managing kubernetes charts"
if [ -x "$(command -v helm)" ]; then
    echo "\033[0;32m✔️ helm installed\033[0m"
else
    brew install helm
fi;

# kubernetes secret decoder
echo "Installing ksd - a tool for decoding kubernetes secrets"
if [ -x "$(command -v ksd)" ]; then
    echo "\033[0;32m✔️ ksd installed\033[0m"
else
    brew install mfuentesg/tap/ksd
fi;

# argocd - a tool for managing kubernetes deployments
echo "Installing argocd - a tool for managing kubernetes deployments"
if [ -x "$(command -v argocd)" ]; then
    echo "\033[0;32m✔️ argocd installed\033[0m"
else
    brew install argocd/tap/argocd
fi;

# argocd-autopilot - a tool for managing argocd
echo "Installing argocd-autopilot - a tool for managing argocd"
if [ -x "$(command -v argocd-autopilot)" ]; then
    echo "\033[0;32m✔️ argocd-autopilot installed\033[0m"
else
    brew install argocd-autopilot/tap/argocd-autopilot
fi;

# install complete
echo "\033[0;32m✔️ All tools installed\033[0m"