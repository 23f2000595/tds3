#!/bin/bash

# --- Configuration ---
TOTAL_CHECKS=7
COMPLETED_CHECKS=0

echo "🔍 Checking project status against official requirements..."
echo "----------------------------------------------------"

# 1. API Endpoint & Secret Check
if [ -f "main.py" ] && grep -q 'os.getenv("MY_SECRET_KEY")' main.py; then
  echo "✅ Build: API endpoint with secret verification is DONE."
  COMPLETED_CHECKS=$((COMPLETED_CHECKS + 1))
else
  echo "❌ Build: API endpoint (main.py) or secret check is PENDING."
fi

# 2. LLM Code Generation Check
if grep -q "llm " run_step1.sh; then
  echo "✅ Build: LLM-assisted code generation is IMPLEMENTED."
  COMPLETED_CHECKS=$((COMPLETED_CHECKS + 1))
else
  echo "❌ Build: LLM-assisted code generation is PENDING."
fi

# 3. GitHub Deployment Check
if grep -q "git push" run_step1.sh; then
  echo "✅ Build: Deployment to GitHub is IMPLEMENTED."
  COMPLETED_CHECKS=$((COMPLETED_CHECKS + 1))
else
  echo "❌ Build: Deployment to GitHub is PENDING."
fi

# 4. Evaluation POST Format Check
if [ -f "run_step1.sh" ] && grep -q "repo_url" run_step1.sh && grep -q "commit_sha" run_step1.sh && grep -q "pages_url" run_step1.sh; then
  echo "✅ Build: Ping to evaluation API with correct format is DONE."
  COMPLETED_CHECKS=$((COMPLETED_CHECKS + 1))
else
  echo "❌ Build: Ping to evaluation API is PENDING or has the wrong format."
fi

# 5. LICENSE File Check
if [ -f "LICENSE" ]; then
  echo "✅ Build: MIT LICENSE file is CREATED."
  COMPLETED_CHECKS=$((COMPLETED_CHECKS + 1))
else
  echo "❌ Build: MIT LICENSE file is PENDING."
fi

# 6. README.md File Check
if [ -f "README.md" ]; then
  echo "✅ Build: README.md file is CREATED."
  COMPLETED_CHECKS=$((COMPLETED_CHECKS + 1))
else
  echo "❌ Build: README.md file is PENDING."
fi

# 7. Revise (Round 2) Logic Check
if [ -f "main.py" ] && grep -q 'if.*round_number.*== 2' main.py; then
  echo "✅ Revise: Round 2 logic is IMPLEMENTED."
  COMPLETED_CHECKS=$((COMPLETED_CHECKS + 1))
else
  echo "❌ Revise: Round 2 logic is PENDING."
fi

# --- Summary ---
echo "----------------------------------------------------"

PERCENTAGE=$((COMPLETED_CHECKS * 100 / TOTAL_CHECKS))

echo "📊 Project Completion: $COMPLETED_CHECKS out of $TOTAL_CHECKS tasks done."
echo "Percentage: $PERCENTAGE%"
