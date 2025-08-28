# Tautilli Anidb scrobbler

> Auto scrobble to anidb using Tautilli notification agents

## Build docker image

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

## Updating

Run build command and then `docker-compose up -d`

## Configuration
### Web UI
Add a script notification agent to `/scripts`, `./anidb_scrobble.sh`, with *Watched* script arguments:

```
--media_type {media_type} --library_name {library_name} --filename {filename} --user_name {username}
```

### .env
```sh
ANIDB_USERNAME=
ANIDB_PASSWORD=
PLEX_USER=
# Supply mount points for shows. These two should have the same value
MOUNT_DIR_HOST=/home/...
MOUNT_DIR_CONTAINER=/home/...
# If you want notifications about scrobble status,
# Create another notification agent, and set the ID here
NOTIFIER_ID=
```
