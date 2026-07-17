# Changelog

## [1.0.0] - 2026-07-17

### Adicionado
- Skill de checklist de segurança para revisão de PRs (5 itens: secrets, injeção, parametrização, permissões, CVEs)
- Subagente `security-agent` com acesso restrito a leitura (Read, Grep, Glob)
- Hook `block-secrets-commit.sh` que bloqueia commits com padrões de API keys, tokens Bearer e chaves reconhecíveis
