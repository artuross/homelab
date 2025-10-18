# remove old snapshots
print $"(ansi bo)(ansi white)Cleaning up snapshots...(ansi reset)"

(
    restic forget
    --host kubernetes
    --keep-monthly 2
    --keep-weekly 6
    --keep-within 7d
    --repo $"s3:($env.CLOUDFLARE_R2_URL)"
)

print $"(ansi bo)(ansi white)Snapshots cleaned up...(ansi reset)"
