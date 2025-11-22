#!/bin/sh
set -euo pipefail

POD_NAME="redmine"
PG_VOL="pgdata"
REDMINE_VOL="redmine-files"
REDMINE_PLUGINS_VOL="redmine-plugins"

echo ">>> Creating pod: $POD_NAME (if not exists)"
podman pod exists "$POD_NAME" || podman pod create --name "$POD_NAME" -p 3000:3000

echo ">>> Creating volume: $PG_VOL"
podman volume exists "$PG_VOL" || podman volume create "$PG_VOL"

echo ">>> Creating volume: $REDMINE_VOL"
podman volume exists "$REDMINE_VOL" || podman volume create "$REDMINE_VOL"

echo ">>> Creating volume: $REDMINE_PLUGINS_VOL"
podman volume exists "$REDMINE_PLUGINS_VOL" || podman volume create "$REDMINE_PLUGINS_VOL"

echo ">>> Creating postgres container"
podman container exists postgres || podman create -it \
  --name postgres \
  --pod "$POD_NAME" \
  -e POSTGRES_USER=redmine \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=redmine \
  -v "$PG_VOL":/var/lib/postgresql/data:Z \
  registry.ext.d2ux.net/v2/postgresql:latest

echo ">>> Creating redmine container"
podman container exists redmine || podman create -it \
  --name redmine \
  --pod "$POD_NAME" \
  -e DB_HOST=localhost \
  -e DB_PORT=5432 \
  -e DB_NAME=redmine \
  -e DB_USER=redmine \
  -e DB_PASS=secret \
  -e REDMINE_HOST=localhost:3000 \
  -e REDMINE_PROTOCOL=http \
  -e SMTP_ENABLED=false \
  -v "$REDMINE_VOL":/app/redmine/files:Z \
  -v "$REDMINE_PLUGINS_VOL":/app/redmine/plugins:Z \
  registry.ext.d2ux.net/v2/redmine:latest

echo ">>> Starting pod"
podman pod start "$POD_NAME"

echo ">>> Done! Redmine is reachable on http://localhost:3000"
