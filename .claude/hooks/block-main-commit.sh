#!/bin/bash
# Bloqueia commits diretos na branch principal (main ou master).
# Disparado no PreToolUse de toda chamada Bash. Cobre só o Bash: se você adicionar uma
# ferramenta MCP que faça commit, registre este hook no matcher dela também.
# Teste: na main, peça ao Claude `git commit -am "teste"`. Tem que ser bloqueado.

input=$(cat)
PY=""
for c in python3 python; do
  if "$c" -c "" >/dev/null 2>&1; then PY=$c; break; fi
done
if [[ -z "$PY" ]]; then
  echo "Hook bloqueou o comando: python3 (ou python) não foi encontrado no PATH. Instale ou remova o hook." >&2
  exit 2
fi

detect() {
  "$PY" -c '
import sys, json, re
try:
    cmd = json.load(sys.stdin).get("tool_input", {}).get("command", "")
except Exception:
    print("error"); sys.exit(0)
for m in re.finditer(r"(?:^|[;&|(\s])git((?:\s+(?:-C|-c)\s+\S+|\s+--?[\w-]+(?:=\S+)?)*)\s+commit\b([^;&|]*)", cmd):
    opts, rest = m.group(1), m.group(2)
    d = re.search(r"-C\s+(\S+)", opts)
    d = d.group(1).strip("\"\x27") if d else "."
    mode = "all" if re.search(r"(?:^|\s)(?:-[A-Za-z]*a[A-Za-z]*|--all)(?=\s|$)", rest) else "commit"
    print(mode + "\t" + d); sys.exit(0)
print("none")
'
}

result=$(printf '%s' "$input" | detect 2>/dev/null)
if [[ -z "$result" || "$result" == "error" ]]; then
  echo "Hook bloqueou o comando: não consegui ler a entrada da ferramenta. Falhando fechado." >&2
  exit 2
fi
if [[ "$result" == "none" ]]; then
  exit 0
fi
mode=${result%%$'\t'*}
dir=${result#*$'\t'}

branch=$(git -C "$dir" branch --show-current 2>/dev/null)

if [[ "$branch" == "main" || "$branch" == "master" ]]; then
  echo "Commit direto na '$branch' bloqueado. Crie uma branch de trabalho antes de commitar." >&2
  exit 2
fi

exit 0
