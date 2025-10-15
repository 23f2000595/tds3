#!/bin/bash
set -e

# --- Step 1: Environment setup ---
export GITHUB_USER="23f2000595"
export MY_SECRET_KEY="supersecret123"
export EVAL_URL="http://127.0.0.1:8000/api-endpoint"

TASK="streak_project"  # <-- use your existing project folder
BRIEF="My minimal test app"
EXPECTED_SECRET="$MY_SECRET_KEY"
SECRET="$MY_SECRET_KEY"

# --- Step 2: Secret check ---
if [ "$SECRET" != "$EXPECTED_SECRET" ]; then
  echo "❌ Secret mismatch! Exiting."
  exit 1
fi

# --- Step 3: Go into project folder ---
cd ~/"$TASK"

# --- Step 4: Make sure Git is initialized ---
git init -q

# --- Step 5: Add all changes ---
git add .

# --- Step 6: Commit with timestamp ---
git commit -m "auto: update $(date)" -q || echo "No changes to commit."

# --- Step 7: Push to GitHub ---
git push origin main

# --- Step 8: Optional: Send POST to evaluation URL ---
curl -X POST "$EVAL_URL" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$GITHUB_USER@example.com\",\"secret\":\"$MY_SECRET_KEY\",\"task\":\"$TASK\",\"brief\":\"$BRIEF\",\"evaluation_url\":\"$EVAL_URL\"}"

echo "✅ Step 1 completed successfully!"
