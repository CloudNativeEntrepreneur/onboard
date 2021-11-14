#!/bin/sh
mkdir -p ~/.aws

if [[ -z "$AWS_PROFILE" ]]; then
  echo "Environment variable AWS_PROFILE is required"
  exit 1
fi

if [[ -z "$AWS_REGION" ]]; then
  echo "Environment variable AWS_REGION is required"
  exit 1
fi

if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
  echo "Environment variable AWS_ACCESS_KEY_ID is required"
  exit 1
fi

if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
  echo "Environment variable AWS_SECRET_ACCESS_KEY is required"
  exit 1
fi

# If config exists, append new profile, otherwise create the config file with the profile in it
CONFIG=~/.aws/config
if test -f "$CONFIG"; then
    echo "\n\n[profile $AWS_PROFILE]\nregion=$AWS_REGION\noutput=json" >> $CONFIG
else 
    echo "[default]\nregion=us-east-1\noutput=json\n\n[profile $AWS_PROFILE]\nregion=$AWS_REGION\noutput=json" >> $CONFIG
fi

# If credentials exists, append new profile, otherwise create the credentials file with the profile in it
CREDS=~/.aws/credentials
if test -f "$CREDS"; then
    echo "\n\n[$AWS_PROFILE]\naws_access_key_id = $AWS_ACCESS_KEY_ID\naws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> $CREDS
else 
    echo "[default]\naws_access_key_id = setdefault\naws_secret_access_key = setdefault\n\n[$AWS_PROFILE]\naws_access_key_id = $AWS_ACCESS_KEY_ID\naws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> $CREDS
fi