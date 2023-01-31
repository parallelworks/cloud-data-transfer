# cloud-data-transfer

Workflow to test data transfer speeds to and from cloud buckets

# Installation

Currently, the files here are not a true workflow, but a collection 
of scripts that will become the basis of a workflow.  As such,
installation of the files themselves is simply cloning this repo. 
However, there are dependencies on the various cloud service
providers' (CSP) command line interface (CLI) toolsets for actually
executing the data transfer and installing those tools is outlined
here.

## AWS

[AWS CLI installation instructions](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) 
provide the following example for installing 
**without** root priviledges:
```bash
# Create install directories you have write access to
mkdir -p $HOME/aws-cli
mkdir -p $HOME/bin

# Get the install files
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Unzips to ./aws
unzip -u awscliv2.zip

# Install
./aws/install -i $HOME/aws-cli -b $HOME/bin
```

To authenticate, you need to provide typical AWS credentials, e.g. 
declare environment variables
```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
```
or similar information in `~/.aws/credentials.

## GCE

## Azure


