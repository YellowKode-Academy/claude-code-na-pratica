#!/bin/bash
# Bloqueia commits diretos na branch principal (main ou master).
# Disparado em PreToolUse para qualquer chamada de Bash.

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // ""')

if [[ "$command" != *"git commit"* ]]; then
  exit 0
fi

branch=$(git branch --show-current)

if [[ "$branch" == "main" || "$branch" == "master" ]]; then
  echo "Commit direto em '$branch' bloqueado. Crie uma branch de trabalho antes de commitar." >&2
  exit 2
fi

exit 0
