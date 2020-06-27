# Tautilli Anidb scrobbler

> Auto scrobble to anidb using Tautilli notification agents

# Build docker image

With KVM enabled OS:

```bash
docker load -i $(nix-store --realise $(nix-instantiate ./image.nix))
```

With remote builder

```bash
./remote-builder.sh
```
