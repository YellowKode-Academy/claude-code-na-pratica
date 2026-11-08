# Claude Code na Prática: repositório companion

> 🇺🇸 **English edition:** branch [`en`](https://github.com/YellowKode-Academy/claude-code-na-pratica/tree/en), companion of *Claude Code in Practice*.

Repositório do projeto que atravessa o livro **Claude Code na Prática** (IA na Prática Vol.9, YellowKode Academy).

## O que é este projeto

Um **revisor de PR autônomo** construído ao longo dos 11 capítulos do livro. Cada capítulo adiciona uma camada ao sistema:

| Capítulo | Camada adicionada |
|---|---|
| Cap 1 | CLAUDE.md mínimo |
| Cap 2 | CLAUDE.md expandido com convenções e critérios |
| Cap 3 | `src/pr_validator.py` + `tests/` (tools nativas) |
| Cap 4 | `mcp-ci-status/` + `.mcp.json` (servidor MCP de CI) |
| Cap 5 | `.claude/agents/testes.md` (primeiro subagente) |
| Cap 6 | `.claude/agents/seguranca.md` + `estilo.md` (paralelo) |
| Cap 7 | `.claude/skills/checklist-seguranca-pr/` |
| Cap 8 | `security-review-plugin/` (plugin distribuível) |
| Cap 9 | `.claude/settings.json` com permissões calibradas |
| Cap 10 | `.claude/hooks/block-main-commit.sh` |
| Cap 11 | `.github/workflows/pr-review.yml` (gatilho de CI com `claude -p`) |

## Estrutura do repositório

```
.
├── CLAUDE.md                          # Contexto persistente do projeto
├── .mcp.json                          # Servidor MCP do projeto (ci-status)
├── requirements.txt                   # Dependências Python
├── src/
│   └── pr_validator.py               # Validador de PRs
├── tests/
│   ├── test_pr_validator.py          # Testes do validador
│   └── test_hooks.py                 # Testes dos hooks (bash + git)
├── mcp-ci-status/
│   ├── package.json
│   └── server.js                     # Servidor MCP de status de CI
├── tasks/                            # Relatórios de revisão por PR
├── .claude/
│   ├── settings.json                 # Permissões + hooks
│   ├── agents/
│   │   ├── testes.md                 # Subagente: cobertura de testes
│   │   ├── seguranca.md              # Subagente: segurança
│   │   └── estilo.md                 # Subagente: estilo e convenções
│   ├── skills/
│   │   └── checklist-seguranca-pr/
│   │       └── SKILL.md              # Checklist de segurança
│   └── hooks/
│       └── block-main-commit.sh      # Hook: bloqueia commit em main
├── .github/workflows/pr-review.yml   # Gatilho de CI do revisor (Cap 11)
└── security-review-plugin/           # Plugin distribuível (Cap 8)
    ├── .claude-plugin/plugin.json     # Manifesto do plugin
    ├── skills/checklist-seguranca-pr/
    ├── agents/security-agent.md
    └── hooks/                         # hooks.json + block-secrets-commit.sh
```

## Como usar

```bash
# Rodar os testes (inclui os testes dos hooks, que precisam de bash e git)
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
- `python3` ou `python` no PATH (os hooks usam para ler a entrada em JSON)
- Para o workflow de CI: o secret `ANTHROPIC_API_KEY` nas configurações do repositório

## Correções em relação ao texto do livro

Este repositório foi atualizado depois da publicação para seguir a documentação atual do Claude Code (novembro de 2026). Se o trecho do livro e o arquivo daqui divergirem, vale o arquivo daqui:

- **Subagentes (Cap 5, 6 e 8).** Todo arquivo de subagente tem `name:`, que é obrigatório; sem ele o subagente não carrega. Saiu `permissionMode: readOnly`, que não existe: a restrição de leitura vem do campo `tools`. O `model` usa os aliases `opus` e `sonnet`.
- **Skill (Cap 7).** O frontmatter usa `name:` e `description:`. As chaves em português (`nome:`, `descricao:`) não são lidas pelo Claude Code.
- **MCP (Cap 4).** O servidor do projeto fica em `.mcp.json`, com a variável escrita como `${CI_API_TOKEN}`, e não dentro do `settings.json`.
- **Plugin (Cap 8).** O manifesto fica em `.claude-plugin/plugin.json`, o subagente em `agents/` e o hook é registrado em `hooks/hooks.json` com `${CLAUDE_PLUGIN_ROOT}`.
- **Hooks (Cap 10).** O caminho do hook usa `${CLAUDE_PROJECT_DIR}`. Os scripts são mais rígidos que a versão do livro:
  - reconhecem `git -C <pasta> commit` e comandos encadeados como `git add . && git commit`;
  - com `git commit -a`, o hook de secrets lê `git diff HEAD`, porque os arquivos só entram no stage na hora do commit e o `git diff --cached` viria vazio;
  - falham fechado: se não conseguem ler a entrada ou não acham um Python que funcione, bloqueiam a chamada Bash em vez de liberar.

  O `tests/test_hooks.py` testa cada caso. Rode depois de mudar um hook.
- **Gatilho de CI (Cap 11).** O capítulo descreve o gatilho em termos gerais. O `.github/workflows/pr-review.yml` é uma versão concreta: o Claude Code roda em modo headless a cada pull request, grava a revisão num arquivo, e um passo separado publica o comentário.

## Livro

**Claude Code na Prática**, disponível na Amazon. Série IA na Prática, Vol.9, YellowKode Academy.
Autor: Kelvin Baumhardt Biffi.
