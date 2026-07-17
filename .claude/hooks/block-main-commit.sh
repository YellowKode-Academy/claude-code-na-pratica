#!/bin/bash
# Bloqueia commits diretos na branch principal (main ou master).
# Disparado em PreToolUse para qualquer chamada de Bash.

input=$(cat)
command=$(echo "$input" | python3 -c "import sys,json; data=json.load(sys.stdin); print(data.get('tool_input', {}).get('command', ''))" 2>/dev/null || echo "")

if [[ "$command" != *"git commit"* ]]; then
  exit 0
fi

branch=$(git branch --show-current)

if [[ "$branch" == "main" || "$branch" == "master" ]]; then
  echo "Commit direto em '$branch' bloqueado. Crie uma branch de trabalho antes de commitar." >&2
  exit 2
fi

exit 0
