# Changelog

## [1.0.1] - 2026-11-07

### Fixed
- The secrets hook reads `git diff HEAD` on `git commit -a` and fails closed when it cannot read its input.
- Manifest now carries the author field.

## [1.0.0] - 2026-07-17

### Added
- Security checklist skill for PR reviews (5 items: secrets, injection, parameterization, permissions, CVEs)
- `security-agent` subagent with read-only access (Read, Grep, Glob)
- `block-secrets-commit.sh` hook that blocks commits containing API key patterns, Bearer tokens and recognizable keys
