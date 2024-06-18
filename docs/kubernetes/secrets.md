# Using External Secrets

We use Oracle Cloud Vault

## License

This Documents from [https://external-secrets.io/latest/provider/oracle-vault/](https://external-secrets.io/latest/provider/oracle-vault/)

[License Page](https://github.com/external-secrets/external-secrets/blob/main/LICENSE)


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
