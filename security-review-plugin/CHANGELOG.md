# Changelog

## [1.0.0] - 2026-07-17

### Added
- Security checklist skill for PR reviews (5 items: secrets, injection, parameterization, permissions, CVEs)
- `security-agent` subagent with read-only access (Read, Grep, Glob)
- `block-secrets-commit.sh` hook that blocks commits containing API key patterns, Bearer tokens and recognizable keys
