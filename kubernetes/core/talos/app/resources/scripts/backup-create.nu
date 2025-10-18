# find control plane node
print $"(ansi bo)(ansi white)Fetching control plane node...(ansi reset)"
let controlPlaneNode = (
    kubectl get nodes --output json --selector node-role.kubernetes.io/control-plane
    | from json
    | get items.status.addresses
    | first
    | where type == 'InternalIP'
    | get address
    | first
)

print $"(ansi bo)(ansi white)Using ($controlPlaneNode) as control plane node..."

# optimize space
print $"(ansi bo)(ansi white)Defragmenting etcd to optimize space...(ansi reset)"
talosctl --nodes $controlPlaneNode --endpoints $controlPlaneNode etcd defrag

# snapshot to file
print $"(ansi bo)(ansi white)Creating etcd snapshot...(ansi reset)"
talosctl --nodes $controlPlaneNode --endpoints $controlPlaneNode etcd snapshot etcd.snapshot

# upload to restic repo
print $"(ansi bo)(ansi white)Uploading snapshot to restic repo...(ansi reset)"
(
    restic backup
    --host kubernetes
    --repo $"s3:($env.CLOUDFLARE_R2_URL)"
    etcd.snapshot
)

print $"(ansi bo)(ansi white)Backup created...(ansi reset)"

# clean up
print $"(ansi bo)(ansi white)Cleaning up...(ansi reset)"
rm etcd.snapshot
