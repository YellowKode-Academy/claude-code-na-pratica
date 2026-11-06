---
name: pr-security-checklist
description: Security checklist for reviewing Pull Requests. Use it whenever you analyze code changes for secrets, injection, permissions and vulnerable dependencies.
---

# Security Checklist for PRs

1. No credential, API key or token appears in plain text in the diff.
2. Every external input (route parameters, request body, query string)
   is validated before use.
3. Database queries use parameterization, never string concatenation.
4. Changes to permissions or access scopes come with an explicit justification
   in the PR description.
5. New dependencies have no open known CVE (check at
   https://osv.dev or with `pip-audit` / `npm audit`).
