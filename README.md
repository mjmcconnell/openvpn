# OpenVPN on AWS

This repo is setup to provision an EC2 image on AWS for running an OpenVPN instance. Terraform will also deploy a sample EC2 instance behind a private subnet, that you can connect to via the OpenVPN connection

## Installation
This tool chain has been developed, to be run with Docker, so you will need Docker and Docker Compose to be installed.
Head over to the installation page [here](https://docs.docker.com/install/), and install the correct client for your OS.

## Setup

### Bash
The bash scripts used in this repo require the use of the `JQ` library. On Mac you can install this via brew using:

    brew install jq

### Packer
Packer requires access to the infrascture that will be hosting all images built, so an assoicated access account is required to be setup prior, with the correct permissions for creating new assets.

There is an example AWS IAM policy in the `packer` directory, with all the correct resources listed.

Once the account has been created, create a new file the `/packer/secrets.tfvars` using the contents of `/packer/secrets.tfvars.example`.
Replace the `aws_access_key` and `aws_secret_key` with the credentials of the packer aws user you created.

Next source the GitLab CI Runner secrets from your GitLab instance. Simply go to your projects page -> settings -> CI / CD, and under "Set up a specific Runner manually" copy the URL and registration token.
Use this values to replace the `gitlab_url` and `gitlab_token` default values

### Terraform

Similar to Packer, Terraform will also need to the infrastructure it will be building onto of.
Create a new user for the Terraform client to use (again a sample policy doc is provided in the `/terraform` directory).

Once the account has been created, create a new file the `/terraform/secrets.tfvars.example` using the contents of `/terraform/secrets.tfvars.example`.
Replace the `aws_access_key` and `aws_secret_key` with the credentials of the terraform aws user you created.

## Running

First create an SSH key, that will be used to allow SSH access to the images that will be created. Simply run:

    make keygen.generate

Generate an AMI for each image:

    make packer.build

Deploy the infrastructure and AMI instances:

    make terraform.deploy

## Cleanup

Packer images (AMI's and snapshots) can not be automatically cleaned up in this current build.

To clean up Terraform generated resources (EC2 instance, Security Group, Key Pair), simply run:

    make terraform.destroy
