#!/bin/bash
set -e

# Couldn't get kvm to work under WSL 2, which is required when setting
# dockerTools.buildImage.runAsRoot

HOST=do-nix-builder

DRV=$(nix-instantiate image.nix)
nix-copy-closure --to $HOST $DRV
OUT=$(ssh $HOST nix-store --realise $DRV)
nix-copy-closure --from $HOST $OUT

echo OUT: $OUT

docker load -i $OUT
