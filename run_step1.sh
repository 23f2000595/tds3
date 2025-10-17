#!/bin/bash
set -e

# --- Environment ---
export GITHUB_USER="23f2000595"
export MY_SECRET_KEY="supersecret123"
export EVAL_URL="http://127.0.0.1:8000/api-endpoint"
TASK="streak_project"

# --- Git operations ---
echo "Committing and pushing changes..."
cd ~/streak_project || exit
# Create a change to ensure there's something to commit
echo "Auto-update: $(date)" >> commit_log.txt
git add .
git commit -m "auto: update $(date)" || echo "No new changes to commit."
git push origin main

# --- Gather info for evaluation POST ---
echo "Gathering repository details..."
REPO_URL_WITH_TOKEN=$(git remote get-url origin)
# Remove the token from the URL for the payload
REPO_URL=$(echo "$REPO_URL_WITH_TOKEN" | sed "s/ghp_[^@]*@//")
COMMIT_SHA=$(git rev-parse HEAD)
# Note: The project name on GitHub Pages is 'tds3'
PAGES_URL="https://$GITHUB_USER.github.io/tds3/"

# --- Build the JSON payload ---
echo "Building JSON payload..."
JSON_PAYLOAD=$(cat <<EOP
{
  "email": "${GITHUB_USER}@example.com",
  "task": "$TASK",
  "round": 1,
  "nonce": "nonce-$(date +%s)",
  "repo_url": "$REPO_URL",
  "commit_sha": "$COMMIT_SHA",
  "pages_url": "$PAGES_URL",
  "secret": "$MY_SECRET_KEY"
}
EOP
)

# --- Send POST request with the correct format ---
echo "Sending POST to evaluation URL..."
curl -X POST "$EVAL_URL" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD"

echo ""
echo "Script finished."
