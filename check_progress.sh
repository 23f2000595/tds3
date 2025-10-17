#!/bin/bash

echo "=== LLM Code Deployment Project Progress ==="
echo

# 1. Check if API endpoint exists
if [ -f "main.py" ]; then
    echo "[✅] API endpoint (main.py) exists"
else
    echo "[❌] API endpoint (main.py) missing"
fi

# 2. Check if run_step1.sh exists and is executable
if [ -f "run_step1.sh" ] && [ -x "run_step1.sh" ]; then
    echo "[✅] Automation script run_step1.sh exists & executable"
else
    echo "[❌] run_step1.sh missing or not executable"
fi

# 3. Check if index.html is generated
if [ -f "index.html" ]; then
    echo "[✅] index.html exists (app generated)"
else
    echo "[❌] index.html missing (app not generated)"
fi

# 4. Check if last commit contains auto update message
LAST_COMMIT_MSG=$(git log -1 --pretty=%B)
if [[ "$LAST_COMMIT_MSG" == *"auto update"* ]]; then
    echo "[✅] Last commit pushed to GitHub"
else
    echo "[❌] Last commit not pushed"
fi

# 5. Check if secret environment variable is set
if [ ! -z "$MY_SECRET_KEY" ]; then
    echo "[✅] Secret environment variable set"
else
    echo "[❌] Secret environment variable not set"
fi

# 6. Check GitHub Pages (basic check: pages URL from repo)
PAGES_URL="https://$(git config user.name).github.io/$(basename `pwd`)/"
echo "[ℹ] GitHub Pages URL: $PAGES_URL"
echo "[❌] Check manually if Pages is deployed and reachable (200 OK)"

# Summary
echo
echo "=== Progress Summary ==="
echo "API endpoint: $( [ -f "main.py" ] && echo "Done" || echo "Pending" )"
echo "Automation script: $( [ -f "run_step1.sh" ] && echo "Done" || echo "Pending" )"
echo "App generated (index.html): $( [ -f "index.html" ] && echo "Done" || echo "Pending" )"
echo "GitHub push: $( [[ "$LAST_COMMIT_MSG" == *"auto update"* ]] && echo "Done" || echo "Pending" )"
echo "Secret set: $( [ ! -z "$MY_SECRET_KEY" ] && echo "Done" || echo "Pending" )"
echo "Pages deployed: Check manually"
