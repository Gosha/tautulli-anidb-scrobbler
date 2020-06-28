# Tautilli Anidb scrobbler

> Auto scrobble to anidb using Tautilli notification agents

# Build docker image

With KVM enabled OS:

```bash
docker load -i $(nix-store --realise $(nix-instantiate ./image.nix))
```

Without KVM

```bash
docker load -i $(NIX_CONF_DIR=`pwd`/etc nix-store --realise $(nix-instantiate ./image.nix --arg hasKvm false))
```

With remote builder

```bash
./remote-builder.sh
```
