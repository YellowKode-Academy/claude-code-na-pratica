# Changelog

## [1.0.1] - 2026-11-07

### Corrigido
- Manifesto em `.claude-plugin/plugin.json`, subagente em `agents/` e hook registrado em `hooks/hooks.json`, o layout que o Claude Code carrega.
- Subagente com `name:` e sem `permissionMode: readOnly`, que não existe; a restrição de leitura vem de `tools`.
- Skill com `name:` e `description:` no frontmatter.
- Hook de secrets lê `git diff HEAD` em `git commit -a` e falha fechado quando não consegue ler a entrada.

## [1.0.0] - 2026-07-17

### Adicionado
- Skill de checklist de segurança para revisão de PRs (5 itens: secrets, injeção, parametrização, permissões, CVEs)
- Subagente `security-agent` com acesso restrito a leitura (Read, Grep, Glob)
- Hook `block-secrets-commit.sh` que bloqueia commits com padrões de API keys, tokens Bearer e chaves reconhecíveis
