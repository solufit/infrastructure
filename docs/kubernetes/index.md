# Kubernetes

This page contains how to use Kubernetes in this project.


## Index
<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Kubernetes](#kubernetes)
  - [Index](#index)
  - [Install FluxCD and GitRepository](#install-fluxcd-and-gitrepository)
    - [Install Fluxcd and kubectl](#install-fluxcd-and-kubectl)
    - [BootStrap FluxCD](#bootstrap-fluxcd)
      - [Bootstrap FluxCD](#bootstrap-fluxcd-1)
  - [Using Secrets](#using-secrets)

<!-- /code_chunk_output -->



## Install FluxCD and GitRepository

We use FluxCD and GitRepository to manage Kubernetes manifests.

This git repository was generated from [This template](https://github.com/fluxcd/flux2-kustomize-helm-example).

### Install Fluxcd and kubectl

Kubectl

This code from [Kubernetes Docs](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

```bash
# Download Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Install kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Completion
echo 'source <(kubectl completion bash)' >>~/.bashrc

```

Flux CLI

```bash
curl -s https://fluxcd.io/install.sh | sudo bash

# add completion
echo '. <(flux completion bash)' >>~/.bashrc
```

### BootStrap FluxCD

[Prepare](https://fluxcd.io/flux/installation/bootstrap/github/)

#### Bootstrap FluxCD

```bash
flux bootstrap github \
  --components-extra=image-reflector-controller,image-automation-controller \
  --token-auth \
  --owner=solufit \
  --repository=infrastructure \
  --branch=main \
  --path=clusters/production \

```

## Using Secrets

- [Install External Secret Operator](./secrets-install.md)
- [Using External Secrets](./secrets.md)
