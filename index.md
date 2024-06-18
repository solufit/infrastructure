
# Index


<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [about](#about)
- [Operation Procedure Manual](#operation-procedure-manual)
- [trobleshooting](#trobleshooting)
- [Kubernetes](#kubernetes)
  - [Install ESO Kubernetes](#install-eso-kubernetes)
- [License](#license)

<!-- /code_chunk_output -->


## about

This repository is information and memo for our cloud infrastructure.

## Operation Procedure Manual

[Operation Procedure Manual Index](./docs/operation_manual/index.md)


## trobleshooting

https://qiita.com/mochizuki875/items/c69bb7fb2ef3a73dc1a9

## Kubernetes

### Install ESO Kubernetes

Install secrets store

This code from https://external-secrets.io/latest/provider/oracle-vault/

``` yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: example-instance-principal
spec:
  provider:
    oracle:
      vault: # The vault OCID
      region: # The vault region
      principalType: InstancePrincipal

---

apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: example-workload-identity
spec:
  provider:
    oracle:
      vault: # The vault OCID
      region: # The vault region
      principalType: Workload

---

apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: example-auth
spec:
  provider:
    oracle:
      vault: # The vault OCID
      region: # The vault region
      principalType: UserPrincipal
      auth:
        user: # A user OCID
        tenancy: # A user's tenancy
        secretRef:
          privatekey:
            name: oracle-secret
            key: privateKey
          fingerprint:
            name: oracle-secret
            key: fingerprint

```

Create External Secret

``` yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: example
spec:
  refreshInterval: 0.03m
  secretStoreRef:
    kind: SecretStore
    name: example # Must match SecretStore on the cluster
  target:
    name: secret-to-be-created # Name for the secret on the cluster
    creationPolicy: Owner
  dataFrom:
  - extract:
      key: the-secret-name
```

## License

This page's original contents are licensed under Apache License 2.0.
Other licenses are written in each page.
