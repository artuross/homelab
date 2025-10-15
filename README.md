# homelab

Hey there! Welcome to my homelab repository. This is where I store all the setup for my homelab environment.

I also have [a series of posts](http://rcwz.pl/series/talos-cluster-on-raspberry-pi-5/) on my blog that describe my setup (this is working in progress).

## hardware

I currently have a tiny setup with only 2 Raspberry Pi 5 devices. This will grow once I unblock my remaining Pis and will have a need for more resources.

| device         | role          | hostname | memory | disk       | ip address   |
| -------------- | ------------- | -------- | ------ | ---------- | ------------ |
| Raspberry Pi 5 | control plane | rpi51    | 8GB    | 512GB NVMe | 192.168.0.82 |
| Raspberry Pi 5 | worker        | rpi52    | 8GB    | 512GB NVMe | 192.168.0.94 |

## software

### Talos

At the core of the setup is [Talos](https://talos.dev/). Config is stored in `/talos`.

### Kubernetes

All Kubernetes related stuff is stored in `/kubernetes`.

- `/kubernetes/bootstrap` contains manifests for bootstrapping the cluster resources (mostly secrets).
- `/kubernetes/cluster` contains cluster-wide resources and things that don't belong to any particular operator. Right now, it contains namespaces and ArgoCD's `Application` resources.
- `/kubernetes/core` contains core applications - mostly operators, such as ArgoCD, Cilium, Tailscale Operator, etc. that add value to the cluster. Each directory inside is further split into 3 directories:
  - `/_source` - contains Helm chart and `values.yaml`
  - `/app` - contains rendered manifests and any additional resources or patches
  - `/crds` - contains CRDs as generated/required by the operator

Unlike in most setups, I don't group applications into namespaces (e.g. monitoring, logging, etc.). Instead, each application lives in its own namespace.
