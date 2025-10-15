#!/bin/bash
set -e

# --- Environment ---
export GITHUB_USER="23f2000595"
export MY_SECRET_KEY="supersecret123"
export EVAL_URL="http://127.0.0.1:8000/api-endpoint"

TASK="streak_project"
BRIEF="My minimal test app"
EXPECTED_SECRET="$MY_SECRET_KEY"
SECRET="$MY_SECRET_KEY"

# --- Secret check ---
if [ "$SECRET" != "$EXPECTED_SECRET" ]; then
  echo "❌ Secret mismatch! Exiting."
  exit 1
fi

# --- Make a test change ---
echo "auto update $(date)" >> temp.txt

# --- Commit & Push ---
git add .
git commit -m "auto: update $(date)" || echo "No changes to commit"
git push origin main

# --- Optional: POST to evaluation URL ---
COMMIT_SHA=$(git rev-parse HEAD)
curl -X POST "$EVAL_URL" \
     -H "Content-Type: application/json" \
     -d "{\"message\": \"Access granted\", \"task_received\": \"$TASK\", \"brief_received\": \"$BRIEF\", \"commit_sha\": \"$COMMIT_SHA\"}"

echo "✅ Step 1 completed successfully!"
