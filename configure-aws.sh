#!/bin/sh
mkdir -p ~/.aws

# prompt for aws profile name
echo "Enter the name of the AWS profile you want to use"
read awsProfileName

# prompt for aws region
echo "Enter the AWS region you want to use"
read awsRegion

# prompt for aws access key id
echo "Enter your AWS access key id"
read awsAccessKeyId

# prompt for aws secret access key
echo "Enter your AWS secret access key"
read awsSecretAccessKey

# AWS CLI
echo "Installing AWS CLI - a tool for interacting with AWS"
if [ -x "$(command -v aws)" ]; then
    echo "\033[0;32m✔️ AWS CLI installed\033[0m"
else
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
fi;

# AWS authenticator - used with AWS CLI to access Kubernetes clusters based on IAM
echo "Installing AWS authenticator - a tool for authenticating with AWS"
if [ -x "$(command -v aws-iam-authenticator)" ]; then
    echo "\033[0;32m✔️ AWS IAM Authenticator installed\033[0m"
else
    brew install aws-iam-authenticator
fi;

# If config exists, append new profile, otherwise create the config file with the profile in it
CONFIG=~/.aws/config
if test -f "$CONFIG"; then
    echo "\n\n[profile $awsProfileName]\nregion=$awsRegion\noutput=json" >> $CONFIG
else 
    echo "[default]\nregion=us-east-1\noutput=json\n\n[profile $awsProfileName]\nregion=$awsRegion\noutput=json" >> $CONFIG
fi

# If credentials exists, append new profile, otherwise create the credentials file with the profile in it
CREDS=~/.aws/credentials
if test -f "$CREDS"; then
    echo "\n\n[$awsProfileName]\naws_access_key_id = $awsAccessKeyId\naws_secret_access_key = $awsSecretAccessKey" >> $CREDS
else 
    echo "[default]\naws_access_key_id = setdefault\naws_secret_access_key = setdefault\n\n[$awsProfileName]\naws_access_key_id = $awsAccessKeyId\naws_secret_access_key = $awsSecretAccessKey" >> $CREDS
fi