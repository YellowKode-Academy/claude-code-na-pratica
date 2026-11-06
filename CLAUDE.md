# CLAUDE.md: Autonomous PR Reviewer

## What this project does

Analyzes GitHub Pull Requests and comments automatically on security,
test coverage and code style, before the human review.

## Stack

Python 3.12, pytest, PyGithub for GitHub API access.

## How to run the tests

pytest tests/ -v

## Repository conventions

- Tests live in `tests/`, named `test_<feature>.py`
- Every public function has a type hint and a one-line docstring
- Commits follow Conventional Commits (`feat:`, `fix:`, `chore:`)

## Sensitive areas (require explicit human approval)

- `auth/`: authentication and token generation
- `billing/`: any billing logic

## Automatic PR approval criteria

Only comment an approval if: new tests cover the change,
no sensitive area was touched, and the diff has fewer than 200 lines.

## Current state

Complete system with three parallel subagents (security, tests, style),
a reusable security checklist skill and a hook that blocks commits
on a protected branch. MCP server connected to the CI pipeline.
