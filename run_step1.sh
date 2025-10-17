#!/bin/bash
set -e

# --- Environment ---
GITHUB_USER="23f2000595"
MY_SECRET_KEY="supersecret123"
EVAL_URL="http://127.0.0.1:8000/api-endpoint"
TASK="streak_project"

# --- Round-Specific Briefs ---
# Default to Round 1 if ROUND is not set
ROUND=${ROUND:-1} 

if [ "$ROUND" -eq 2 ]; then
  BRIEF="Add a reset button to the streak counter app that sets the streak back to 0."
  COMMIT_MESSAGE="refactor: add reset button via LLM"
else
  BRIEF="A simple web app that tracks a user's daily streak."
  COMMIT_MESSAGE="feat: generate app via LLM and add LICENSE"
fi

# --- Go to project directory ---
cd ~/streak_project || exit

# --- Create the LICENSE file if it doesn't exist ---
if [ ! -f LICENSE ]; then
  echo "Creating LICENSE file..."
  cat > LICENSE << 'LICENSE_EOF'
MIT License
Copyright (c) 2025 23f2000595
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
LICENSE_EOF
fi

# --- LLM Code Generation (Build vs. Revise) ---
if [ "$ROUND" -eq 2 ]; then
  echo "Revising app code with LLM (Round 2)..."
  # Feed the existing file to the LLM to be modified
  cat index.html | llm "Modify this HTML code based on the new brief: '$BRIEF'" > index.html.tmp && mv index.html.tmp index.html
else
  echo "Generating app code with LLM (Round 1)..."
  # Generate the file from scratch
  llm "Generate a simple, single-file HTML page with CSS and JavaScript for the project brief: '$BRIEF'. The page should have a title, a button to increment the streak, and a display for the current streak count." > index.html
fi

# --- Git operations ---
echo "Committing and pushing changes..."
git add .
git commit -m "$COMMIT_MESSAGE" -m "Run at $(date)" || echo "No new changes to commit."
git push origin main

# --- Gather info for evaluation POST ---
echo "Gathering repository details..."
REPO_URL="https://github.com/$GITHUB_USER/tds3"
COMMIT_SHA=$(git rev-parse HEAD)
PAGES_URL="https://$GITHUB_USER.github.io/tds3/"

# --- Build the JSON payload ---
echo "Building JSON payload..."
JSON_PAYLOAD=$(cat <<EOP
{
  "email": "${GITHUB_USER}@example.com",
  "task": "$TASK",
  "round": $ROUND,
  "nonce": "nonce-$(date +%s)",
  "repo_url": "$REPO_URL",
  "commit_sha": "$COMMIT_SHA",
  "pages_url": "$PAGES_URL",
  "secret": "$MY_SECRET_KEY"
}
EOP
)

# --- Send POST request ---
echo "Sending POST to evaluation URL..."
curl -X POST "$EVAL_URL" \
  -H "Content-Type: application/json" \
  -d "$JSON_PAYLOAD"

echo ""
echo "Script finished successfully for Round $ROUND."
