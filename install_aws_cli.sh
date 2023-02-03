#!/bin/bash

echo Starting to install AWS CLI...

# Create install directories you have write access to
mkdir -p $HOME/aws-cli
mkdir -p $HOME/bin

# Get the install files
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzips to ./aws
unzip -u awscliv2.zip

# Install
./aws/install -i $HOME/aws-cli -b $HOME/bin

echo Done installing AWS CLI!

