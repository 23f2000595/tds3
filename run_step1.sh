#!/bin/bash
set -e

# Environment
export GITHUB_USER="23f2000595"
export MY_SECRET_KEY="supersecret123"
export EVAL_URL="http://127.0.0.1:8000/api-endpoint"

TASK="streak_project"
BRIEF="My minimal test app"
EXPECTED_SECRET="$MY_SECRET_KEY"
SECRET="$MY_SECRET_KEY"

# Secret check
if [ "$SECRET" != "$EXPECTED_SECRET" ]; then
  echo "Secret mismatch! Exiting."
  exit 1
fi

# Use current directory
APP_DIR=$(pwd)
echo "<!DOCTYPE html><html><head><title>$TASK</title></head><body><h1>$BRIEF</h1></body></html>" > "$APP_DIR/index.html"

# Stage changes
git add .

# Commit if there are changes
if ! git diff-index --quiet HEAD --; then
    git commit -m "auto update $(date)"
fi

# Pull remote changes safely
git pull origin main --rebase || echo "Remote already up-to-date"

# Push local commits
git push origin main || echo "Push failed, check remote URL"

# Optional: send POST request
if [ ! -z "$EVAL_URL" ]; then
  COMMIT_SHA=$(git rev-parse HEAD)
  curl -X POST "$EVAL_URL" \
    -H "Content-Type: application/json" \
    -d "{\"task\": \"$TASK\", \"brief\": \"$BRIEF\", \"commit\": \"$COMMIT_SHA\"}" || echo "POST failed"
fi
