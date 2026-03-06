#!/usr/bin/env bash
set -euo pipefail

BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$BRANCH" = "master" ]; then
  echo "==> Deploying master to production worker: prolog-landesabgabe"
  npx wrangler deploy
else
  # Sanitize branch name for Cloudflare worker naming (lowercase, alphanumeric + hyphens)
  SAFE_BRANCH=$(echo "$BRANCH" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')
  WORKER_NAME="prolog-landesabgabe-${SAFE_BRANCH}"
  echo "==> Deploying branch '$BRANCH' to test worker: $WORKER_NAME"
  npx wrangler deploy --name "$WORKER_NAME"
fi
