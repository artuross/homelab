#!/usr/bin/env nu

# create the secrets directory
mkdir kubernetes/bootstrap/secrets

# create Cilium secrets
mkdir kubernetes/bootstrap/secrets/cilium
op read --no-newline "op://homelab/addons.cilium.ca/ca.crt" | base64 --decode | save --force kubernetes/bootstrap/secrets/cilium/ca.crt
op read --no-newline "op://homelab/addons.cilium.ca/ca.key" | base64 --decode | save --force kubernetes/bootstrap/secrets/cilium/ca.key
op read --no-newline "op://homelab/addons.cilium.hubble-server-certs/tls.crt" | base64 --decode | save --force kubernetes/bootstrap/secrets/cilium/tls.crt
op read --no-newline "op://homelab/addons.cilium.hubble-server-certs/tls.key" | base64 --decode | save --force kubernetes/bootstrap/secrets/cilium/tls.key

# create namespaces
kubectl apply --kustomize kubernetes/cluster/namespaces

# create secrets
kubectl apply --kustomize kubernetes/bootstrap

# deploy apps
kubectl apply --kustomize kubernetes/core/cilium/app
