#!/bin/bash
# Bloqueia commits cujo diff contém padrões reconhecíveis de secret.
# Disparado no PreToolUse de toda chamada Bash. Com `git commit -a` os arquivos só entram
# no stage na hora do commit, então o hook lê `git diff HEAD` em vez de `git diff --cached`.
# Teste: ponha no stage um arquivo com uma chave falsa `sk-` de 20+ caracteres e peça o commit.

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

if [[ "$mode" == "all" ]] && git -C "$dir" rev-parse --verify -q HEAD >/dev/null; then
  diff=$(git -C "$dir" diff HEAD 2>/dev/null)
else
  diff=$(git -C "$dir" diff --cached 2>/dev/null)
fi

secrets=$(printf '%s\n' "$diff" | grep -E \
  '(sk-[a-zA-Z0-9]{20,}|AIza[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{20,}|Bearer [a-zA-Z0-9]{20,}|api.?key.{0,5}[a-zA-Z0-9]{16,})')

if [[ -n "$secrets" ]]; then
  echo "Commit bloqueado: possível secret detectado no diff. Revise antes de commitar." >&2
  exit 2
fi

exit 0
