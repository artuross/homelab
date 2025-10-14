#!/usr/bin/env nu

# create the secrets directory
mkdir kubernetes/bootstrap/secrets

# create Cilium secrets
mkdir kubernetes/bootstrap/secrets/cilium
op read --no-newline "op://homelab/addons.cilium.ca/ca.crt" | save --force kubernetes/bootstrap/secrets/cilium/ca.crt
op read --no-newline "op://homelab/addons.cilium.ca/ca.key" | save --force kubernetes/bootstrap/secrets/cilium/ca.key
op read --no-newline "op://homelab/addons.cilium.hubble-server-certs/tls.crt" | save --force kubernetes/bootstrap/secrets/cilium/tls.crt
op read --no-newline "op://homelab/addons.cilium.hubble-server-certs/tls.key" | save --force kubernetes/bootstrap/secrets/cilium/tls.key

# create 1Password secrets
mkdir kubernetes/bootstrap/secrets/1password-connect
op read --no-newline "op://homelab/addons.1password.credentials/1password-credentials.json" | save --force kubernetes/bootstrap/secrets/1password-connect/1password-credentials.json
op read --no-newline "op://homelab/addons.1password.tokens/token" | save --force kubernetes/bootstrap/secrets/1password-connect/token

# create CRDs
kubectl apply --server-side --kustomize kubernetes/core/argocd/crds
kubectl apply --server-side --kustomize kubernetes/core/external-secrets/crds

# create namespaces
kubectl apply --kustomize kubernetes/cluster/namespaces

# create secrets
kubectl apply --kustomize kubernetes/bootstrap

# deploy apps
kubectl apply --kustomize kubernetes/core/1password-connect/app
kubectl apply --kustomize kubernetes/core/argocd/app
kubectl apply --kustomize kubernetes/core/cilium/app
kubectl apply --kustomize kubernetes/core/external-secrets/app
