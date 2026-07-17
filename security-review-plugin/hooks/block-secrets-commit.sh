#!/bin/bash
# Bloqueia commits que contenham padrões reconhecíveis de secrets no diff staged.
# Disparado em PreToolUse para qualquer chamada de Bash que contenha "git commit".

input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // ""')

if [[ "$command" != *"git commit"* ]]; then
  exit 0
fi

secrets=$(git diff --cached | grep -E \
  '(sk-[a-zA-Z0-9]{32,}|AIza[a-zA-Z0-9]{35}|ghp_[a-zA-Z0-9]{36}|Bearer [a-zA-Z0-9]{20,}|api[_-]?key["\047\s]*[:=]["\047\s]*[a-zA-Z0-9]{16,})' \
  2>/dev/null)

if [[ -n "$secrets" ]]; then
  echo "Commit bloqueado: possível secret detectado no diff staged. Revise antes de commitar." >&2
  exit 2
fi

exit 0
