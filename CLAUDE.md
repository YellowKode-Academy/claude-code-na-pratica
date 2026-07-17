# CLAUDE.md: Revisor de PR Autônomo

## O que este projeto faz

Analisa Pull Requests do GitHub e comenta automaticamente sobre segurança,
cobertura de testes e estilo de código, antes da revisão humana.

## Stack

Python 3.12, pytest, PyGithub para acesso à API do GitHub.

## Como rodar os testes

pytest tests/ -v

## Convenções do repositório

- Testes ficam em `tests/`, nomeados `test_<funcionalidade>.py`
- Toda função pública tem type hint e docstring de uma linha
- Commits seguem Conventional Commits (`feat:`, `fix:`, `chore:`)

## Áreas sensíveis (exigem aprovação humana explícita)

- `auth/`: autenticação e geração de tokens
- `billing/`: qualquer lógica de cobrança

## Critério de aprovação automática de PR

Só comente aprovação se: testes novos cobrem a mudança,
nenhuma área sensível foi tocada, e o diff tem menos de 200 linhas.

## Estado atual

Sistema completo com três subagentes paralelos (segurança, testes, estilo),
skill de checklist de segurança reutilizável e hook de bloqueio de commit
em branch protegida. Servidor MCP conectado ao pipeline de CI.
