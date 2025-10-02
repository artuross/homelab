#!/usr/bin/env nu

# build installer image
(
    docker run
        --rm
        --tty
        --volume ./talos/.build:/out
        "ghcr.io/talos-rpi5/imager:v1.10.2-1-g8f0ce1e0b"
        installer
        --arch arm64
        --overlay-image "ghcr.io/talos-rpi5/sbc-raspberrypi5:7d04484-v1.10.0-1-gf7d2f72"
        --overlay-name rpi5
        --system-extension-image "ghcr.io/siderolabs/iscsi-tools:v0.2.0"
        --system-extension-image "ghcr.io/siderolabs/util-linux-tools:2.40.4"
)

# push image to registry
crane push ./talos/.build/installer-arm64.tar "ghcr.io/artuross/talos-installer:v1.10.2-rpi5"
