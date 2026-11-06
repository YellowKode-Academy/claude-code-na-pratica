#!/bin/bash
# Blocks direct commits to the main branch (main or master).
# Fired on PreToolUse for every Bash call.

input=$(cat)
command=$(echo "$input" | python3 -c "import sys,json; data=json.load(sys.stdin); print(data.get('tool_input', {}).get('command', ''))" 2>/dev/null || echo "")

if [[ "$command" != *"git commit"* ]]; then
  exit 0
fi

branch=$(git branch --show-current)

if [[ "$branch" == "main" || "$branch" == "master" ]]; then
  echo "Direct commit to '$branch' blocked. Create a working branch before committing." >&2
  exit 2
fi

exit 0
