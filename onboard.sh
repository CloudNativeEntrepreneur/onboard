#!/bin/sh
ORIGINAL_USER=$(whoami)

echo "Hello $(whoami),"
sleep 1
echo "I'm going to configure your computer for development now."
sleep 1
echo "I'll need a couple of things from you throughout the process"
echo "So I'll get them from you now..."
sleep 2

echo "Github requires a few global settings to be configured"
echo "Enter the email address associated with your GitHub account: "
read -r email
echo "Enter your full name (Ex. John Doe): "
read -r username

echo "Thank you. Beginning install now..."

# Install Homebrew
if [ -x "$(command -v brew)" ]; then
    echo "✔️ Homebrew installed"
else
    echo "Installing homebrew now..."
    mkdir -p /usr/local/var/homebrew
    sudo chown -R $(whoami) /usr/local/var/homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi;

#  Configure Git
if [ -x "$(command -v git)" ]; then
    echo "✔️ git installed"
else
    echo "Installing git..."
    brew install git
fi;


echo "Setting global git config with email $email and username $username ..."
git config --global --replace-all user.email "$email"
git config --global --replace-all user.name "$username"

# Add brew repos we will use
brew tap homebrew/cask
brew tap jenkins-x/jx

OH_MY_ZSH_CONFIG=~/.oh-my-zsh/oh-my-zsh.sh
if test -f "$OH_MY_ZSH_CONFIG"; then
  echo "✔️ oh-my-zsh installed"
else
  # Begin oh my zsh setup
  # Pretty, minimal shell with a couple useful plugins
  echo "Configuring Oh My ZSH"
  { # your 'try' block
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  } || { # your 'catch' block
      echo 'Oh My Zsh like to exit for some reasons so this prevents it'
  }

  # Configure ZSH  plugins
  echo "Configuring ZSH plugins"
  {
      git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
      git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
      sed -i .bak 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
  } || {
      echo 'Failed to configure zsh plugins'
  }
fi;
# End oh my zsh setup

# Sops is a useful tool for sharing, encrypting, and decrypting secrets in git
if [ -x "$(command -v sops)" ]; then
    echo "✔️ sops installed"
else
    brew install sops
fi;

# Docker
if [ -x "$(command -v docker)" ]; then
    echo "✔️ docker installed"
else
    brew install docker
fi;

# Terraform
if [ -x "$(command -v terraform)" ]; then
    echo "✔️ terraform installed"
else
    brew install terraform
fi;

# Begin Node.js setup
# This one's a bit weird - we're gonna install node, then use `npm` which comes with it to install `n`, and then switch to using `n` to manage node instead of `brew`.
if [ -x "$(command -v node)" ]; then
    echo "✔️ node installed"
else
    brew install node
fi;

if [ -x "$(command -v n)" ]; then
    echo "✔️ N - Node version manager installed with latest LTS of Node"
else
    echo "For n to work properly, you need to own homebrew stuff - setting $(whoami) as owner of $(brew --prefix)/*"
    sudo chown -R $(whoami) $(brew --prefix)/*
    npm install -g n
    sudo mkdir -p /usr/local/n
    sudo chown -R $(whoami) /usr/local/n
    # take ownership of node install destination folders
    sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
    # Use the latest version of Node
    echo "Using latest version of Node"
    n latest
    brew uninstall node
fi;
# End node.js setup

# Python is commonly used in scripts
if [ -x "$(command -v python)" ]; then
    echo "✔️ python installed"
else
    brew install python
fi;

# jq is a tool to parse json output in your shell
if [ -x "$(command -v jq)" ]; then
    echo "✔️ jq installed"
else
    brew install jq
fi;

# `safe` is used with Hashicorp's vault to store/read secrets
# it's useful to install and use from scripts
if [ -x "$(command -v safe)" ]; then
    echo "✔️ safe installed"
else
    brew tap starkandwayne/cf
    brew install starkandwayne/cf/safe
fi;

# AWS CLI
if [ -x "$(command -v aws)" ]; then
    echo "✔️ aws cli installed"
else
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
fi;

# AWS authenticator - used with AWS CLI to access Kubernetes clusters based on IAM
if [ -x "$(command -v aws-iam-authenticator)" ]; then
    echo "✔️ aws-iam-authenticator installed"
else
    brew install aws-iam-authenticator
fi;

# Manage meta repositories
if [ -x "$(command -v meta)" ]; then
    echo "✔️ meta installed"
else
    npm i -g meta
fi;

# Kubernetes CLI
if [ -x "$(command -v kubectl)" ]; then
    echo "✔️ kubectl installed"
else
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    # Install tab completion
    echo "\nsource <(kubectl completion zsh)" >> ~/.zshrc
fi;

# Jenkins X CLI - for interacting with JX, used for CI/CD with Kubernetes
if [ -x "$(command -v jx)" ]; then
    echo "✔️ jx installed"
else
    brew install jx
fi;

# alternative to curl that some scripts use
if [ -x "$(command -v wget)" ]; then
    echo "✔️ wget installed"
else
    brew install wget
fi;

# KNative CLI
if [ -x "$(command -v kn)" ]; then
    echo "✔️ kn installed"
else
    brew install knative/client/kn
fi;

# Krew - kinda like "brew" for Kubernetes
# to remove krew: rm -rf -- ~/.krew  
if [ -x "$(command -v kubectl-ctx)" ]; then
    echo "✔️ krew installed"
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
if [ -x "$(command -v localizer)" ]; then
    echo "✔️ localizer installed"
else
    curl -Ls https://github.com/getoutreach/localizer/releases/download/v1.12.1/localizer_1.12.1_$(uname)_amd64.tar.gz | tar -xzC /usr/local/bin localizer
fi;

# Istio CLI for interacting with istio installed on a kubernetes cluster
# to remove istioctl: rm ~/.istioctl  
if [ -x "$(command -v istioctl)" ]; then
    echo "✔️ istioctl installed"
else
    brew install istioctl
fi;

# Hasura CLI - Automated GraphQL server used with read model db in CQRS/ES system
# to remove hasura: rm /usr/local/bin/hasura
if [ -x "$(command -v hasura)" ]; then
    echo "✔️ hasura installed"
else
    echo "installing hasura ..."
    curl -L https://github.com/hasura/graphql-engine/raw/stable/cli/get.sh | bash
    
fi;

# K-in-D: Kubernetes in Docker - run kubernetes clusters locally with Docker
if [ -x "$(command -v kind)" ]; then
    echo "✔️ kind installed"
else
    brew install kind
fi;

# Install Kubernetes "Helm charts" – sets of templatized resources for Kubernetes
if [ -x "$(command -v helm)" ]; then
    echo "✔️ helm installed"
else
    brew install helm
fi;

# Add Helm repos
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add zalando-pgo-ui https://raw.githubusercontent.com/zalando/postgres-operator/v1.6.0/charts/postgres-operator-ui/
helm repo add zalando-pgo https://raw.githubusercontent.com/zalando/postgres-operator/v1.6.0/charts/postgres-operator/

# Other Mac Apps
if [ -x "$(command -v code)" ]; then
    echo "✔️ VS Code installed"
else
    brew install --cask visual-studio-code
fi;
echo "Configure VS Code extensions"
code    --install-extension ms-azuretools.vscode-docker \
        --install-extension marcostazi.VS-code-vagrantfile \
        --install-extension mauve.terraform \
        --install-extension formulahendry.code-runner \
        --install-extension mikestead.dotenv \
        --install-extension oderwat.indent-rainbow \
        --install-extension orta.vscode-jest \
        --install-extension christian-kohler.npm-intellisense \
        --install-extension sujan.code-blue \
        --install-extension waderyan.gitblame \
        --install-extension ms-vscode.go \
        --install-extension in4margaret.compareit \
        --install-extension andys8.jest-snippets \
        --install-extension euskadi31.json-pretty-printer \
        --install-extension yatki.vscode-surround \
        --install-extension wmaurer.change-case

# Gcloud CLI
if [ -x "$(command -v gcloud)" ]; then
    echo "✔️ gcloud installed"
else
    brew install --cask google-cloud-sdk
fi;

# ngrok
if [ -x "$(command -v ngrok)" ]; then
    echo "✔️ ngrok installed"
else
    brew install --cask ngrok
fi;

# kubernetes secret decoder
if [ -x "$(command -v ksd)" ]; then
    echo "✔️ ksd installed"
else
    brew install mfuentesg/tap/ksd
fi;

echo "Copying your SSH key to your clipboard"
pbcopy < ~/.ssh/id_rsa.pub
sleep 1
echo "Add the generated SSH key to your GitHub account. It has been copied to your clipboard"
echo "https://github.com/settings/keys"
