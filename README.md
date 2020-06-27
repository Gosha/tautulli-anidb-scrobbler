# Tautilli Anidb scrobbler

> Auto scrobble to anidb with Tautilli notifications

# Build docker image

With KVM enabled OS:

```bash
docker load -i $(nix-store --realise $(nix-instantiate ./image.nix))
```

With remote builder

```bash
./remote-builder.sh
```
