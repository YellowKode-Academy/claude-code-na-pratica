#!/bin/bash
# Blocks commits whose staged diff contains recognizable secret patterns.
# Fired on PreToolUse for every Bash call that contains "git commit".

input=$(cat)
command=$(echo "$input" | python3 -c "import sys,json; data=json.load(sys.stdin); print(data.get('tool_input', {}).get('command', ''))" 2>/dev/null || echo "")

if [[ "$command" != *"git commit"* ]]; then
  exit 0
fi

secrets=$(git diff --cached | grep -E \
  '(sk-[a-zA-Z0-9]{20,}|AIza[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{20,}|Bearer [a-zA-Z0-9]{20,}|api.?key.{0,5}[a-zA-Z0-9]{16,})' \
  2>/dev/null)

if [[ -n "$secrets" ]]; then
  echo "Commit blocked: possible secret detected in the staged diff. Review it before committing." >&2
  exit 2
fi

exit 0
