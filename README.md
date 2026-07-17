# Claude Code na Prática — Repositório Companion

Repositório do projeto-fio-condutor do livro **Claude Code na Prática** (IA na Prática Vol.9 — YellowKode Academy).

## O que é este projeto

Um **revisor de PR autônomo** construído ao longo dos 11 capítulos do livro. Cada capítulo adiciona uma camada ao sistema:

| Capítulo | Camada adicionada |
|---|---|
| Cap 1 | CLAUDE.md mínimo |
| Cap 2 | CLAUDE.md expandido com convenções e critérios |
| Cap 3 | `src/pr_validator.py` + `tests/` (tools nativas) |
| Cap 4 | `mcp-ci-status/` (servidor MCP de CI) |
| Cap 5 | `.claude/agents/testes.md` (primeiro subagente) |
| Cap 6 | `.claude/agents/seguranca.md` + `estilo.md` (paralelo) |
| Cap 7 | `.claude/skills/checklist-seguranca-pr/` |
| Cap 8 | `security-review-plugin/` (plugin distribuível) |
| Cap 9 | `.claude/settings.json` com permissões calibradas |
| Cap 10 | `.claude/hooks/block-main-commit.sh` |
| Cap 11 | Sistema completo em operação autônoma |

## Estrutura do repositório

```
.
├── CLAUDE.md                          # Contexto persistente do projeto
├── requirements.txt                   # Dependências Python
├── src/
│   └── pr_validator.py               # Validador de PRs
├── tests/
│   └── test_pr_validator.py          # Testes do validador
├── mcp-ci-status/
│   ├── package.json
│   └── server.js                     # Servidor MCP de status de CI
├── tasks/                            # Relatórios de revisão por PR
├── .claude/
│   ├── settings.json                 # Permissões + hooks + MCP
│   ├── agents/
│   │   ├── testes.md                 # Subagente: cobertura de testes
│   │   ├── seguranca.md              # Subagente: segurança
│   │   └── estilo.md                 # Subagente: estilo e convenções
│   ├── skills/
│   │   └── checklist-seguranca-pr/
│   │       └── SKILL.md              # Checklist de segurança
│   └── hooks/
│       └── block-main-commit.sh      # Hook: bloqueia commit em main
└── security-review-plugin/           # Plugin distribuível (Cap 8)
```

## Como usar

```bash
# Rodar os testes
pytest tests/ -v

# Iniciar o servidor MCP de CI (gerenciado automaticamente pelo Claude Code)
node ./mcp-ci-status/server.js

# Revisar um PR com o sistema completo
# Abra o Claude Code neste repositório e peça:
# "Revise o PR #NNN usando os subagentes de segurança, testes e estilo em paralelo."
```

## Pré-requisitos

- Python 3.12+
- Node.js 18+ (para o servidor MCP)
- Claude Code CLI
- `jq` instalado no sistema (para os hooks)

## Livro

**Claude Code na Prática** — disponível no Amazon KDP.
Série IA na Prática, Vol.9 — YellowKode Academy.
Autor: Kelvin Baumhardt Biffi
