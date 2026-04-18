#!/bin/bash
set -e

DEPLOY_DIR="_deploy"
DEPLOY_BRANCH="master"

echo "## Building site with Hugo"
hugo --minify

if [ ! -d "$DEPLOY_DIR" ]; then
  echo "## Setting up deploy directory"
  git clone --branch "$DEPLOY_BRANCH" "$(git remote get-url origin)" "$DEPLOY_DIR"
fi

echo "## Copying public/ to $DEPLOY_DIR"
rm -rf "$DEPLOY_DIR"/*
cp -r public/* "$DEPLOY_DIR"/
cp static/CNAME "$DEPLOY_DIR"/

cd "$DEPLOY_DIR"
git add -A
git commit -m "Site updated at $(date -u)"
echo "## Pushing to $DEPLOY_BRANCH"
git push origin "$DEPLOY_BRANCH"

echo "## Deploy complete"
