#!/bin/bash
# Blocks commits whose diff contains recognizable secret patterns.
# Fired on PreToolUse for every Bash call. With `git commit -a` the files are staged
# only at commit time, so the hook reads `git diff HEAD` instead of `git diff --cached`.
# Try it: stage a file with a fake `sk-` key of 20+ characters and ask for a commit.

input=$(cat)
PY=""
for c in python3 python; do
  if "$c" -c "" >/dev/null 2>&1; then PY=$c; break; fi
done
if [[ -z "$PY" ]]; then
  echo "Hook blocked the command: python3 (or python) was not found on the PATH. Install it or remove the hook." >&2
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
  echo "Hook blocked the command: could not read the tool input. Failing closed." >&2
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
  echo "Commit blocked: possible secret detected in the diff. Review it before committing." >&2
  exit 2
fi

exit 0
