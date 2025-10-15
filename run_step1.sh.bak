#!/bin/bash
set -e

# --- Step 1: Environment setup ---
export GITHUB_USER="23f2000595"
export MY_SECRET_KEY="supersecret123"
export EVAL_URL="http://127.0.0.1:8000/api-endpoint"

TASK="mytask"
BRIEF="My minimal test app"
EXPECTED_SECRET="$MY_SECRET_KEY"
SECRET="$MY_SECRET_KEY"

# --- Step 2: Secret check ---
if [ "$SECRET" != "$EXPECTED_SECRET" ]; then
  echo "❌ Secret mismatch! Exiting."
  exit 1
fi

# --- Step 3: Create app folder ---
APP_DIR="$TASK"
mkdir -p "$APP_DIR"
echo "<!DOCTYPE html><html><head><title>$TASK</title></head><body><h1>$BRIEF</h1></body></html>" > "$APP_DIR/index.html"

# --- Step 4: Initialize git if not already ---
cd "$APP_DIR"
if [ ! -d ".git" ]; then
    git init -q
    git remote add origin "https://github.com/$GITHUB_USER/$TASK.git" || true
fi

# --- Step 5: Avoid adding nested repos from outer folder ---
git rm -r --cached . 2>/dev/null || true

# --- Step 6: Add changes, commit, and push ---
git add .
git commit -m "auto: update $(date '+%A %d %B %Y %I:%M:%S %p %z')" -q || true
git branch -M main
git push -u origin main

# --- Step 7: Send POST to evaluation URL ---
COMMIT_SHA=$(git rev-parse HEAD)
curl -X POST "$EVAL_URL" \
  -H "Content-Type: application/json" \
  -d "{
        \"email\": \"$GITHUB_USER@example.com\",
        \"secret\": \"$MY_SECRET_KEY\",
        \"task\": \"$TASK\",
        \"brief\": \"$BRIEF\",
        \"commit_sha\": \"$COMMIT_SHA\"
      }"

echo "✅ Step 1 completed successfully!"
