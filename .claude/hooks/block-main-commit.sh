#!/bin/bash
# Blocks direct commits to the main branch (main or master).
# Fired on PreToolUse for every Bash call. Covers Bash only: if you add an MCP tool
# that can commit, register this hook for its matcher too.
# Try it: on main, ask Claude for `git commit -am "test"`. It must be blocked.

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

branch=$(git -C "$dir" branch --show-current 2>/dev/null)

if [[ "$branch" == "main" || "$branch" == "master" ]]; then
  echo "Direct commit to '$branch' blocked. Create a working branch before committing." >&2
  exit 2
fi

exit 0
