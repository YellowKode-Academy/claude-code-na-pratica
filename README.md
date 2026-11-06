# Claude Code in Practice: Companion Repository

> **English edition.** You are on the `en` branch, the companion of the book **Claude Code in Practice**.
> Clone it with: `git clone -b en https://github.com/YellowKode-Academy/claude-code-na-pratica.git`
> The `main` branch holds the original Portuguese edition (*Claude Code na Prática*). Same project, with the configuration updated to the Claude Code documentation of November 2026.

This is the running project of the book **Claude Code in Practice** by Kelvin Baumhardt Biffi (YellowKode Academy).

## What this project is

An **autonomous PR reviewer** built across the book's 11 chapters. Each chapter adds one layer to the system:

| Chapter | Layer added |
|---|---|
| Ch. 1 | Minimal CLAUDE.md |
| Ch. 2 | CLAUDE.md expanded with conventions and criteria |
| Ch. 3 | `src/pr_validator.py` + `tests/` (built-in tools) |
| Ch. 4 | `mcp-ci-status/` + `.mcp.json` (CI MCP server) |
| Ch. 5 | `.claude/agents/tests.md` (first subagent) |
| Ch. 6 | `.claude/agents/security.md` + `style.md` (parallel) |
| Ch. 7 | `.claude/skills/pr-security-checklist/` |
| Ch. 8 | `security-review-plugin/` (distributable plugin) |
| Ch. 9 | `.claude/settings.json` with calibrated permissions |
| Ch. 10 | `.claude/hooks/block-main-commit.sh` |
| Ch. 11 | Complete system running autonomously |

## Repository layout

```
.
├── CLAUDE.md                          # Persistent project context
├── .mcp.json                          # Project MCP server (ci-status)
├── requirements.txt                   # Python dependencies
├── src/
│   └── pr_validator.py               # PR validator
├── tests/
│   └── test_pr_validator.py          # Validator tests
├── mcp-ci-status/
│   ├── package.json
│   └── server.js                     # CI status MCP server
├── tasks/                            # Review reports per PR
├── .claude/
│   ├── settings.json                 # Permissions + hooks
│   ├── agents/
│   │   ├── tests.md                  # Subagent: test coverage
│   │   ├── security.md               # Subagent: security
│   │   └── style.md                  # Subagent: style and conventions
│   ├── skills/
│   │   └── pr-security-checklist/
│   │       └── SKILL.md              # Security checklist
│   └── hooks/
│       └── block-main-commit.sh      # Hook: blocks commits to main
└── security-review-plugin/           # Distributable plugin (Ch. 8)
    ├── .claude-plugin/plugin.json     # Plugin manifest
    ├── skills/pr-security-checklist/
    ├── agents/security-agent.md
    └── hooks/                         # hooks.json + block-secrets-commit.sh
```

## How to use

```bash
# Run the tests
pytest tests/ -v

# Start the CI MCP server (Claude Code manages it automatically)
node ./mcp-ci-status/server.js

# Review a PR with the complete system
# Open Claude Code in this repository and ask:
# "Review PR #NNN using the security, tests and style subagents in parallel."
```

## Prerequisites

- Python 3.12+
- Node.js 18+ (for the MCP server)
- Claude Code CLI
- `python3` available on the PATH (the hooks use it to read the JSON input)

## The book

**Claude Code in Practice** by Kelvin Baumhardt Biffi, YellowKode Academy. Available on Amazon Kindle.
