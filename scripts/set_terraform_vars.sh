#!/bin/bash

function buildPackerTerraformVars () {
    # Extract the key variables from the `manifest.json` generated by the packer build command
    openvpn_ami_id="$(cat manifest.openvpn.json | jq -r .builds[0].artifact_id |  cut -d':' -f2)"
    ubuntu_ami_id="$(cat manifest.ubuntu.json | jq -r .builds[0].artifact_id |  cut -d':' -f2)"

    # Generate a clean packer.tfvars file with defaults still set
    cat terraform/packer.tfvars.example > "terraform/packer.tfvars"

    # Overwrite the defaults with values generated by Packer
    sed -i '.bak' s/##OPENVPN_AMI_ID##/${openvpn_ami_id}/g terraform/packer.tfvars
    sed -i '.bak' s/##UBUNTU_AMI_ID##/${ubuntu_ami_id}/g terraform/packer.tfvars
}

buildPackerTerraformVars
