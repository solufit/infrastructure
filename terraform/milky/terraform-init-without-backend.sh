#! /bin/bash

echo Initializing Terraform without backend...
terraform init -backend=false -upgrade

echo Running Terraform Format...
terraform fmt

echo Running Terraform Validate...
terraform validate
